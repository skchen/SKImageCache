//
//  SKAsyncImageCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncImageCache.h"

@interface SKAsyncImageCache () <SKAsyncCacheDelegate>

@property(nonatomic, strong, readonly, nonnull) SKAsyncFileCache *fileCache;

@end

@implementation SKAsyncImageCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andTaskQueue:(nullable SKTaskQueue *)taskQueue {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init without FileCache is not a valid initializer for the class SKLruStorage"
                                 userInfo:nil];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andTaskQueue:(nullable SKTaskQueue *)taskQueue andFileCache:(nonnull SKAsyncFileCache *)fileCache {
    self = [super initWithConstraint:constraint andCoster:coster andLoader:loader andDelegate:delegate andTaskQueue:taskQueue];
    _fileCache = fileCache;
    _fileCache.delegate = self;
    return self;
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andFileCache:(nonnull SKAsyncFileCache *)fileCache {
    
    return [self initWithConstraint:constraint andCoster:nil andLoader:loader andDelegate:delegate andTaskQueue:nil andFileCache:fileCache];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andTaskQueue:(nullable SKTaskQueue *)taskQueue andFileCache:(nonnull SKAsyncFileCache *)fileCache {
    
    return [self initWithConstraint:constraint andCoster:nil andLoader:loader andDelegate:delegate andTaskQueue:taskQueue andFileCache:fileCache];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nullable id<SKAsyncCacheDelegate>)delegate andFileCache:(nonnull SKAsyncFileCache *)fileCache {
    
    return [self initWithConstraint:constraint andCoster:coster andLoader:loader andDelegate:delegate andTaskQueue:nil andFileCache:fileCache];
}

#pragma mark - Override

- (void)cacheObjectForKey:(id<NSCopying>)key {
    id object = [_lruTable objectForKey:key];
    if(object) {
        [_delegate asyncCache:self didCacheObject:object forKey:key];
    } else {
        [_fileCache cacheObjectForKey:key];
    }
}

#pragma mark - SKAsyncCacheDelegate

- (void)asyncCache:(SKAsyncCache *)cache didCacheObject:(id)object forKey:(id<NSCopying>)key {
    
    SKTask *task = [self taskToLoadObjectForKey:key];
    [_taskQueue insertTask:task];
}

- (void)asyncCache:(SKAsyncCache *)cache failedToCacheObjectForKey:(id<NSCopying>)key withError:(NSError *)error {
    [_delegate asyncCache:self failedToCacheObjectForKey:key withError:error];
}

@end
