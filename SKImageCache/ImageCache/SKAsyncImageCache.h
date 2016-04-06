//
//  SKAsyncImageCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

#import "SKAsyncFileCache.h"

@interface SKAsyncImageCache : SKAsyncCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andTaskQueue:(nullable SKTaskQueue *)taskQueue andFileCache:(nonnull SKAsyncFileCache *)fileCache;

@end
