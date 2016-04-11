//
//  SKImageCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

#import "SKFileCache.h"

@interface SKImageCache : SKAsyncCache

- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache andConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue;

@end
