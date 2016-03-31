//
//  SKImageCacheTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKImageCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKImageCacheTests : XCTestCase

@end

@implementation SKImageCacheTests {
    SKImageCache *imageCache;
    
    SKLruTable *mockLruTable;
    SKFileCache *mockFileCache;
    
    id<SKImageCacheDecoder> mockImageCacheDecoder;
    
    id<NSCopying> mockKey1;
    NSURL *mockUrl1;
    UIImage *mockImage1;
}

- (void)setUp {
    [super setUp];
    
    mockLruTable = mock([SKLruTable class]);
    mockFileCache = mock([SKFileCache class]);
    
    mockImageCacheDecoder = mockProtocol(@protocol(SKImageCacheDecoder));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    mockUrl1 = mock([NSURL class]);
    mockImage1 = mock([UIImage class]);
    
    [given([mockFileCache fileUrlForKey:mockKey1]) willReturn:mockUrl1];
    
    [given([mockImageCacheDecoder imageForFileUrl:mockUrl1]) willReturn:mockImage1];
    
    imageCache = [[SKImageCache alloc] initWithLruTable:mockLruTable andFileCache:mockFileCache andDecoder:mockImageCacheDecoder];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldDecodeImage_whenImageNotYetInCache {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:nil];
    
    UIImage *image = [imageCache imageForKey:mockKey1];
    
    [verify(mockFileCache) fileUrlForKey:mockKey1];
    [verify(mockImageCacheDecoder) imageForFileUrl:mockUrl1];
    [verify(mockLruTable) setObject:mockImage1 forKey:mockKey1];
    assertThat(image, is(mockImage1));
}

- (void)test_shouldNotDecodeImage_whenImageAlreadyInCache {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:mockImage1];
    
    UIImage *image = [imageCache imageForKey:mockKey1];
    
    [verifyCount(mockFileCache, never()) fileUrlForKey:mockKey1];
    [verifyCount(mockImageCacheDecoder, never()) imageForFileUrl:mockUrl1];
    [verifyCount(mockLruTable, never()) setObject:mockImage1 forKey:mockKey1];
    assertThat(image, is(mockImage1));
}

- (void)test_shouldRemoveImageForKey {
    [imageCache removeImageForKey:mockKey1];
    
    [verify(mockFileCache) removeFileUrlForKey:mockKey1];
    [verify(mockLruTable) removeObjectForKey:mockKey1];
}

@end
