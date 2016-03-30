//
//  SKFileStorage.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKFileStorageMapper <NSObject>

- (nonnull NSURL *)fileUrlForObject:(nonnull id)object;

@end

@protocol SKFileStorageDownloader <NSObject>

- (BOOL)downloadTo:(nonnull NSURL *)url;

@end

@interface SKFileStorage : NSObject

- (nonnull instancetype)initWithFileManager:(nonnull NSFileManager *)fileManager andMapper:(nonnull id <SKFileStorageMapper>)mapper andDownloader:(nonnull id<SKFileStorageDownloader>)downloader;

- (BOOL)fileExistForObject:(nonnull id)object;
- (nullable NSURL *)fileUrlForObject:(nonnull id)object;
- (void)removeObject:(nonnull id)object error:(NSError * _Nullable * _Nullable)error;

@end
