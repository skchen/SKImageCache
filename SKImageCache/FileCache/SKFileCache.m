//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

#import "SKAsyncCache_Protected.h"

#import "SKFileCacheDownloader.h"

@interface SKFileCache ()

@property(nonatomic, strong, readonly, nonnull) SKAsyncCache *asyncCache;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {

    self = [super init];
    
    _lruDictionary = [[SKLruStorage alloc] initWithConstraint:constraint];
    _lruDictionary.coster = coster;
    
    if(loader) {
        _loader = loader;
    } else {
        _loader = [[SKFileCacheDownloader alloc] init];
    }
    
    if(taskQueue) {
        _taskQueue = taskQueue;
    } else {
        _taskQueue = [SKAsyncCache defaultTaskQueue];
    }
    
    return self;
}

@end
