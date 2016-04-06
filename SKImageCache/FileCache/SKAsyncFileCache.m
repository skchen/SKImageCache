//
//  SKAsyncFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncFileCache.h"

@interface SKAsyncFileCache ()

@property(nonatomic, strong, readonly, nonnull) SKAsyncCache *asyncCache;

@end

@implementation SKAsyncFileCache

+ (SKTaskQueue *)defaultTaskQueue {
    return [[SKTaskQueue alloc] init];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(id<SKAsyncCacheDelegate>)delegate andTaskQueue:(nullable SKTaskQueue *)taskQueue {

    self = [super init];
    _lruTable = [[SKLruStorage alloc] initWithConstraint:constraint andCoster:coster andSpiller:nil];
    _loader = loader;
    
    if(taskQueue) {
        _taskQueue = taskQueue;
    } else {
        _taskQueue = [SKAsyncFileCache defaultTaskQueue];
    }
    
    _delegate = delegate;
    return self;
}

@end
