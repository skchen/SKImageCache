//
//  SKAsyncCache_Protected.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/16.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

@interface SKAsyncCache () {
@protected
    SKLruDictionary *_lruDictionary;
    SKTaskQueue *_taskQueue;
    id<SKAsyncCacheLoader> _loader;
    __weak id<SKAsyncCacheDelegate> _delegate;
}

+ (nonnull SKTaskQueue *)defaultTaskQueue;

- (void)notifyObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;
- (void)notifyError:(nonnull NSError *)error forKey:(nonnull id<NSCopying>)key;
- (nonnull SKTask *)taskToLoadObjectForKey:(nonnull id<NSCopying>)key;

@end
