//
//  SKImageCacheTests.m
//  SKImageCacheTests
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKFileCache.h"

@import OCHamcrest;
@import OCMockito;

@import SKUtils;

@interface SKFileCacheTests : XCTestCase

@end

@implementation SKFileCacheTests {
    SKFileCache *fileCache;
    
    SKFileStorage *mockStorage;
    
    id mockObject1;
    NSURL *mockUrl1;
    
    id mockObject2;
    NSURL *mockUrl2;
}

- (void)setUp {
    [super setUp];
    
    mockStorage = mock([SKFileStorage class]);
    
    mockObject1 = mock([NSObject class]);
    mockUrl1 = mock([NSURL class]);
    
    mockObject2 = mock([NSObject class]);
    mockUrl2 = mock([NSURL class]);
    
    [given([mockStorage fileUrlForObject:mockObject1]) willReturn:mockUrl1];
    [given([mockStorage fileUrlForObject:mockObject2]) willReturn:mockUrl2];
    
    fileCache = [[SKFileCache alloc] initWithCapacity:1 andStorage:mockStorage];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldGetUrl_whenObjectSpecified {
    NSURL *url = [fileCache fileUrlForObject:mockObject1];

    [verify(mockStorage) fileUrlForObject:mockObject1];
    assertThat(url, is(mockUrl1));
}

- (void)test_shouldRemovePreviousObject_whenObjectSpilled {
    NSURL *url1 = [fileCache fileUrlForObject:mockObject1];
    NSURL *url2 = [fileCache fileUrlForObject:mockObject2];
    
    [verify(mockStorage) fileUrlForObject:mockObject1];
    [verify(mockStorage) removeObject:mockObject1 error:nil];
    [verify(mockStorage) fileUrlForObject:mockObject2];
    assertThat(url1, is(mockUrl1));
    assertThat(url2, is(mockUrl2));
}

@end
