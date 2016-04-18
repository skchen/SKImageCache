//
//  SKImageCacheDefaultLoader.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKAsyncCache.h"
#import "SKFileCache.h"

@interface SKImageCacheDecoder : NSObject<SKAsyncCacheLoader>

- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache;
- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache andSize:(CGSize)size;
- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache andConstraint:(NSUInteger)constraint;

@end
