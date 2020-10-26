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
        self.position = KJBadgePositionTypeTopRight;
        self.font = [UIFont systemFontOfSize:12.f];
        self.textColor = [UIColor whiteColor];
        self.badgeColor = [UIColor redColor];
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
    if (_info == nil) _info = [[KJBadgeViewInfo alloc]init];
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
}

- (void)kj_setBadgeValue:(NSString*)badgeValue Animated:(BOOL)animated{
    if (badgeValue.length <= 0) return;
    KJBadgeView.info.badgeValue = badgeValue;
    if (animated) {
        [UIView animateWithDuration:0.15f animations:^{
            self.alpha = badgeValue.length == 0 ? 0 : 1;
        }];
    }else {
        self.alpha = badgeValue.length == 0 ? 0 : 1;
    }
    self.label.text = badgeValue;
    [self.label sizeToFit];
    if (self.label.width + KJBadgeView.info.sensitiveTextWidth > self.width) {
        self.width += KJBadgeView.info.sensitiveWidth;
    }else {
        self.width = KJBadgeView.info.fixedHeight;
    }
    self.label.center = self.center;
    CGFloat offset = KJBadgeView.info.fixedHeight / 2.f;
    switch (KJBadgeView.info.position) {
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
            self.x = self.contentView.width - offset;
            self.y = self.contentView.height - offset;
        }
            break;
        default:
            break;
    }
}

@end
