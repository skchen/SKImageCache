//
//  SKAsyncFileCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKAsyncFileCache.h"

@import OCHamcrest;
@import OCMockito;

@import SKUtils;

@interface SKAsyncFileCacheTests : XCTestCase <SKAsyncCacheLoader>

@end

@implementation SKAsyncFileCacheTests {
    SKAsyncFileCache *asyncFileCache;
    
    SKLruStorage *mockLruStorage;
    SKTaskQueue *taskQueue;
    id<SKLruCoster> mockCoster;
    id<SKAsyncCacheDelegate> mockDelegate;
    
    id<NSCopying> mockKey1;
    id mockObject1;
    
    id<NSCopying> mockKey2;
    NSError *mockError2;
}

- (void)setUp {
    [super setUp];
    
    mockLruStorage = mock([SKLruStorage class]);
    taskQueue = [[SKTaskQueue alloc] initWithOrderedDictionary:[[SKOrderedDictionary alloc] init]];
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockDelegate = mockProtocol(@protocol(SKAsyncCacheDelegate));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    mockObject1 = mock([NSObject class]);
    
    mockKey2 = mockProtocol(@protocol(NSCopying));
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    mockError2 = mock([NSError class]);
    
    asyncFileCache = [[SKAsyncFileCache alloc] initWithConstraint:1 andCoster:mockCoster andLoader:self andDelegate:mockDelegate andTaskQueue:taskQueue];
    [asyncFileCache setValue:mockLruStorage forKey:@"lruTable"];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - SKAsyncCacheLoader

- (void)loadObjectForKey:(id<NSCopying>)key success:(SuccessBlock)success failure:(FailureBlock)failure {
    if(key==mockKey1) {
        success(mockObject1);
    } else if(key==mockKey2) {
        failure(mockError2);
    }
}

@end
