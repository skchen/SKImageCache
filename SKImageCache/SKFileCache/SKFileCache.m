//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

@interface SKFileCache ()

@property(nonatomic, strong, readonly, nonnull) SKLruCache *lruCache;
@property(nonatomic, copy, readonly, nonnull) MapperBlock mapper;
@property(nonatomic, copy, readonly, nonnull) DownloaderBlock downloader;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithCache:(nonnull SKLruCache *)lruCache andMapper:(nonnull MapperBlock)mapper andDownloader:(nonnull DownloaderBlock)downloader {
    self = [super init];
    _lruCache = lruCache;
    _mapper = mapper;
    _downloader = downloader;
    return self;
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    NSURL *url = [_lruCache objectForKey:key];
    
    if(!url) {
        url = _mapper(key);
        NSData *data = _downloader(key);
        
        [data writeToURL:url atomically:YES];
        [_lruCache setObject:url forKey:key];
    }
    
    return url;
}

@end
