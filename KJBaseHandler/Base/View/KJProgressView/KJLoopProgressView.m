//
//  KJLoopProgressView.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/11/3.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJLoopProgressView.h"

@implementation KJLoopProgressViewInfo
- (instancetype)init{
    if (self==[super init]) {
        self.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.2];
        self.oneColor = UIColor.greenColor;
        self.progressColor = UIColor.blueColor;
        self.centerColor = UIColor.whiteColor;
        self.width = 5;
        self.font = [UIFont boldSystemFontOfSize:14];
    }
    return self;
}
@end
@interface KJLoopProgressView ()
@property(nonatomic,strong,class) KJLoopProgressViewInfo *info;
@end
@implementation KJLoopProgressView
static KJLoopProgressViewInfo *_info = nil;
+ (KJLoopProgressViewInfo*)info{
    return _info;
}
+ (void)setInfo:(KJLoopProgressViewInfo*)info{
    _info = info;
}
/// 初始化
+ (instancetype)kj_createProgressViewWithInfoBlock:(KJLoopProgressViewInfo*(^)(KJLoopProgressViewInfo *info))block{
    KJLoopProgressViewInfo *info = [[KJLoopProgressViewInfo alloc]init];
    if (block) self.info = block(info);
    return [[self alloc]init];
}
- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [self drawBackground];
    [self drawProgress];
    [self drawCenter];
    [self addCenterLabel];
}
/// 绘制背景圆环
- (void)drawBackground{
    CGColorRef color = KJLoopProgressView.info.backgroundColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}
/// 绘制进度圆环
- (void)drawProgress{
    if (_percent == 0 || _percent > 1) return;
    float endAngle = 2*M_PI*_percent;
    CGColorRef color = _percent==1?KJLoopProgressView.info.oneColor.CGColor:KJLoopProgressView.info.progressColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,endAngle, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}
- (void)drawCenter{
    float width = KJLoopProgressView.info.width;
    CGColorRef color = KJLoopProgressView.info.centerColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2 - width;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius, 0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}
- (void)addCenterLabel{
    NSString *percent = @"";
    float fontSize = KJLoopProgressView.info.font.pointSize;
    UIColor *color = [UIColor blueColor];
    if (_percent == 1) {
        percent = @"100%";
        color = KJLoopProgressView.info.oneColor;
    }else if (_percent < 1 && _percent >= 0){
        color = KJLoopProgressView.info.progressColor;
        percent = [NSString stringWithFormat:@"%0.2f%%",_percent*100];
    }
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:KJLoopProgressView.info.font,
                                 NSForegroundColorAttributeName:color,
                                 NSForegroundColorAttributeName:UIColor.clearColor,
                                 NSParagraphStyleAttributeName:paragraph
    };
    [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, fontSize) withAttributes:attributes];
}


@end
