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

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(id<SKLruCoster>)coster andLoader:(id<SKAsyncCacheLoader>)loader andDelegate:(id<SKAsyncCacheDelegate>)delegate {

    self = [super init];
    _lruTable = [[SKLruStorage alloc] initWithConstraint:constraint andCoster:coster andSpiller:nil];
    _loader = loader;
    _taskQueue = [[SKTaskQueue alloc] init];
    _delegate = delegate;
    return self;
}

@end
