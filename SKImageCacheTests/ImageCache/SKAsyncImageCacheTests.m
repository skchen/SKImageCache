//
//  SKAsyncImageCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKAsyncImageCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKAsyncImageCacheTests : XCTestCase<SKAsyncCacheLoader>

@end

@implementation SKAsyncImageCacheTests {
    SKAsyncImageCache *asyncImageCache;
    
    SKLruTable *mockLruTable;
    id<SKLruCoster> mockCoster;
    id<SKAsyncCacheDelegate> mockDelegate;
    SKAsyncFileCache *mockFileCache;
    SKTaskQueue *taskQueue;
    
    NSURL *mockRemoteUrl1;
    NSURL *mockLocalUrl1;
    UIImage *mockImage1;
    
    NSURL *mockRemoteUrl2;
    NSURL *mockLocalUrl2;
    NSError *mockError2;
}

- (void)setUp {
    [super setUp];
    
    mockLruTable = mock([SKLruTable class]);
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockDelegate = mockProtocol(@protocol(SKAsyncCacheDelegate));
    mockFileCache = mock([SKAsyncFileCache class]);
    
    taskQueue = [[SKTaskQueue alloc] init];
    
    mockRemoteUrl1 = mock([NSURL class]);
    [given([mockRemoteUrl1 copyWithZone:nil]) willReturn:mockRemoteUrl1];
    mockLocalUrl1 = mock([NSURL class]);
    [given([mockLocalUrl1 copyWithZone:nil]) willReturn:mockLocalUrl1];
    mockImage1 = mock([UIImage class]);
    
    mockRemoteUrl2 = mock([NSURL class]);
    [given([mockRemoteUrl2 copyWithZone:nil]) willReturn:mockRemoteUrl2];
    mockLocalUrl2 = mock([NSURL class]);
    [given([mockLocalUrl2 copyWithZone:nil]) willReturn:mockLocalUrl2];
    mockError2 = mock([NSError class]);
    
    asyncImageCache = [[SKAsyncImageCache alloc] initWithConstraint:1 andCoster:mockCoster andLoader:self andDelegate:mockDelegate andTaskQueue:taskQueue andFileCache:mockFileCache];
    [asyncImageCache setValue:mockLruTable forKey:@"lruTable"];
    
    [given([mockFileCache delegate]) willReturn:asyncImageCache];
    
    [givenVoid([mockFileCache cacheObjectForKey:mockRemoteUrl1]) willDo:^id(NSInvocation *invocation) {
        [mockFileCache.delegate asyncCache:mockFileCache didCacheObject:mockLocalUrl1 forKey:mockRemoteUrl1];
        return nil;
    }];
    
    [givenVoid([mockFileCache cacheObjectForKey:mockRemoteUrl2]) willDo:^id(NSInvocation *invocation) {
        [mockFileCache.delegate asyncCache:mockFileCache didCacheObject:mockLocalUrl2 forKey:mockRemoteUrl2];
        return nil;
    }];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldLoadObject_whenObjectIsNotCached {
    [given([mockLruTable objectForKey:mockRemoteUrl1]) willReturn:nil];
    
    [asyncImageCache cacheObjectForKey:mockRemoteUrl1];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockFileCache) cacheObjectForKey:mockRemoteUrl1];
    [verify(mockLruTable) setObject:mockImage1 forKey:mockRemoteUrl1];
    [verify(mockDelegate) asyncCache:asyncImageCache didCacheObject:mockImage1 forKey:mockRemoteUrl1];
}

- (void)test_shouldNotLoadObject_whenObjectIsCached {
    [given([mockLruTable objectForKey:mockRemoteUrl1]) willReturn:mockImage1];
    
    [asyncImageCache cacheObjectForKey:mockRemoteUrl1];
    [NSThread sleepForTimeInterval:1];
    
    [verifyCount(mockFileCache, never()) cacheObjectForKey:mockRemoteUrl1];
    [verifyCount(mockLruTable, never()) setObject:mockImage1 forKey:mockRemoteUrl1];
    [verify(mockDelegate) asyncCache:asyncImageCache didCacheObject:mockImage1 forKey:mockRemoteUrl1];
}

- (void)test_shouldGetError_whenObjectIsNotCachedAndUnableToLoad {
    [given([mockLruTable objectForKey:mockRemoteUrl2]) willReturn:nil];
    
    [asyncImageCache cacheObjectForKey:mockRemoteUrl2];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockDelegate) asyncCache:asyncImageCache failedToCacheObjectForKey:mockRemoteUrl2 withError:mockError2];
}

#pragma mark - SKAsyncCacheLoader

- (void)loadObjectForKey:(id<NSCopying>)key success:(SuccessBlock)success failure:(FailureBlock)failure {
    if(key==mockRemoteUrl1) {
        success(mockImage1);
    } else if(key==mockRemoteUrl2) {
        failure(mockError2);
    }
}

@end
