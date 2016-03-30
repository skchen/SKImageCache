//
//  SKFileStorageTests.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKFileStorage.h"

@import OCHamcrest;
@import OCMockito;

@interface SKFileStorageTests : XCTestCase

@end

@implementation SKFileStorageTests {
    NSFileManager *mockFileManager;
    NSString *mockDirectory;
    id<SKFileStorageMapper> mockMapper;
    id<SKFileStorageDownloader> mockDownloader;
    
    SKFileStorage *storage;
    
    id mockObject1;
    NSURL *mockUrl1;
    NSString *mockUrlString1;
}

- (void)setUp {
    [super setUp];
    
    mockFileManager = mock([NSFileManager class]);
    mockDirectory = mock([NSString class]);
    mockMapper = mockProtocol(@protocol(SKFileStorageMapper));
    mockDownloader = mockProtocol(@protocol(SKFileStorageDownloader));
    
    mockObject1 = mock([NSObject class]);
    mockUrl1 = mock([NSURL class]);
    mockUrlString1 = mock([NSString class]);
    
    storage = [[SKFileStorage alloc] initWithFileManager:mockFileManager andMapper:mockMapper andDownloader:mockDownloader];
    
    [given([mockUrl1 absoluteString]) willReturn:mockUrlString1];
    
    [given([mockFileManager fileExistsAtPath:mockDirectory]) willReturnBool:YES];
    [given([mockMapper fileUrlForKey:mockObject1]) willReturn:mockUrl1];
    
    [given([mockDownloader downloadTo:mockUrl1]) willReturnBool:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldFileExistReturnFalse_whenObjectIsNotYetDownloaded {
    [given([mockFileManager fileExistsAtPath:mockUrlString1]) willReturnBool:NO];
    
    BOOL fileExist = [storage fileExistForKey:mockObject1];
    
    assert(!fileExist);
}

- (void)test_shouldFileExistReturnTrue_whenObjectIsDownloaded {
    [given([mockFileManager fileExistsAtPath:mockUrlString1]) willReturnBool:YES];
    
    BOOL fileExist = [storage fileExistForKey:mockObject1];
    
    assert(fileExist);
}

- (void)test_shouldPerformDownload_whenObjectIsNotYetDownloaded {
    [given([mockFileManager fileExistsAtPath:mockUrlString1]) willReturnBool:NO];
    
    NSURL *url = [storage fileUrlForKey:mockObject1];
    
    [verify(mockDownloader) downloadTo:mockUrl1];
    assertThat(url, isNot(nilValue()));
    assertThat(url, is(mockUrl1));
}

- (void)test_shouldNotPerformDownload_whenObjectIsAlreadyDownloaded {
    [given([mockFileManager fileExistsAtPath:mockUrlString1]) willReturnBool:YES];
    
    NSURL *url = [storage fileUrlForKey:mockObject1];
    
    [verifyCount(mockDownloader, never()) downloadTo:mockUrl1];
    assertThat(url, isNot(nilValue()));
    assertThat(url, is(mockUrl1));
}

- (void)test_shouldDeleteFile_whenRemoveObjectIsCalled {
    [given([mockFileManager fileExistsAtPath:mockUrlString1]) willReturnBool:YES];
    
    [storage removeFileForKey:mockObject1 error:0];
    
    [verify(mockFileManager) removeItemAtURL:mockUrl1 error:0];
}

@end
