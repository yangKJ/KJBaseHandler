//
//  KJBadgeView.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/26.
//  https://github.com/yangKJ/KJBaseHandler

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
@property(nonatomic,strong) UILabel *textLabel;
@end

@implementation KJBadgeView
static KJBadgeViewInfo *_info = nil;
+ (KJBadgeViewInfo*)info{
    return _info;
}
+ (void)setInfo:(KJBadgeViewInfo*)info{
    _info = info;
}
/// 初始化
+ (instancetype)kj_createBadgeView:(UIView*)contentView InfoBlock:(KJBadgeViewInfo*(^)(KJBadgeViewInfo *info))block{
    KJBadgeViewInfo *info = [[KJBadgeViewInfo alloc]init];
    if (block) self.info = block(info);
    KJBadgeView *view = [[self alloc]init];
    [view makeView:contentView];
    return view;
}
- (void)makeView:(UIView*)contentView{
    self.contentView = contentView;
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = KJBadgeView.info.textColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = KJBadgeView.info.font;
    [self addSubview:self.textLabel];
    self.backgroundColor = KJBadgeView.info.badgeColor;
    self.height = self.width = KJBadgeView.info.fixedHeight;
    self.layer.cornerRadius = KJBadgeView.info.fixedHeight / 2.f;
    self.layer.masksToBounds = YES;
    [contentView addSubview:self];
    [self kj_setBadgeValue:KJBadgeView.info.badgeValue Animated:NO];
}
- (void)kj_setBadgeValue:(NSInteger)badgeValue Animated:(BOOL)animated{
    KJBadgeView.info.badgeValue = badgeValue;
    self.textLabel.text = [NSString stringWithFormat:@"%ld",badgeValue];
    [self.textLabel sizeToFit];
    if (animated) {
        [UIView animateWithDuration:0.15f animations:^{
            if (KJBadgeView.info.zeroHidden) self.alpha = badgeValue == 0 ? 0 : 1;
        }];
    }else {
        if (KJBadgeView.info.zeroHidden) self.alpha = badgeValue == 0 ? 0 : 1;
    }
    if (self.textLabel.width + KJBadgeView.info.sensitiveTextWidth > self.width) {
        self.width += KJBadgeView.info.sensitiveWidth;
    }else{
        self.width = self.textLabel.width + KJBadgeView.info.sensitiveWidth;
        if (self.width < KJBadgeView.info.fixedHeight) self.width = KJBadgeView.info.fixedHeight;
    }
    self.textLabel.center = CGPointMake(self.width/2., self.height/2.);
    CGFloat offset = KJBadgeView.info.fixedHeight / 2.f;
    switch (KJBadgeView.info.positionType) {
        case KJBadgePositionTypeCenterLeft:
            self.x = -offset;
            self.centerY = self.contentView.height/2.;
            break;
        case KJBadgePositionTypeCenterRight:
            self.x = self.contentView.width - offset;
            self.centerY = self.contentView.height/2.;
            break;
        case KJBadgePositionTypeTopLeft:
            self.y = self.x = -offset;
            break;
        case KJBadgePositionTypeTopRight:
            self.x = self.contentView.width - offset;
            self.y = -offset;
            break;
        case KJBadgePositionTypeBottomLeft:
            self.x = -offset;
            self.y = self.contentView.height - offset;
            break;
        case KJBadgePositionTypeBottomRight:
            self.x = self.contentView.width  - offset;
            self.y = self.contentView.height - offset;
            break;
        case KJBadgePositionTypeCenter:
            self.centerX = self.contentView.width/2.;
            self.centerY = self.contentView.height/2.;
        default:
            break;
    }
}

@end
