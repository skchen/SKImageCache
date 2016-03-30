//
//  SKFileStorage.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKFileStorageMapper <NSObject>

- (nonnull NSURL *)fileUrlForKey:(nonnull id<NSCopying>)key;

@end

@protocol SKFileStorageDownloader <NSObject>

- (BOOL)downloadTo:(nonnull NSURL *)url;

@end

@interface SKFileStorage : NSObject

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andMapper:(nonnull id <SKFileStorageMapper>)mapper andDownloader:(nonnull id<SKFileStorageDownloader>)downloader;

- (BOOL)fileExistForKey:(nonnull id<NSCopying>)key;
- (nullable NSURL *)fileUrlForKey:(nonnull id<NSCopying>)key;
- (void)removeFileForKey:(nonnull id<NSCopying>)key error:(NSError * _Nullable * _Nullable)error;

@end
