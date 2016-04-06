//
//  SKAsyncCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

@interface SKAsyncCache ()

@property(nonatomic, strong, readonly, nonnull) SKTaskQueue *taskQueue;

@end

@implementation SKAsyncCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate {

    self = [super init];
    _lruTable = [[SKLruTable alloc] initWithConstraint:constraint andCoster:coster andSpiller:nil];
    _loader = loader;
    _taskQueue = [[SKTaskQueue alloc] init];
    _delegate = delegate;
    return self;
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    return [_lruTable objectForKey:key];
}

- (void)cacheObjectForKey:(id<NSCopying>)key {
    id object = [_lruTable objectForKey:key];
    if(object) {
        [_delegate asyncCache:self didCacheObject:object forKey:key];
    } else {
        SKTask *task = [self taskToLoadObjectForKey:key];
        [_taskQueue insertTask:task];
    }
}

#pragma mark - Local

- (SKTask *)taskToLoadObjectForKey:(id<NSCopying>)key {
    return [[SKTask alloc] initWithId:key block:^{
        [_loader loadObjectForKey:key success:^(id  _Nonnull object) {
            [_lruTable setObject:object forKey:key];
            [_delegate asyncCache:self didCacheObject:object forKey:key];
        } failure:^(NSError * _Nonnull error) {
            [_delegate asyncCache:self failedToCacheObjectForKey:key withError:error];
        }];
    }];
}

@end
