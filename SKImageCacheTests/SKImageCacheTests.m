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

@interface SKMockMapper : NSObject

- (nullable NSURL *)get:(nonnull id<NSCopying>)key;

@end

@implementation SKMockMapper

- (nullable NSURL *)get:(nonnull id<NSCopying>)key { return nil; }

@end

@interface SKMockDownloader : NSObject

- (nullable NSData *)download:(nonnull id<NSCopying>)key;

@end

@implementation SKMockDownloader

- (nullable NSData *)download:(nonnull id<NSCopying>)key { return nil; }

@end

static NSString *const kKeyDownloadData1 = @"key1";
static NSString *const kKeyDownloadData2 = @"key2";
static NSString *const kKeyDownloadData3 = @"key3";

@interface SKImageCacheTests : XCTestCase

@property(nonatomic, strong) SKLruCache *mockLruCache;
@property(nonatomic, strong) SKMockMapper *mockMapper;
@property(nonatomic, strong) SKMockDownloader *mockDownloader;

@property(nonatomic, strong) SKFileCache *fileCache;

@property(nonatomic, strong) NSData *mockData1;
@property(nonatomic, strong) NSURL *mockUrl1;

@property(nonatomic, strong) NSData *mockData2;
@property(nonatomic, strong) NSURL *mockUrl2;

@property(nonatomic, strong) NSData *mockData3;
@property(nonatomic, strong) NSURL *mockUrl3;

@end

@implementation SKImageCacheTests

- (void)setUp {
    [super setUp];
    
    _mockLruCache = mock([SKLruCache class]);
    
    _mockData1 = mock([NSData class]);
    _mockUrl1 = mock([NSURL class]);
    
    _mockMapper = mock([SKMockMapper class]);
    [given([_mockMapper get:kKeyDownloadData1]) willReturn:_mockUrl1];
    [given([_mockMapper get:kKeyDownloadData2]) willReturn:_mockUrl2];
    [given([_mockMapper get:kKeyDownloadData3]) willReturn:_mockUrl3];
    
    _mockDownloader = mock([SKMockDownloader class]);
    [given([_mockDownloader download:kKeyDownloadData1]) willReturn:_mockData1];
    [given([_mockDownloader download:kKeyDownloadData2]) willReturn:_mockData2];
    [given([_mockDownloader download:kKeyDownloadData3]) willReturn:_mockData3];
    
    _fileCache = [[SKFileCache alloc] initWithCache:_mockLruCache andMapper:^NSURL * _Nonnull(id<NSCopying>  _Nonnull key) {
        return [_mockMapper get:key];
    } andDownloader:^NSData * _Nonnull(id<NSCopying>  _Nonnull key) {
        return [_mockDownloader download:key];
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldDownloadCacheGetData_whenSpecificKeyGiven {
    id object = [_fileCache objectForKey:kKeyDownloadData1];

    [verify(_mockDownloader) download:kKeyDownloadData1];
    [verify(_mockData1) writeToURL:_mockUrl1 atomically:YES];
    [verify(_mockLruCache) setObject:_mockUrl1 forKey:kKeyDownloadData1];
    assertThat(object, is(_mockUrl1));
}

- (void)test_shouldNotDownloadButGetData_whenDataIsCachedForSpecificKey {
    [given([_mockLruCache objectForKey:kKeyDownloadData1]) willReturn:_mockUrl1];
    
    id object = [_fileCache objectForKey:kKeyDownloadData1];
    
    [verifyCount(_mockDownloader, never()) download:kKeyDownloadData1];
    [verifyCount(_mockData1, never()) writeToURL:_mockUrl1 atomically:YES];
    [verifyCount(_mockLruCache, never()) setObject:_mockUrl1 forKey:kKeyDownloadData1];
    [verify(_mockLruCache) objectForKey:kKeyDownloadData1];
    assertThat(object, is(_mockUrl1));
}

@end
