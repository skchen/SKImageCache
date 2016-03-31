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
@property(nonatomic, strong, readonly, nonnull) SKLruTable *lruTable;
@property(nonatomic, strong, readonly, nonnull) SKFileCache *fileCache;
@property(nonatomic, weak, readonly) id<SKImageCacheDecoder> decoder;

@end

@implementation SKImageCache

- (nonnull instancetype)initWithLruTable:(nonnull SKLruTable *)lruTable andFileCache:(nonnull SKFileCache *)fileCache andDecoder:(nonnull id<SKImageCacheDecoder>)decoder {
    self = [super init];
    
    _lruTable = lruTable;
    _fileCache = fileCache;
    _decoder = decoder;
    
    return self;
}

- (nullable UIImage *)imageForKey:(nonnull id<NSCopying>)key {
    UIImage *image = [_lruTable objectForKey:key];
    
    if(!image) {
        NSURL *url = [_fileCache fileUrlForKey:key];
        image = [_decoder imageForFileUrl:url];
        [_lruTable setObject:image forKey:key];
    }
    
    return image;
}

- (void)removeImageForKey:(nonnull id<NSCopying>)key {
    [_lruTable removeObjectForKey:key];
    [_fileCache removeFileUrlForKey:key];
}

@end
