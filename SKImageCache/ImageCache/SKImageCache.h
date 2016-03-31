//
//  SKImageCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SKFileCache.h"

@import SKUtils;

@protocol SKImageCacheDecoder <NSObject>

- (nullable UIImage *)imageForFileUrl:(nonnull NSURL *)fileUrl;

@end

@interface SKImageCache : NSObject

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andFileCache:(nonnull SKFileCache *)fileCache andDecoder:(nonnull id<SKImageCacheDecoder>)decoder;

- (nullable UIImage *)imageForKey:(nonnull id<NSCopying>)key;
- (void)removeImageForKey:(nonnull id<NSCopying>)key;

@end
