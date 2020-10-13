//
//  KJBaseButton.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//

#import "KJBaseButton.h"

@interface KJBaseButton ()
@property(nonatomic,strong)UIImageView *kj_imageView;
@property(nonatomic,strong)UILabel *kj_titleLabel;
@end

@implementation KJBaseButton

/// 快捷创建按钮
+ (instancetype)kj_createButtonWithState:(UIControlState)state ExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block{
    KJBaseButton * button = [KJBaseButton buttonWithType:(UIButtonTypeCustom)];
    if (block) [button kj_setupButtonWithState:state ExtendParameterBlock:block];
    return button;
}
/// 设置按钮不同状态
- (void)kj_setupButtonWithState:(UIControlState)state ExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block{
    if (block) block(self);
    
}
#pragma mark - lazy
- (UIImageView*)kj_imageView{
    if (!_kj_imageView) {
        _kj_imageView = [UIImageView new];
    }
    return _kj_imageView;
}
- (UILabel*)kj_titleLabel{
    if (!_kj_titleLabel) {
        _kj_titleLabel = [UILabel new];
    }
    return _kj_titleLabel;
}
#pragma mark - ExtendParameterBlock 扩展参数
- (KJBaseButton *(^)(NSInteger))kViewTag {
    return ^(NSInteger tag){
        self.tag = tag;
        return self;
    };
}
- (KJBaseButton *(^)(UIView*))kAddView {
    return ^(UIView *superView){
        [superView addSubview:self];
        return self;
    };
}
- (KJBaseButton *(^)(CGRect))kFrame {
    return ^(CGRect rect){
        self.frame = rect;
        return self;
    };
}
- (KJBaseButton *(^)(UIColor*))kBackgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}
@end
