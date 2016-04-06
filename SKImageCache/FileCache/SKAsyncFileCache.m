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

- (nonnull instancetype)initWithLruTable:(SKLruTable *)lruTable andLoader:(id<SKAsyncCacheLoader>)loader andDelegate:(id<SKAsyncCacheDelegate>)delegate {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-initWithLruTable:andLoader:andDelegate is not a valid initializer for the class SKAsyncFileCache"
                                 userInfo:nil];
}

- (nonnull instancetype)initWithStorage:(nonnull SKLruStorage *)lruStorage andLoader:(nonnull id<SKAsyncCacheLoader>)loader andDelegate:(nonnull id<SKAsyncCacheDelegate>)delegate {
    
    self = [super initWithLruTable:lruStorage andLoader:loader andDelegate:delegate];
    
    return self;
}

@end
