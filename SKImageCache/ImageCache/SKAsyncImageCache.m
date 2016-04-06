//
//  SKAsyncImageCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKAsyncImageCache.h"

#import "SKAsyncImageCacheDecoder.h"

@interface SKAsyncImageCache () <SKAsyncCacheDelegate>

@property(nonatomic, strong, readonly, nonnull) SKAsyncFileCache *fileCache;

@end

@implementation SKAsyncImageCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init without FileCache is not a valid initializer for the class SKLruStorage"
                                 userInfo:nil];
}

- (nonnull instancetype)initWithFileCache:(nonnull SKAsyncFileCache *)fileCache andConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {
    
    if(!loader) {
        loader = [[SKAsyncImageCacheDecoder alloc] initWithAsyncFileCache:fileCache];
    }
    
    self = [super initWithConstraint:constraint andCoster:coster andLoader:loader andTaskQueue:taskQueue];
    
    _fileCache = fileCache;
    _fileCache.delegate = self;
    
    return self;
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
