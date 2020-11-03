//
//  KJSegmentView.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/29.
//  https://github.com/yangKJ/KJBaseHandler
//  选择菜单控件

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
@interface KJSegmentViewInfo : NSObject
/// 背景色，默认黄色
@property(nonatomic,strong)UIColor *backgroundColor;
/// 选中背景色，默认红色
@property(nonatomic,strong)UIColor *selectedBackgroundColor;
/// 文字颜色，默认黑色
@property(nonatomic,strong)UIColor *textColor;
/// 选中文字颜色，默认白色
@property(nonatomic,strong)UIColor *selectedTextColor;
/// 字体，默认15
@property(nonatomic,strong)UIFont *textFont;
/// 切换动画时间
@property(nonatomic,assign)CGFloat animateDuration;
/// 选中索引，默认第一个
@property(nonatomic,assign)NSInteger selectIndex;

@end

@interface KJSegmentView : UIControl
/// 初始化
+ (instancetype)kj_createSelectMenuViewWithInfoBlock:(KJSegmentViewInfo*(^)(KJSegmentViewInfo *info))block;
/// 数据源
@property(nonatomic,strong)NSArray *dataSource;
/// 选中控件
@property(nonatomic,strong,readonly)UILabel *selectLabel;
/// 选中回调
@property(nonatomic,copy,readwrite)void(^kSelectedMenuBlock)(NSInteger index,NSString *text);

@end

NS_ASSUME_NONNULL_END
