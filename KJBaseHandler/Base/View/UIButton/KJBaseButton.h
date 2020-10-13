//
//  KJBaseButton.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN

@interface KJBaseButton : UIButton
/// 图片载体
@property(nonatomic,strong,readonly)UIImageView *kj_imageView;
/// 标题载体
@property(nonatomic,strong,readonly)UILabel *kj_titleLabel;
/// 快捷创建按钮
+ (instancetype)kj_createButtonWithState:(UIControlState)state ExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block;
/// 设置按钮不同状态
- (void)kj_setupButtonWithState:(UIControlState)state ExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block;

#pragma mark - ExtendParameterBlock 扩展参数
@property(nonatomic,strong,readonly) KJBaseButton *(^kViewTag)(NSInteger);
@property(nonatomic,strong,readonly) KJBaseButton *(^kAddView)(UIView*);
@property(nonatomic,strong,readonly) KJBaseButton *(^kFrame)(CGRect);
@property(nonatomic,strong,readonly) KJBaseButton *(^kBackgroundColor)(UIColor*);

@end

NS_ASSUME_NONNULL_END
