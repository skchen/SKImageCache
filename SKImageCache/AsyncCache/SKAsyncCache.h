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

@interface SKAsyncCache : NSObject

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andLoader:(nonnull id<SKAsyncCacheLoader>)loader andTaskQueue:(nonnull SKTaskQueue *)taskQueue andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate;

- (void)cacheObjectForKey:(nonnull id<NSCopying>)key;

@end
