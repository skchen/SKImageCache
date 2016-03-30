//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

@import SKUtils;

@interface SKFileCache () <SKLruCacheSpiller>

@property(nonatomic, strong, readonly, nonnull) SKLruCache *urlCache;
@property(nonatomic, copy, readonly, nonnull) MapperBlock mapper;
@property(nonatomic, copy, readonly, nonnull) DownloaderBlock downloader;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andMapper:(nonnull MapperBlock)mapper andDownloader:(nonnull DownloaderBlock)downloader {
    self = [super init];
    _urlCache = [[SKLruCache alloc] initWithCapacity:capacity andSpiller:self];
    _mapper = mapper;
    _downloader = downloader;
    return self;
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    NSURL *url = [_urlCache objectForKey:key];
    
    if(!url) {
        url = _mapper(key);
        NSData *data = _downloader(key);
        
        [data writeToURL:url atomically:YES];
        [_urlCache setObject:url forKey:key];
    }
    
    return url;
}

#pragma mark - SKLruCacheSpiller

- (void)onSpilled:(id)object forKey:(id<NSCopying>)key {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:object error:&error];
    
    if(error) {
        NSLog(@"Unable to remove cached file: %@", error);
    }
}

@end
