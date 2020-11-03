//
//  KJBaseButton.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJBaseButton.h"
@implementation KJBaseButtonInfo
- (instancetype)init{
    if (self==[super init]) {
        self.space = 5;
        self.fixed = true;
        self.color = UIColor.blackColor;
        self.state = KJBaseButtonStateNormal;
        self.buttonStyle = KJBaseButtonLayoutStyleCenterImageTop;
        self.imageMaxSize = self.labelMaxSize = CGSizeZero;
        self.title = @"KJBaseButton";
    }
    return self;
}
@end

@interface KJBaseButton ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)KJBaseButtonInfo *normalInfo;
@property(nonatomic,strong)KJBaseButtonInfo *selectedInfo;
@property(nonatomic,strong)KJBaseButtonInfo *highlightedInfo;
@property(nonatomic,strong)KJBaseButtonInfo *disabledInfo;
@property(nonatomic,copy,readwrite)void(^actionblock)(KJBaseButton*,KJBaseButtonState);

@end

@implementation KJBaseButton
#pragma mark - public
/// 快捷创建按钮
+ (instancetype)kj_createButtonWithExtendParameterBlock:(void(^_Nullable)(KJBaseButton *obj))block{
    KJBaseButton * button = [KJBaseButton new];
    if (block) block(button);
    [button kj_button:button];
    return button;
}
#pragma mark - getter/setter
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        if (self.selectedInfo) [self kj_setCurrentInfo:self.selectedInfo];
    }else{
        if (self.normalInfo) [self kj_setCurrentInfo:self.normalInfo];
    }
}
- (void)setIsDisabled:(BOOL)isDisabled{
    _isDisabled = isDisabled;
    if (isDisabled) {
        if (self.disabledInfo) {
            self.userInteractionEnabled = NO;
            [self kj_setCurrentInfo:self.disabledInfo];
        }
    }else{
        self.userInteractionEnabled = YES;
        if (self.normalInfo) [self kj_setCurrentInfo:self.normalInfo];
    }
}
#pragma mark - private
- (void)kj_button:(KJBaseButton*)button{
    [button addSubview:self.imageView];
    [button addSubview:self.label];
    if (self.normalInfo) {
        [self kj_setCurrentInfo:self.normalInfo];
    }
    _weakself;
    [self kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        if (weakself.actionblock) {
            weakself.actionblock(weakself,weakself.isSelected?KJBaseButtonStateSelected:KJBaseButtonStateNormal);
        }
    }];
}
/// 设置当前数据
- (void)kj_setCurrentInfo:(KJBaseButtonInfo*)info{
    self.imageView.image = [UIImage imageNamed:info.imageName];
    self.label.text = info.title;
    self.label.textColor = info.color;
    CGFloat imageWidth,imageHeight,labelWidth,labelHeight;
    CGFloat scale = 3;
    if (info.fixed) {
        if (CGSizeEqualToSize(info.imageMaxSize, CGSizeZero)) {
            imageWidth  = self.width/scale;
            imageHeight = self.height/scale;
        }else{
            imageWidth  = info.imageMaxSize.width;
            imageHeight = info.imageMaxSize.height;
        }
        if (CGSizeEqualToSize(info.labelMaxSize, CGSizeZero)) {
            switch (info.buttonStyle) {
                case KJBaseButtonLayoutStyleCenterImageLeft:
                case KJBaseButtonLayoutStyleCenterImageRight:
                    labelWidth  = self.width/scale;
                    labelHeight = self.height;
                    break;
                case KJBaseButtonLayoutStyleCenterImageTop:
                case KJBaseButtonLayoutStyleCenterImageBottom:
                    labelWidth  = self.width;
                    labelHeight = self.height/scale;
                    break;
                default:
                    labelWidth  = self.width/scale;
                    labelHeight = self.height/scale;
                    break;
            }
        }else{
            labelWidth  = info.labelMaxSize.width;
            labelHeight = info.labelMaxSize.height;
        }
    }else{
        imageWidth  = self.imageView.image.size.width;
        imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelWidth  = [self.label.text sizeWithFont:self.label.font].width;
        labelHeight = [self.label.text sizeWithFont:self.label.font].height;
#pragma clang diagnostic pop
    }
    switch (info.buttonStyle) {
        case     KJBaseButtonLayoutStyleCenterImageLeft:{
            self.label.textAlignment = NSTextAlignmentLeft;
            self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
            self.imageView.centerY = self.label.centerY = self.height / 2.;
            CGFloat margin = self.width - (imageWidth + info.space + labelWidth);
            self.imageView.x = margin/2.;
            self.label.x = self.imageView.right + info.space;
        }
            break;
        case KJBaseButtonLayoutStyleCenterImageRight:{
            self.label.textAlignment = NSTextAlignmentRight;
            self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
            self.imageView.centerY = self.label.centerY = self.height / 2.;
            CGFloat margin = self.width - (imageWidth + info.space + labelWidth);
            self.label.x = margin/2.;
            self.imageView.x = self.label.right + info.space;
        }
            break;
        case KJBaseButtonLayoutStyleCenterImageTop:{
            self.label.textAlignment = NSTextAlignmentCenter;
            self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
            self.imageView.centerX = self.label.centerX = self.width / 2.;
            CGFloat margin = self.height - (imageHeight + info.space + labelHeight);
            self.imageView.y = margin/2.;
            self.label.y = self.imageView.bottom + info.space;
        }
            break;
        case KJBaseButtonLayoutStyleCenterImageBottom:{
            self.label.textAlignment = NSTextAlignmentCenter;
            self.imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
            self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
            self.imageView.centerX = self.label.centerX = self.width / 2.;
            CGFloat margin = self.height - (imageHeight + info.space + labelHeight);
            self.label.y = margin/2.;
            self.imageView.y = self.label.bottom + info.space;
        }
            break;
        case KJBaseButtonLayoutStyleLeftImageLeft:{
        }
            break;
        case KJBaseButtonLayoutStyleLeftImageRight:{
        }
            break;
        case KJBaseButtonLayoutStyleRightImageLeft:{
        }
            break;
        case KJBaseButtonLayoutStyleRightImageRight:{
        }
            break;
        default:break;
    }
}

#pragma mark - lazy
- (UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UILabel*)label{
    if (!_label) {
        _label = [UILabel new];
        [_label sizeToFit];
        _label.numberOfLines = 0;
        _label.font = kSystemFontSize(14);
    }
    return _label;
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
- (KJBaseButton *(^)(KJBaseButtonInfo*(^)(KJBaseButtonInfo *)))kStateInfos {
    return ^(KJBaseButtonInfo*(^block)(KJBaseButtonInfo *)) {
        if (block) {
            KJBaseButtonInfo *info = [KJBaseButtonInfo new];
            info = block(info);
            if (info.state == KJBaseButtonStateNormal) {
                self.normalInfo = info;
            }else if (info.state == KJBaseButtonStateSelected) {
                self.selectedInfo = info;
            }else if (info.state == KJBaseButtonStateHighlighted) {
                self.highlightedInfo = info;
            }else if (info.state == KJBaseButtonStateDisabled) {
                self.disabledInfo = info;
            }
        }
        return self;
    };
}
- (KJBaseButton *(^)(void(^)(KJBaseButton*,KJBaseButtonState)))kAction {
    return ^(void(^block)(KJBaseButton*,KJBaseButtonState)) {
        self.actionblock = block;
        return self;
    };
}
@end
