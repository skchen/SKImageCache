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
    
    id<NSCopying> mockKey1;
    NSURL *mockUrl1;
    
    id<NSCopying> mockKey2;
    NSURL *mockUrl2;
}

- (void)setUp {
    [super setUp];
    
    mockStorage = mock([SKFileStorage class]);
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    mockUrl1 = mock([NSURL class]);
    
    mockKey2 = mockProtocol(@protocol(NSCopying));
    mockUrl2 = mock([NSURL class]);
    
    [given([mockStorage fileUrlForKey:mockKey1]) willReturn:mockUrl1];
    [given([mockStorage fileUrlForKey:mockKey2]) willReturn:mockUrl2];
    
    fileCache = [[SKFileCache alloc] initWithCapacity:1 andStorage:mockStorage];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldGetUrl_whenObjectSpecified {
    NSURL *url = [fileCache fileUrlForKey:mockKey1];

    [verify(mockStorage) fileUrlForKey:mockKey1];
    assertThat(url, is(mockUrl1));
}

- (void)test_shouldRemovePreviousObject_whenObjectSpilled {
    NSURL *url1 = [fileCache fileUrlForKey:mockKey1];
    NSURL *url2 = [fileCache fileUrlForKey:mockKey2];
    
    [verify(mockStorage) fileUrlForKey:mockKey1];
    [verify(mockStorage) removeFileForKey:mockKey1 error:nil];
    [verify(mockStorage) fileUrlForKey:mockKey2];
    assertThat(url1, is(mockUrl1));
    assertThat(url2, is(mockUrl2));
}

@end
