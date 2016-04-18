//
//  SKImageCacheCoster.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/18.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKImageCacheCoster.h"

@implementation SKImageCacheCoster

- (NSUInteger)costForObject:(id)object {
    UIImage *image = (UIImage *)object;
    //NSLog(@"imageSize: %@x%@", @(image.size.width), @(image.size.height));
    return image.size.width*image.size.height;
}

@end
