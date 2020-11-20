//
//  KJBadgeView.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/26.
//  https://github.com/yangKJ/KJBaseHandler
//  小红点视图控件

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, KJBadgePositionType) {
    KJBadgePositionTypeTopLeft = 0,
    KJBadgePositionTypeTopRight,
    KJBadgePositionTypeBottomLeft,
    KJBadgePositionTypeBottomRight,
    KJBadgePositionTypeCenterLeft,
    KJBadgePositionTypeCenterRight,
    KJBadgePositionTypeCenter,
};
typedef NS_ENUM(NSUInteger, AdhesivePlateStatus) {
    AdhesivePlateStickers,//粘上
    AdhesivePlateSeparate//分离
};
@interface KJBadgeViewInfo : NSObject
/// bedge值
@property(nonatomic,assign)NSInteger badgeValue;
/// 零时是否隐藏，默认隐藏
@property(nonatomic,assign)bool zeroHidden;
/// 字符增长宽度，默认4px
@property(nonatomic,assign)CGFloat sensitiveTextWidth;
/// 控件增长宽度，默认10px
@property(nonatomic,assign)CGFloat sensitiveWidth;
/// 固定高度，默认为20px
@property(nonatomic,assign)CGFloat fixedHeight;
/// 位置信息，默认为KJBadgePositionTypeTopRight
@property(nonatomic,assign)KJBadgePositionType positionType;
/// 字体，默认为12
@property(nonatomic,strong)UIFont *font;
/// 字体颜色，默认为白色
@property(nonatomic,strong)UIColor *textColor;
/// bedge颜色，默认为红色
@property(nonatomic,strong)UIColor *badgeColor;
@end

@interface KJBadgeView : UIControl
/// 初始化
+ (instancetype)kj_createBadgeView:(UIView*)contentView InfoBlock:(KJBadgeViewInfo*(^)(KJBadgeViewInfo *info))block;
/// 设置BadgeValue
- (void)kj_setBadgeValue:(NSInteger)value Animated:(BOOL)animated;
/// 设置拖拽粘附效果，返回yes执行爆炸动画   （暂时还有点问题）
//- (void)kj_attachWithSeparateBlock:(BOOL(^)(UIView *view))separateBlock;

@end

NS_ASSUME_NONNULL_END
