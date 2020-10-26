//
//  KJBadgeView.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/26.
//  小红点视图控件

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, KJBadgePositionType) {
    KJBadgePositionTypeCenterLeft = 0,
    KJBadgePositionTypeCenterRight,
    KJBadgePositionTypeTopLeft,
    KJBadgePositionTypeTopRight,
    KJBadgePositionTypeBottomLeft,
    KJBadgePositionTypeBottomRight,
};
@interface KJBadgeViewInfo : NSObject
/// bedge值
@property(nonatomic,strong)NSString *badgeValue;
/// 敏感字符增长宽度，默认值为4
@property(nonatomic,assign)CGFloat sensitiveTextWidth;
/// 敏感增长宽度，默认为10
@property(nonatomic,assign)CGFloat sensitiveWidth;
/// 固定高度，默认为20
@property(nonatomic,assign)CGFloat fixedHeight;
/// 位置信息，默认为KJBadgePositionTypeTopRight
@property(nonatomic,assign)KJBadgePositionType position;
/// 字体，默认为12
@property(nonatomic,strong)UIFont *font;
/// 字体颜色，默认为白色
@property(nonatomic,strong)UIColor *textColor;
/// bedge颜色，默认为红色
@property(nonatomic,strong)UIColor *badgeColor;
@end

@interface KJBadgeView : UIView
/// 初始化
+ (instancetype)kj_createBadgeView:(UIView*)contentView InfoBlock:(KJBadgeViewInfo*(^)(KJBadgeViewInfo *info))block;
/// 设置BadgeValue
- (void)kj_setBadgeValue:(NSString*)value Animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
