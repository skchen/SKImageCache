//
//  SKAsyncFileCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKAsyncCache.h"

@import SKUtils;

@interface SKAsyncFileCache : SKAsyncCache

- (nonnull instancetype)initWithStorage:(nonnull SKLruStorage *)lruStorage andLoader:(nonnull id<SKAsyncCacheLoader>)loader andTaskQueue:(nonnull SKTaskQueue *)taskQueue andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate;

@end
