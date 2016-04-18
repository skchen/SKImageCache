//
//  SKFileCacheCoster.h
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/18.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SKUtils;

@interface SKFileCacheCoster : NSObject<SKLruCoster>

@property(nonatomic, strong, nonnull) NSFileManager *fileManager;

@end
