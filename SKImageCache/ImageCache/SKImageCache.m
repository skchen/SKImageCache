//
//  SKImageCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKImageCache.h"

@interface SKImageCache ()

@property(nonatomic, assign, readonly) NSUInteger capacity;
@property(nonatomic, strong, readonly, nonnull) SKLruCache *lruCache;
@property(nonatomic, strong, readonly, nonnull) SKFileCache *fileCache;
@property(nonatomic, weak, readonly) id<SKImageCacheDecoder> decoder;

@end

@implementation SKImageCache

- (nonnull instancetype)initWithLruCache:(nonnull SKLruCache *)lruCache andFileCache:(nonnull SKFileCache *)fileCache andDecoder:(nonnull id<SKImageCacheDecoder>)decoder {
    self = [super init];
    
    _lruCache = lruCache;
    _fileCache = fileCache;
    _decoder = decoder;
    
    return self;
}

- (nullable UIImage *)imageForKey:(nonnull id<NSCopying>)key {
    UIImage *image = [_lruCache objectForKey:key];
    
    if(!image) {
        NSURL *url = [_fileCache fileUrlForKey:key];
        image = [_decoder imageForFileUrl:url];
        [_lruCache setObject:image forKey:key];
    }
    
    return image;
}

- (void)removeImageForKey:(nonnull id<NSCopying>)key {
    [_lruCache removeObjectForKey:key];
    [_fileCache removeFileUrlForKey:key];
}

@end
