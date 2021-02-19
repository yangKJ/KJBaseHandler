//
//  UIButton+KJButtonContentLayout.m
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/7.
//  Copyright © 2017年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExtensionHandler

#import "UIButton+KJButtonContentLayout.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation UIButton (KJButtonContentLayout)
/// 设置图文混排
- (void)kj_setButtonContentLayout{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize size = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGFloat labelWidth  = size.width;
    CGFloat labelHeight = size.height;
#pragma clang diagnostic pop
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    if (self.periphery == 0) self.periphery = 5;
    switch (self.layoutType) {
        case KJButtonContentLayoutStyleNormal:{
            titleEdge = UIEdgeInsetsMake(0, self.padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.padding);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith - self.padding, 0, imageWith);
            imageEdge = UIEdgeInsetsMake(0, labelWidth + self.padding, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageTop:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith, -imageHeight - self.padding, 0);
            imageEdge = UIEdgeInsetsMake(-labelHeight - self.padding, 0, 0, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleCenterImageBottom:{
            titleEdge = UIEdgeInsetsMake(-imageHeight - self.padding, -imageWith, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -labelHeight - self.padding, -labelWidth);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case KJButtonContentLayoutStyleLeftImageLeft:{
            titleEdge = UIEdgeInsetsMake(0, self.padding + self.periphery, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case KJButtonContentLayoutStyleLeftImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -imageWith + self.periphery, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, labelWidth + self.padding + self.periphery, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case KJButtonContentLayoutStyleRightImageLeft:{
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.padding + self.periphery);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case KJButtonContentLayoutStyleRightImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -self.frame.size.width / 2, 0, imageWith + self.padding + self.periphery);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -labelWidth + self.periphery);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        default:break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
    [self setNeedsDisplay];
}

#pragma mark - associated
- (NSInteger)layoutType{
    return [objc_getAssociatedObject(self, @selector(layoutType)) integerValue];;
}
- (void)setLayoutType:(NSInteger)layoutType{
    objc_setAssociatedObject(self, @selector(layoutType), @(layoutType), OBJC_ASSOCIATION_ASSIGN);
    [self kj_setButtonContentLayout];
}
- (CGFloat)padding{
    return [objc_getAssociatedObject(self, @selector(padding)) floatValue];
}
- (void)setPadding:(CGFloat)padding{
    objc_setAssociatedObject(self, @selector(padding), @(padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setButtonContentLayout];
}
- (CGFloat)periphery{
    return [objc_getAssociatedObject(self, @selector(periphery)) floatValue];
}
- (void)setPeriphery:(CGFloat)periphery{
    objc_setAssociatedObject(self, @selector(periphery), @(periphery), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setButtonContentLayout];
}
- (KJButtonContentLayoutStyle)kj_ButtonContentLayoutType{
    return (KJButtonContentLayoutStyle)[objc_getAssociatedObject(self, @selector(kj_ButtonContentLayoutType)) integerValue];
}
- (void)setKj_ButtonContentLayoutType:(KJButtonContentLayoutStyle)kj_ButtonContentLayoutType{
    objc_setAssociatedObject(self, @selector(kj_ButtonContentLayoutType), @(kj_ButtonContentLayoutType), OBJC_ASSOCIATION_ASSIGN);
    self.layoutType = kj_ButtonContentLayoutType;
}
- (CGFloat)kj_Padding{
    return [objc_getAssociatedObject(self, @selector(kj_Padding)) floatValue];
}
- (void)setKj_Padding:(CGFloat)kj_Padding{
    objc_setAssociatedObject(self, @selector(kj_Padding), @(kj_Padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.padding = kj_Padding;
}
- (CGFloat)kj_PaddingInset{
    return [objc_getAssociatedObject(self, @selector(kj_PaddingInset)) floatValue];
}
- (void)setKj_PaddingInset:(CGFloat)kj_PaddingInset{
    objc_setAssociatedObject(self, @selector(kj_PaddingInset), @(kj_PaddingInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.periphery = kj_PaddingInset;
}

@end

NS_ASSUME_NONNULL_END

