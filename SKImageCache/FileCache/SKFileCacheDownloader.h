//
//  SKAsyncFileCacheDownloader.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKAsyncCache.h"

@interface SKFileCacheDownloader : NSObject<SKAsyncCacheLoader>

- (nonnull instancetype)initWithDirectory:(nonnull NSString *)directoryPath;

@end
