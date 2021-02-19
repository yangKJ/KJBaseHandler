//
//  UIImage+KJCompress.h
//  KJEmitterView
//
//  Created by 杨科军 on 2020/4/20.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExtensionHandler
//  图片压缩处理，提供几种系统API的处理方式

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KJCompress)

/// 压缩图片到指定大小
- (UIImage*)kj_compressTargetByte:(NSUInteger)maxLength;
/// 压缩图片到指定大小
+ (UIImage*)kj_compressImage:(UIImage*)image TargetByte:(NSUInteger)maxLength;

/// UIKit方式
- (UIImage*)kj_UIKitChangeImageSize:(CGSize)size;
/// Quartz 2D
- (UIImage*)kj_QuartzChangeImageSize:(CGSize)size;
/// ImageIO
- (UIImage*)kj_ImageIOChangeImageSize:(CGSize)size;
/// CoreImage
- (UIImage*)kj_CoreImageChangeImageSize:(CGSize)size;
/// Accelerate
- (UIImage*)kj_AccelerateChangeImageSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
