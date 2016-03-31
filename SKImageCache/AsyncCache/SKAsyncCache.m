//
//  SKAsyncCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

@interface SKAsyncCache ()

@property(nonatomic, strong, readonly, nonnull) SKLruTable *lruTable;
@property(nonatomic, weak, readonly, nullable) id<SKAsyncCacheLoader> loader;
@property(nonatomic, strong, readonly, nonnull) SKTaskQueue *taskQueue;
@property(nonatomic, weak, readonly, nullable) id<SKAsyncCacheDelegate> delegate;

- (SKTask *)taskToLoadObjectForKey:(id<NSCopying>)key;

@end

@implementation SKAsyncCache

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andLoader:(nonnull id<SKAsyncCacheLoader>)loader andTaskQueue:(nonnull SKTaskQueue *)taskQueue andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate {
    self = [super init];
    _lruTable = lruTable;
    _loader = loader;
    _taskQueue = taskQueue;
    _delegate = delegate;
    return self;
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
