//
//  KJBaseButton.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//

#import <UIKit/UIKit.h>
#import <KJExtensionHandler/KJExtensionHeader.h>
NS_ASSUME_NONNULL_BEGIN
@interface KJButtonStateInfo : NSObject
@property(nonatomic,assign)UIControlState state;
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)CGFloat space;/// 图文间距
@end
@interface KJBaseButton : UIButton
/// 图片载体
@property(nonatomic,strong,readonly)UIImageView *kImageView;
/// 标题载体
@property(nonatomic,strong,readonly)UILabel *kTitleLabel;
/// 快捷创建按钮
+ (instancetype)kj_createButtonWithExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block;

#pragma mark - ExtendParameterBlock 扩展参数
@property(nonatomic,strong,readonly) KJBaseButton *(^kViewTag)(NSInteger);
@property(nonatomic,strong,readonly) KJBaseButton *(^kAddView)(UIView*);
@property(nonatomic,strong,readonly) KJBaseButton *(^kFrame)(CGRect);
@property(nonatomic,strong,readonly) KJBaseButton *(^kBackgroundColor)(UIColor*);
@property(nonatomic,strong,readonly) KJBaseButton *(^kButtonStateInfo)(KJButtonStateInfo*(^)(KJButtonStateInfo *info));
@property(nonatomic,strong,readonly) KJBaseButton *(^kButtonAction)(void(^)(UIControlState state));

@end

NS_ASSUME_NONNULL_END
