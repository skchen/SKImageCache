//
//  SKFileCache.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKFileStorage.h"

@interface SKFileCache : NSObject

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andStorage:(nonnull SKFileStorage *)storage;

- (nullable NSURL *)fileUrlForKey:(nonnull id<NSCopying>)key;
- (void)removeFileUrlForKey:(nonnull id<NSCopying>)key;

@end
