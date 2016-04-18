//
//  SKFileCache.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCache.h"

#import "SKAsyncCache_Protected.h"

#import "SKFileCacheDownloader.h"
#import "SKFileCacheCoster.h"

@interface SKFileCache ()

@property(nonatomic, strong, readonly, nonnull) NSString *lruDictionaryPath;
@property(nonatomic, readonly, nonnull) Class archiver;

@end

@implementation SKFileCache

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andCoster:(id<SKLruCoster>)coster andLoader:(id<SKAsyncCacheLoader>)loader andTaskQueue:(SKTaskQueue *)taskQueue {
    return [self initWithPath:nil andConstraint:constraint andCoster:coster andLoader:loader andTaskQueue:taskQueue];
}

- (nonnull instancetype)initWithPath:(nullable NSString *)path andConstraint:(NSUInteger)constraint andCoster:(nullable id<SKLruCoster>)coster andLoader:(nullable id<SKAsyncCacheLoader>)loader andTaskQueue:(nullable SKTaskQueue *)taskQueue {

    self = [super init];
    
    _lruDictionaryPath = path;
    
    if(_lruDictionaryPath) {
        _lruDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:_lruDictionaryPath];
    }
    
    if(!_lruDictionary) {
        _lruDictionary = [[SKLruStorage alloc] initWithConstraint:constraint];
    }
    
    if(coster) {
        _lruDictionary.coster = coster;
    } else {
        _lruDictionary.coster = [[SKFileCacheCoster alloc] init];
    }
    
    if(loader) {
        _loader = loader;
    } else {
        _loader = [[SKFileCacheDownloader alloc] init];
    }
    
    if(taskQueue) {
        _taskQueue = taskQueue;
    } else {
        _taskQueue = [SKAsyncCache defaultTaskQueue];
    }
    
    _archiver = [NSKeyedArchiver class];
    
    return self;
}

- (void)dealloc {
    if(!_lruDictionaryPath) {
        [_lruDictionary removeAllObjects];
    }
}

- (SKTask *)taskToLoadObjectForKey:(id<NSCopying>)key {
    return [[SKTask alloc] initWithId:key block:^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [_loader loadObjectForKey:key success:^(id  _Nonnull object) {
            [_lruDictionary setObject:object forKey:key];
            
            if(_lruDictionaryPath) {
                if(![_archiver archiveRootObject:_lruDictionary toFile:_lruDictionaryPath]) {
                    NSLog(@"Unable to save lru dictionary");
                }
            }
            
            [self notifyObject:object forKey:key];
            dispatch_semaphore_signal(sema);
        } failure:^(NSError * _Nonnull error) {
            [self notifyError:error forKey:key];
            dispatch_semaphore_signal(sema);
        }];
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
}

@end
