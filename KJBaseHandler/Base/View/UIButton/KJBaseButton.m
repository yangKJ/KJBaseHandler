//
//  KJBaseButton.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//

#import "KJBaseButton.h"

@interface KJBaseButton ()
@property(nonatomic,strong)UIImageView *kImageView;
@property(nonatomic,strong)UILabel *kTitleLabel;
@end

@implementation KJBaseButton

/// 快捷创建按钮
+ (instancetype)kj_createButtonWithExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block{
    KJBaseButton * button = [KJBaseButton buttonWithType:(UIButtonTypeCustom)];
    if (block) block(button);
    [button kj_button:button];
    return button;
}
- (void)kj_button:(KJBaseButton*)button{
    [button addSubview:self.kImageView];
    [button addSubview:self.kTitleLabel];
}
#pragma mark - lazy
- (UIImageView*)kImageView{
    if (!_kImageView) {
        _kImageView = [UIImageView new];
        _kImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _kImageView;
}
- (UILabel*)kTitleLabel{
    if (!_kTitleLabel) {
        _kTitleLabel = [UILabel new];
        _kTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _kTitleLabel;
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
- (KJBaseButton *(^)(KJButtonStateInfo*(^)(KJButtonStateInfo *)))kButtonStateInfo {
    return ^(KJButtonStateInfo*(^block)(KJButtonStateInfo *)) {
        if (block) {
            KJButtonStateInfo *info = [KJButtonStateInfo new];
            info = block(info);
            self.kImageView.image = [UIImage imageNamed:info.imageName];
            self.kTitleLabel.text = info.title;
        }
        return self;
    };
}
@end
@implementation KJButtonStateInfo

@end
