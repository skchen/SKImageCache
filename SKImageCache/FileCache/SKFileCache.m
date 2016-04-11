//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

#import "SKFileCacheDownloader.h"

@interface SKFileCache ()

@property(nonatomic, strong, readonly, nonnull) SKAsyncCache *asyncCache;

@end

@implementation SKFileCache

+ (SKTaskQueue *)defaultTaskQueue {
    return [[SKTaskQueue alloc] init];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {

    self = [super init];
    
    _lruTable = [[SKLruStorage alloc] initWithConstraint:constraint];
    _lruTable.coster = coster;
    
    if(loader) {
        _loader = loader;
    } else {
        _loader = [[SKFileCacheDownloader alloc] init];
    }
    
    if(taskQueue) {
        _taskQueue = taskQueue;
    } else {
        _taskQueue = [SKFileCache defaultTaskQueue];
    }
    
    return self;
}

@end
