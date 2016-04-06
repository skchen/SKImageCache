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

- (nonnull instancetype) initWithLruTable:(nonnull SKLruTable *)lruTable andLoader:(nonnull id<SKAsyncCacheLoader>)loader andTaskQueue:(nonnull SKTaskQueue *)taskQueue andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate andFileCache:(nonnull SKAsyncFileCache *)fileCache;

@end
