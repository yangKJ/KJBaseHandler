//
//  KJBadgeView.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/26.
//

#import "KJBadgeView.h"
@implementation KJBadgeViewInfo
- (instancetype)init {
    if (self = [super init]) {
        self.sensitiveWidth = 10;
        self.fixedHeight = 20;
        self.sensitiveTextWidth = 4;
        self.positionType = KJBadgePositionTypeTopRight;
        self.font = [UIFont systemFontOfSize:12.f];
        self.textColor = [UIColor whiteColor];
        self.badgeColor = [UIColor redColor];
        self.zeroHidden = true;
    }
    return self;
}
@end
@interface KJBadgeView ()
@property(nonatomic,strong,class) KJBadgeViewInfo *info;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UILabel *label;
@end

@implementation KJBadgeView
static KJBadgeViewInfo *_info = nil;
+ (KJBadgeViewInfo*)info{
    return _info;
}
+ (void)setInfo:(KJBadgeViewInfo *)info{
    _info = info;
}
/// 初始化
+ (instancetype)kj_createBadgeView:(UIView*)contentView InfoBlock:(KJBadgeViewInfo*(^)(KJBadgeViewInfo *info))block{
    KJBadgeViewInfo *info = [[KJBadgeViewInfo alloc]init];
    if (block) self.info = block(info);
    KJBadgeView *view = [[KJBadgeView alloc]init];
    [view makeView:contentView];
    return view;
}
- (void)makeView:(UIView*)contentView{
    self.contentView = contentView;
    self.label = [[UILabel alloc] init];
    self.label.textColor = KJBadgeView.info.textColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = KJBadgeView.info.font;
    [self addSubview:self.label];
    self.backgroundColor = KJBadgeView.info.badgeColor;
    self.height = self.width = KJBadgeView.info.fixedHeight;
    self.layer.cornerRadius = KJBadgeView.info.fixedHeight / 2.f;
    self.layer.masksToBounds = YES;
    [contentView addSubview:self];
    [self kj_setBadgeValue:KJBadgeView.info.badgeValue Animated:NO];
}
- (void)kj_setBadgeValue:(NSInteger)badgeValue Animated:(BOOL)animated{
    KJBadgeView.info.badgeValue = badgeValue;
    if (animated) {
        [UIView animateWithDuration:0.15f animations:^{
            if (KJBadgeView.info.zeroHidden) self.alpha = badgeValue == 0 ? 0 : 1;
        }];
    }else {
        if (KJBadgeView.info.zeroHidden) self.alpha = badgeValue == 0 ? 0 : 1;
    }
    self.label.text = [NSString stringWithFormat:@"%ld",badgeValue];
    [self.label sizeToFit];
    if (self.label.width + KJBadgeView.info.sensitiveTextWidth > self.width) {
        self.width += KJBadgeView.info.sensitiveWidth;
    }else{
        self.width = self.label.width + KJBadgeView.info.sensitiveWidth;
        if (self.width < KJBadgeView.info.fixedHeight) self.width = KJBadgeView.info.fixedHeight;
    }
    self.label.center = CGPointMake(self.width/2, self.height/2);
    CGFloat offset = KJBadgeView.info.fixedHeight / 2.f;
    switch (KJBadgeView.info.positionType) {
        case KJBadgePositionTypeCenterLeft:{
            self.x = -offset;
            self.centerY = self.contentView.centerY;
        }
            break;
        case KJBadgePositionTypeCenterRight:{
            self.x = self.contentView.width - offset;
            self.centerY = self.contentView.centerY;
        }
            break;
        case KJBadgePositionTypeTopLeft:{
            self.y = self.x = -offset;
        }
            break;
        case KJBadgePositionTypeTopRight:{
            self.y = -offset;
            self.x = self.contentView.width - offset;
        }
            break;
        case KJBadgePositionTypeBottomLeft:{
            self.x = -offset;
            self.y = self.contentView.height - offset;
        }
            break;
        case KJBadgePositionTypeBottomRight:{
            self.x = self.contentView.width  - offset;
            self.y = self.contentView.height - offset;
        }
            break;
        default:
            break;
    }
}

@end
