//
//  SKAsyncCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/31.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SKUtils;

extern NSString *const _Nonnull kNotificationAsyncCacheObjectCached;
extern NSString *const _Nonnull kNotificationAsyncCacheObjectCacheFailed;

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

@property(nonatomic, strong, readonly, nonnull) SKLruDictionary *lruDictionary;
@property(nonatomic, strong, readonly, nonnull) id<SKAsyncCacheLoader> loader;
@property(nonatomic, assign) NSUInteger constraint;
@property(nonatomic, assign, readonly) NSUInteger cost;
@property(nonatomic, strong, nullable) NSNotificationCenter *notificationCenter;
@property(nonatomic, weak, nullable) id<SKAsyncCacheDelegate> delegate;
@property(nonatomic, assign) BOOL suspended;

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue;

- (nullable id)objectForKey:(nonnull id<NSCopying>)key;
- (void)cacheObjectForKey:(nonnull id<NSCopying>)key;

- (void)removeObjectForKey:(nonnull id<NSCopying>)key;
- (void)removeLastObject;

@end
