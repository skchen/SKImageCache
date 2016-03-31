//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

@import SKUtils;

@interface SKFileCache () <SKLruListCoster, SKLruListSpiller>

@property(nonatomic, strong, readonly, nonnull) SKLruList *list;
@property(nonatomic, strong, readonly, nonnull) SKFileStorage *storage;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andStorage:(nonnull SKFileStorage *)storage {
    self = [super init];
    _list = [[SKLruList alloc] initWithConstraint:capacity andStorage:[[NSMutableArray alloc] init] andCoster:self andSpiller:self];
    _storage = storage;
    return self;
}

- (nullable NSURL *)fileUrlForKey:(nonnull id<NSCopying>)key {
    NSURL *fileUrl = [_storage fileUrlForKey:key];
    [_list touchObject:key];
    
    return fileUrl;
}

- (void)removeFileUrlForKey:(nonnull id<NSCopying>)key {
    [_list removeObject:key];
    [_storage removeFileForKey:key error:nil];
}

#pragma mark - SKLruListCoster

- (NSUInteger)costForObject:(id)object {
    return 1;
}

#pragma mark - SKLruListSpiller

- (void)onSpilled:(id)object {
    [_storage removeFileForKey:object error:nil];
}

@end
