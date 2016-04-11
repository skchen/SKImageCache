//
//  SKImageCacheDefaultLoader.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKImageCacheDecoder.h"

@interface SKImageCacheDecoder ()

@property(nonatomic, strong, readonly, nonnull) SKFileCache *asyncFileCache;

@end

@implementation SKImageCacheDecoder

- (nonnull instancetype)initWithAsyncFileCache:(nonnull SKFileCache *)asyncFileCache {
    self = [super init];
    _asyncFileCache = asyncFileCache;
    return self;
}

- (void)loadObjectForKey:(nonnull id<NSCopying>)key success:(nonnull SuccessBlock)success failure:(nullable FailureBlock)failure {
    NSString *filePath = [_asyncFileCache objectForKey:key];
    if(filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image) {
            success(image);
        } else {
            failure([NSError errorWithDomain:@"Unable to decode file" code:0 userInfo:nil]);
        }
    } else {
        failure([NSError errorWithDomain:@"File not found" code:0 userInfo:nil]);
    }
}

@end
