//
//  UIImage+KJCompress.m
//  KJEmitterView
//
//  Created by 杨科军 on 2020/4/20.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExtensionHandler

#import "UIImage+KJCompress.h"

@implementation UIImage (KJCompress)
/// 压缩图片到指定大小
- (UIImage*)kj_compressTargetByte:(NSUInteger)maxLength{
    return [UIImage kj_compressImage:self TargetByte:maxLength];
}
+ (UIImage*)kj_compressImage:(UIImage*)image TargetByte:(NSUInteger)maxLength{
    CGFloat compression = 1.;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1,min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }else if (data.length > maxLength) {
            max = compression;
        }else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}
#pragma mark - UIKit方式
- (UIImage*)kj_UIKitChangeImageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Quartz 2D
- (UIImage*)kj_QuartzChangeImageSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - ImageIO
- (UIImage*)kj_ImageIOChangeImageSize:(CGSize)size{
    NSData *date = UIImagePNGRepresentation(self);
    int max = (int)MAX(size.width, size.height);
    CFDictionaryRef dictionaryRef = (__bridge CFDictionaryRef) @{(id)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(YES),
                                                                 (id)kCGImageSourceThumbnailMaxPixelSize : @(max),
                                                                 (id)kCGImageSourceShouldCache : @(YES)};
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)date, nil);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, dictionaryRef);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    if (imageRef != nil) CFRelease(imageRef);
    CFRelease(src);
    return newImage;
}

#pragma mark - CoreImage
- (UIImage*)kj_CoreImageChangeImageSize:(CGSize)size{
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
    CGFloat scale = fminf(size.height/self.size.height, size.width/self.size.width);
    NSDictionary *dict = @{kCIInputScaleKey:@(scale),kCIInputAspectRatioKey:@(1.),kCIInputImageKey:ciImage};
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform" withInputParameters:dict];
    CIContext *ciContext = [[CIContext alloc] initWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CGImageRef ciImageRef = [ciContext createCGImage:filter.outputImage fromRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = [UIImage imageWithCGImage:ciImageRef];
    return newImage;
}

#pragma mark - Accelerate
- (UIImage*)kj_AccelerateChangeImageSize:(CGSize)size{
    const size_t width = size.width, height = size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    UInt8 * data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){
        CGContextRelease(bmContext);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(bmContext);
    return newImage;
}


@end
