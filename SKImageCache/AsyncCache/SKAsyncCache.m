//
//  SKAsyncCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncCache.h"

NSString *const _Nonnull kNotificationAsyncCacheObjectCached = @"com.github.skchen.SKImageCache.SKAsyncCache.objectCached";
NSString *const _Nonnull kNotificationAsyncCacheObjectCacheFailed = @"com.github.skchen.SKImageCache.SKAsyncCache.objectCacheFailed";

@interface SKAsyncCache ()

@property(nonatomic, strong, readonly, nonnull) SKTaskQueue *taskQueue;

- (void)notifyObject:(id)object forKey:(id<NSCopying>)key;
- (void)notifyError:(NSError *)error forKey:(id<NSCopying>)key;

@end

@implementation SKAsyncCache

+ (SKTaskQueue *)defaultTaskQueue {
    return [[SKTaskQueue alloc] init];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {

    self = [super init];
    _lruDictionary = [[SKLruDictionary alloc] initWithConstraint:constraint];
    _lruDictionary.coster = coster;
    _loader = loader;
    
    if(taskQueue) {
        _taskQueue = taskQueue;
    } else {
        _taskQueue = [SKAsyncCache defaultTaskQueue];
    }
    
    return self;
}

- (void)dealloc {
    [_lruDictionary removeAllObjects];
}

- (NSUInteger)constraint {
    return _lruDictionary.constraint;
}

- (void)setConstraint:(NSUInteger)constraint {
    _lruDictionary.constraint = constraint;
}

- (NSUInteger)cost {
    return _lruDictionary.cost;
}

- (BOOL)suspended {
    return _taskQueue.suspended;
}

- (void)setSuspended:(BOOL)suspended {
    _taskQueue.suspended = suspended;
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    return [_lruDictionary objectForKey:key];
}

- (void)cacheObjectForKey:(id<NSCopying>)key {
    id object = [_lruDictionary objectForKey:key];
    if(object) {
        [self notifyObject:object forKey:key];
    } else {
        SKTask *task = [self taskToLoadObjectForKey:key];
        [_taskQueue insertTask:task];
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    [_lruDictionary removeObjectForKey:key];
}

- (void)removeLastObject {
    [_lruDictionary removeLastObject];
}

#pragma mark - Local

- (SKTask *)taskToLoadObjectForKey:(id<NSCopying>)key {
    return [[SKTask alloc] initWithId:key block:^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [_loader loadObjectForKey:key success:^(id  _Nonnull object) {
            [_lruDictionary setObject:object forKey:key];
            [self notifyObject:object forKey:key];
            dispatch_semaphore_signal(sema);
        } failure:^(NSError * _Nonnull error) {
            [self notifyError:error forKey:key];
            dispatch_semaphore_signal(sema);
        }];
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
}

- (void)notifyObject:(id)object forKey:(id<NSCopying>)key {
    if([_delegate respondsToSelector:@selector(asyncCache:didCacheObject:forKey:)]) {
        [_delegate asyncCache:self didCacheObject:object forKey:key];
    }
    
    if(_notificationCenter) {
        NSDictionary *userInfo = @{@"key": key, @"object": object};
        
        [_notificationCenter postNotificationName:kNotificationAsyncCacheObjectCached object:self userInfo:userInfo];
    }
}

- (void)notifyError:(NSError *)error forKey:(id<NSCopying>)key {
    if([_delegate respondsToSelector:@selector(asyncCache:failedToCacheObjectForKey:withError:)]) {
        [_delegate asyncCache:self failedToCacheObjectForKey:key withError:error];
    }
    
    if(_notificationCenter) {
        NSDictionary *userInfo = @{@"key": key, @"error": error};
        
        [_notificationCenter postNotificationName:kNotificationAsyncCacheObjectCacheFailed object:self userInfo:userInfo];
    }
}

@end
