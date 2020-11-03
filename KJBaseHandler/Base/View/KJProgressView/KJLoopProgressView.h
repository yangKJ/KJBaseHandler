//
//  KJLoopProgressView.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/11/3.
//  https://github.com/yangKJ/KJBaseHandler
//  圆环形进度条

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
@interface KJLoopProgressViewInfo : NSObject
/// 中心颜色，默认白色
@property(nonatomic,strong)UIColor *centerColor;
/// 圆环背景色，默认浅蓝色
@property(nonatomic,strong)UIColor *backgroundColor;
/// 圆环进度颜色，默认蓝色
@property(nonatomic,strong)UIColor *progressColor;
/// 满圆环色，默认绿色
@property(nonatomic,strong)UIColor *oneColor;
/// 圆环宽度，默认5px
@property(nonatomic,assign)CGFloat width;
/// 百分比字体
@property(nonatomic,strong)UIFont *font;

@end

@interface KJLoopProgressView : UIControl
/// 初始化
+ (instancetype)kj_createProgressViewWithInfoBlock:(KJLoopProgressViewInfo*(^)(KJLoopProgressViewInfo *info))block;
/// 百分比数值（0-1）
@property(nonatomic,assign)CGFloat percent;

@end

NS_ASSUME_NONNULL_END
