//
//  SKAsyncImageCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKImageCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKImageCacheTests : XCTestCase<SKAsyncCacheLoader>

@end

@implementation SKImageCacheTests {
    SKImageCache *asyncImageCache;
    
    SKLruDictionary *mockLruDictionary;
    id<SKLruCoster> mockCoster;
    id<SKAsyncCacheDelegate> mockDelegate;
    SKFileCache *mockFileCache;
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
    
    mockLruDictionary = mock([SKLruDictionary class]);
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockDelegate = mockProtocol(@protocol(SKAsyncCacheDelegate));
    mockFileCache = mock([SKFileCache class]);
    
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
    
    asyncImageCache = [[SKImageCache alloc] initWithFileCache:mockFileCache andConstraint:1 andCoster:mockCoster andLoader:self andTaskQueue:taskQueue];
    asyncImageCache.delegate = mockDelegate;
    [asyncImageCache setValue:mockLruDictionary forKey:@"lruDictionary"];
    
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
    [given([mockLruDictionary objectForKey:mockRemoteUrl1]) willReturn:nil];
    
    [asyncImageCache cacheObjectForKey:mockRemoteUrl1];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockFileCache) cacheObjectForKey:mockRemoteUrl1];
    [verify(mockLruDictionary) setObject:mockImage1 forKey:mockRemoteUrl1];
    [verify(mockDelegate) asyncCache:asyncImageCache didCacheObject:mockImage1 forKey:mockRemoteUrl1];
}

- (void)test_shouldNotLoadObject_whenObjectIsCached {
    [given([mockLruDictionary objectForKey:mockRemoteUrl1]) willReturn:mockImage1];
    
    [asyncImageCache cacheObjectForKey:mockRemoteUrl1];
    [NSThread sleepForTimeInterval:1];
    
    [verifyCount(mockFileCache, never()) cacheObjectForKey:mockRemoteUrl1];
    [verifyCount(mockLruDictionary, never()) setObject:mockImage1 forKey:mockRemoteUrl1];
    [verify(mockDelegate) asyncCache:asyncImageCache didCacheObject:mockImage1 forKey:mockRemoteUrl1];
}

- (void)test_shouldGetError_whenObjectIsNotCachedAndUnableToLoad {
    [given([mockLruDictionary objectForKey:mockRemoteUrl2]) willReturn:nil];
    
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
