//
//  SKFileStorage.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileStorage.h"

@interface SKFileStorage ()

@property(nonatomic, strong, readonly, nonnull) NSFileManager *fileManager;
@property(nonatomic, weak, readonly) id <SKFileStorageMapper> mapper;
@property(nonatomic, weak, readonly) id <SKFileStorageDownloader> downloader;

@end

@implementation SKFileStorage

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andMapper:(nonnull id <SKFileStorageMapper>)mapper andDownloader:(nonnull id<SKFileStorageDownloader>)downloader {
    
    self = [super init];
    
    _fileManager = fileManager;
    _mapper = mapper;
    _downloader = downloader;
    
    return self;
}

- (BOOL)fileExistForObject:(nonnull id)object {
    NSURL *fileUrl = [_mapper fileUrlForObject:object];
    return [_fileManager fileExistsAtPath:[fileUrl absoluteString]];
}

- (nullable NSURL *)fileUrlForObject:(nonnull id)object {
    NSURL *fileUrl = [_mapper fileUrlForObject:object];
    
    if([self fileExistForObject:object]) {
        return fileUrl;
    } else {
        if([_downloader downloadTo:fileUrl]) {
            return fileUrl;
        }
    }
    return nil;
}

- (void)removeObject:(nonnull id)object error:(NSError * _Nullable * _Nullable)error {
    NSURL *fileUrl = [_mapper fileUrlForObject:object];
    
    if([_fileManager fileExistsAtPath:[fileUrl absoluteString]]) {
        [_fileManager removeItemAtURL:fileUrl error:error];
    }
}

@end
