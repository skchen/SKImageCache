//
//  SKImageCacheDefaultLoader.m
//  SKImageCache
//
//  Created by Shin-Kai Chen on 2016/4/6.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKImageCacheDecoder.h"

@interface SKImageCacheDecoder ()

@property(nonatomic, strong, readonly, nonnull) SKFileCache *fileCache;
@property(nonatomic, assign, readonly) CGSize size;

@end

@implementation SKImageCacheDecoder

- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache {
    return [self initWithFileCache:fileCache andSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (nonnull instancetype)initWithFileCache:(nonnull SKFileCache *)fileCache andSize:(CGSize)size {
    self = [super init];
    _fileCache = fileCache;
    _size = size;
    return self;
}

- (void)loadObjectForKey:(nonnull id<NSCopying>)key success:(nonnull SuccessBlock)success failure:(nullable FailureBlock)failure {
    NSString *filePath = [_fileCache objectForKey:key];
    if(filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image) {
            CGSize targetSize = [self targetImageSizeForImage:image];
            success([self imageWithImage:image convertToSize:targetSize]);
        } else {
            failure([NSError errorWithDomain:@"Unable to decode file" code:0 userInfo:nil]);
        }
    } else {
        failure([NSError errorWithDomain:@"File not found" code:0 userInfo:nil]);
    }
}

- (CGSize)targetImageSizeForImage:(UIImage *)image {
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    while(width>_size.width ||  height>_size.height) {
        width/=2;
        height/=2;
    }
    
    return CGSizeMake(width, height);
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
