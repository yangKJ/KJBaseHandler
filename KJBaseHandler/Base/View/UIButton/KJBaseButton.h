//
//  KJBaseButton.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//  https://github.com/yangKJ/KJBaseHandler
//  图文混排按钮控件，基于UIControl封装的类似于UIButton控件

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
/// 按钮图文样式
typedef NS_ENUM(NSInteger, KJBaseButtonLayoutStyle) {
    KJBaseButtonLayoutStyleCenterImageLeft = 0,// 内容居中—图左文右
    KJBaseButtonLayoutStyleCenterImageRight,   // 内容居中-图右文左
    KJBaseButtonLayoutStyleCenterImageTop,     // 内容居中-图上文下
    KJBaseButtonLayoutStyleCenterImageBottom,  // 内容居中-图下文上
    KJBaseButtonLayoutStyleLeftImageLeft,      // 内容居左-图左文右
    KJBaseButtonLayoutStyleLeftImageRight,     // 内容居左-图右文左
    KJBaseButtonLayoutStyleRightImageLeft,     // 内容居右-图左文右
    KJBaseButtonLayoutStyleRightImageRight,    // 内容居右-图右文左
};
/// 按钮点击状态
typedef NS_ENUM(NSInteger, KJBaseButtonState) {
    KJBaseButtonStateNormal = 0,
    KJBaseButtonStateSelected,/// 选中状态
    KJBaseButtonStateHighlighted,/// 高亮状态
    KJBaseButtonStateDisabled,/// 不可选中状态
};
@interface KJBaseButtonInfo : NSObject
@property(nonatomic,assign)KJBaseButtonLayoutStyle buttonStyle;/// 按钮图文样式，默认内容居中—图上文下
@property(nonatomic,assign)KJBaseButtonState state;/// 按钮点击状态
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIColor *color;/// 文字颜色，默认黑色
@property(nonatomic,assign)CGFloat space;/// 图文间距
@property(nonatomic,assign)bool fixed;/// 固定图片和文本大小，默认yes
@property(nonatomic,assign)CGSize imageMaxSize;/// 图片最大尺寸，默认按钮的三分之一
@property(nonatomic,assign)CGSize labelMaxSize;/// 文本最大尺寸
@end

@interface KJBaseButton : UIControl
/// 图片载体
@property(nonatomic,strong,readonly)UIImageView *imageView;
/// 标题载体
@property(nonatomic,strong,readonly)UILabel *label;
/// 设置选中状态
@property(nonatomic,assign)BOOL isSelected;
/// 设置不可点击状态
@property(nonatomic,assign)BOOL isDisabled;
/// 快捷创建按钮
+ (instancetype)kj_createButtonWithExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block;

#pragma mark - ExtendParameterBlock 扩展参数
@property(nonatomic,strong,readonly) KJBaseButton *(^kViewTag)(NSInteger);
@property(nonatomic,strong,readonly) KJBaseButton *(^kAddView)(UIView*);
@property(nonatomic,strong,readonly) KJBaseButton *(^kFrame)(CGRect);
@property(nonatomic,strong,readonly) KJBaseButton *(^kBackgroundColor)(UIColor*);
@property(nonatomic,strong,readonly) KJBaseButton *(^kStateInfos)(KJBaseButtonInfo*(^)(KJBaseButtonInfo *info));/// 设置按钮的数据
@property(nonatomic,strong,readonly) KJBaseButton *(^kAction)(void(^)(KJBaseButton *kButton,KJBaseButtonState state));/// 按钮事件处理

@end

NS_ASSUME_NONNULL_END
