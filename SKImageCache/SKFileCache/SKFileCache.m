//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

@import SKUtils;

@interface SKFileCache () <SKLruListSpiller>

@property(nonatomic, strong, readonly, nonnull) SKLruList *list;
@property(nonatomic, strong, readonly, nonnull) SKFileStorage *storage;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andStorage:(nonnull SKFileStorage *)storage {
    self = [super init];
    _list = [[SKLruList alloc] initWithCapacity:capacity andSpiller:self];
    _storage = storage;
    return self;
}

- (nullable NSURL *)fileUrlForObject:(nonnull id)object {
    NSURL *fileUrl = [_storage fileUrlForObject:object];
    [_list touchObject:object];
    
    return fileUrl;
}

#pragma mark - SKLruListSpiller

- (void)onSpilled:(id)object {
    [_storage removeObject:object error:nil];
}

@end
