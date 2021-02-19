//
//  UIImage+KJURLSize.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/12/31.
//  Copyright © 2019 杨科军. All rights reserved.
//  来源作者：https://github.com/90candy/GetImageSizeWithURL
//  获取网络图片尺寸

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (KJURLSize)
/// 获取网络图片尺寸
+ (CGSize)kj_imageGetSizeWithURL:(NSURL*)URL;

/// 异步等待获取网络图片大小
+ (CGSize)kj_imageAsyncGetSizeWithURL:(NSURL*)URL;

@end

NS_ASSUME_NONNULL_END
