//
//  SKAsyncFileCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKFileCache.h"

@import OCHamcrest;
@import OCMockito;

@import SKUtils;

@interface SKFileCacheTests : XCTestCase <SKAsyncCacheLoader>

@end

@implementation SKFileCacheTests {
    SKFileCache *fileCache;
    
    SKLruStorage *mockLruStorage;
    SKTaskQueue *taskQueue;
    id<SKLruCoster> mockCoster;
    id<SKAsyncCacheDelegate> mockDelegate;
    
    Class mockArchiver;
    
    NSString *lruDictionarArchivePath;
    NSString *key1;
    NSString *url1;
    NSString *key2;
    NSError *error2;
}

- (void)setUp {
    [super setUp];
    
    mockLruStorage = mock([SKLruStorage class]);
    taskQueue = [[SKTaskQueue alloc] initWithOrderedDictionary:[[SKOrderedDictionary alloc] init] andConstraint:0 andQueue:nil];
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockDelegate = mockProtocol(@protocol(SKAsyncCacheDelegate));
    
    mockArchiver = mockClass([NSKeyedArchiver class]);
    
    lruDictionarArchivePath = @"lruDictionarArchivePath";
    key1 = @"key1";
    url1 = @"url1";
    key2 = @"key2";
    error2 = [NSError errorWithDomain:@"kError2" code:0 userInfo:nil];
    
    [given([mockArchiver archiveRootObject:mockLruStorage toFile:lruDictionarArchivePath]) willReturnBool:YES];
    
    fileCache = [[SKFileCache alloc] initWithPath:lruDictionarArchivePath andConstraint:1 andCoster:mockCoster andLoader:self andTaskQueue:taskQueue];
    fileCache.delegate = mockDelegate;
    [fileCache setValue:mockLruStorage forKey:@"lruDictionary"];
    [fileCache setValue:mockArchiver forKey:@"archiver"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldArchiveLruTable_whenObjectIsNotCached {
    [given([mockLruStorage objectForKey:key1]) willReturn:nil];
    
    [fileCache cacheObjectForKey:key1];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockLruStorage) setObject:url1 forKey:key1];
    [verify(mockArchiver) archiveRootObject:mockLruStorage toFile:lruDictionarArchivePath];
    [verify(mockDelegate) asyncCache:fileCache didCacheObject:url1 forKey:key1];
}

- (void)test_shouldNotArchiveLruTable_whenObjectIsCached {
    [given([mockLruStorage objectForKey:key1]) willReturn:url1];
    
    [fileCache cacheObjectForKey:key1];
    [NSThread sleepForTimeInterval:1];
    
    [verifyCount(mockLruStorage, never()) setObject:url1 forKey:key1];
    [verifyCount(mockArchiver, never()) archiveRootObject:mockLruStorage toFile:lruDictionarArchivePath];
    [verify(mockDelegate) asyncCache:fileCache didCacheObject:url1 forKey:key1];
}

#pragma mark - SKAsyncCacheLoader

- (void)loadObjectForKey:(id<NSCopying>)key success:(SuccessBlock)success failure:(FailureBlock)failure {
    if(key==key1) {
        success(url1);
    } else if(key==key2) {
        failure(error2);
    }
}

@end
