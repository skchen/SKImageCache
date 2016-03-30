//
//  SKFileCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSURL * _Nonnull (^MapperBlock)(id<NSCopying> _Nonnull key);
typedef NSData * _Nonnull (^DownloaderBlock)(id<NSCopying> _Nonnull key);

@interface SKFileCache : NSObject

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andMapper:(nonnull MapperBlock)mapper andDownloader:(nonnull DownloaderBlock)downloader;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;

@end
