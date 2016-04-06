//
//  SKAsyncCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SKUtils;
@import SKTaskUtils;

@class SKAsyncCache;

typedef void (^SuccessBlock)(id _Nonnull object);
typedef void (^FailureBlock)(NSError* _Nonnull error);

@protocol SKAsyncCacheLoader <NSObject>

- (void)loadObjectForKey:(nonnull id<NSCopying>)key success:(nonnull SuccessBlock)success failure:(nullable FailureBlock)failure;

@end

@protocol SKAsyncCacheDelegate <NSObject>

- (void)asyncCache:(nonnull SKAsyncCache *)cache didCacheObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key;
- (void)asyncCache:(nonnull SKAsyncCache *)cache failedToCacheObjectForKey:(nonnull id<NSCopying>)key withError:(nonnull NSError *)error;

@end

@interface SKAsyncCache : NSObject {
    @protected
    SKLruTable *_lruTable;
    SKTaskQueue *_taskQueue;
    __weak id<SKAsyncCacheLoader> _loader;
    __weak id<SKAsyncCacheDelegate> _delegate;
}

@property(nonatomic, strong, readonly, nonnull) SKLruTable *lruTable;
@property(nonatomic, weak, readonly, nullable) id<SKAsyncCacheLoader> loader;
@property(nonatomic, weak, nullable) id<SKAsyncCacheDelegate> delegate;

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)cacheObjectForKey:(nonnull id<NSCopying>)key;

#pragma mark - Protected

- (nonnull SKTask *)taskToLoadObjectForKey:(nonnull id<NSCopying>)key;

@end
