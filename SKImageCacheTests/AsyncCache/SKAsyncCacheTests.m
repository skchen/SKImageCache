//
//  SKAsyncCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKAsyncCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKAsyncCacheTests : XCTestCase<SKAsyncCacheLoader>

@end

@implementation SKAsyncCacheTests {
    SKAsyncCache *asyncCache;
    
    SKLruTable *mockLruTable;
    id<SKAsyncCacheDelegate> mockDelegate;
    
    id<NSCopying> mockKey1;
    id mockObject1;
    
    id<NSCopying> mockKey2;
    NSError *mockError2;
}

- (void)setUp {
    [super setUp];
    
    mockLruTable = mock([SKLruTable class]);
    mockDelegate = mockProtocol(@protocol(SKAsyncCacheDelegate));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    mockObject1 = mock([NSObject class]);
    
    mockKey2 = mockProtocol(@protocol(NSCopying));
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    mockError2 = mock([NSError class]);
    
    asyncCache = [[SKAsyncCache alloc] initWithLruTable:mockLruTable andLoader:self andDelegate:mockDelegate];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldGetNil_whenObjectIsNotCached {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:nil];
    
    id object = [asyncCache objectForKey:mockKey1];
    
    assertThat(object, is(nilValue()));
}

- (void)test_shouldGetObject_whenObjectIsCached {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object = [asyncCache objectForKey:mockKey1];
    
    assertThat(object, is(mockObject1));
}

- (void)test_shouldLoadObject_whenObjectIsNotCached {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:nil];
    
    [asyncCache cacheObjectForKey:mockKey1];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockLruTable) setObject:mockObject1 forKey:mockKey1];
    [verify(mockDelegate) asyncCache:asyncCache didCacheObject:mockObject1 forKey:mockKey1];
}

- (void)test_shouldNotLoadObject_whenObjectIsCached {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:mockObject1];
    
    [asyncCache cacheObjectForKey:mockKey1];
    [NSThread sleepForTimeInterval:1];
    
    [verifyCount(mockLruTable, never()) setObject:mockObject1 forKey:mockKey1];
    [verify(mockDelegate) asyncCache:asyncCache didCacheObject:mockObject1 forKey:mockKey1];
}

- (void)test_shouldGetError_whenObjectIsNotCachedAndUnableToLoad {
    [given([mockLruTable objectForKey:mockKey2]) willReturn:nil];
    
    [asyncCache cacheObjectForKey:mockKey2];
    [NSThread sleepForTimeInterval:1];
    
    [verify(mockDelegate) asyncCache:asyncCache failedToCacheObjectForKey:mockKey2 withError:mockError2];
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
