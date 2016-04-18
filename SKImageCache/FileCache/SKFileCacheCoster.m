//
//  SKFileCacheCoster.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/18.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKFileCacheCoster.h"

@implementation SKFileCacheCoster

- (nonnull instancetype)init {
    self = [super init];
    _fileManager = [NSFileManager defaultManager];
    return self;
}

- (NSUInteger)costForObject:(id)object {
    NSString *path = (NSString *)object;
    
    if([_fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary<NSString *, id> *attributes = [_fileManager attributesOfItemAtPath:path error:&error];
        
        if(error) {
            NSLog(@"Unable to get attributes: %@", error);
        } else {
            long long fileSize = [attributes fileSize];
            //NSLog(@"fileSize: %@", @(fileSize));
            return (NSUInteger)fileSize;
        }
    }
    
    return 0;
}

@end
