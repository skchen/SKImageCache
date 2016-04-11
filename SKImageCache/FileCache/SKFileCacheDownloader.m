//
//  SKAsyncFileCacheDownloader.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCacheDownloader.h"

@interface SKFileCacheDownloader ()

@property(nonatomic, copy, readonly, nonnull) NSString *directoryPath;

- (NSString *)localPathForRemoteUrl:(NSString *)remoteUrl;

@end

@implementation SKFileCacheDownloader

- (nonnull instancetype)initWithDirectory:(nonnull NSString *)directoryPath {
    self = [super init];
    _directoryPath = directoryPath;
    return self;
}

- (nonnull instancetype)init {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    return [self initWithDirectory:documentPath];
}

- (void)loadObjectForKey:(id<NSCopying>)key success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSString *remoteUrl = (NSString *)key;
    NSString *localPath = [self localPathForRemoteUrl:remoteUrl];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:remoteUrl]];
    if(data) {
        if([data writeToFile:localPath atomically:YES]) {
            success(localPath);
        } else {
            failure([NSError errorWithDomain:@"Unable to write" code:0 userInfo:nil]);
        }
    } else {
        failure([NSError errorWithDomain:@"Unable to download" code:0 userInfo:nil]);
    }
}

- (NSString *)localPathForRemoteUrl:(NSString *)remoteUrl {
    NSString *escapedRemoteUrl = [remoteUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    return [_directoryPath stringByAppendingPathComponent:escapedRemoteUrl];
}

@end
