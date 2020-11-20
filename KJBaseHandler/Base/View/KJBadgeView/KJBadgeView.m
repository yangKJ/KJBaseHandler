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
@interface KJBadgeView (){
    NSMutableDictionary *_separateBlockDictionary;//存储 view 消失时触发的 block 的字典
    UIPanGestureRecognizer *_gesture;//手势监控。
    UIColor *_fillColorForCute;//填充黏贴效果的颜色
    UIColor *_bubbleColor;//黏贴效果的颜色
    CGFloat _bubbleWidth;//被拖动的 view 的最小边长
    
    CGFloat _R1, _R2, _X1, _X2, _Y1, _Y2;//原始 view 和拖动的 view 的半径和圆心坐标
    CGFloat _centerDistance;//原始view和拖动的 view 圆心距离
    CGFloat _maxDistance;//黏贴效果最大距离
    CGFloat _cosDigree;//两圆心所在直线和Y轴夹角的 cosine 值
    CGFloat _sinDigree;//两圆心所在直线和Y轴夹角的 sine 值
    //圆的关键点 A,B,E 是初始位置上圆的左右后三点，C，D,F 是移动位置上的圆的三点，O，P两个圆之间画弧线所需要的点，_pointTemp是辅助点。
    CGPoint _pointA, _pointB, _pointC, _pointD, _pointE, _pointF, _pointO, _pointP, _pointTemp, _pointTemp2;
    //画圆弧的辅助点
    CGPoint _pointDF1, _pointDF2, _pointFC1, _pointFC2, _pointBE1, _pointBE2, _pointEA1, _pointEA2, _pointAO1, _pointAO2, _pointOD1, _pointOD2, _pointCP1, _pointCP2, _pointPB1, _pointPB2;
    //offset 指的是 _pointA-_pointEA2,_pointEA1-_pointE... 的距离，当该值设置为正方形边长的 1/3.6 倍时，画出来的圆弧近似贴合 1/4 圆;
    CGFloat _offset1, _offset2;
    CGFloat _percentage;//_centerDistance/_maxDistance
    
    CGPoint _deviationPoint;//拖动坐标和 原始 view 中心的距离差
    CGPoint _oldBackViewCenter;//原始 view 的中心坐标
    CAShapeLayer *_shapeLayer; //黏贴效果的形状。
    AdhesivePlateStatus _status;//黏贴状态。
}

@property(nonatomic,strong,class) KJBadgeViewInfo *info;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIView *touchView;//被手势拖动的 view
@property(nonatomic,strong) UIImageView *prototypeView; //替换被拖动 view 的 imageView
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
    
    _bubbleColor = KJBadgeView.info.badgeColor;
    _maxDistance = 75;
    _prototypeView = [[UIImageView alloc] init];
    _separateBlockDictionary = [[NSMutableDictionary alloc] init];
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
/// 设置拖拽粘附效果
- (void)kj_attachWithSeparateBlock:(BOOL(^)(UIView *view))separateBlock{
    UIView *item = self;
    NSValue *viewValue = [NSValue valueWithNonretainedObject:item];
    if (!_separateBlockDictionary[viewValue]) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
        item.userInteractionEnabled = YES;
        [item addGestureRecognizer:gesture];
    }
    if (separateBlock) {
        [_separateBlockDictionary setObject:separateBlock forKey:[NSValue valueWithNonretainedObject:item]];
    }else {
        BOOL(^block)(UIView *view) = ^BOOL(UIView *view) {
            return NO;
        };
        [_separateBlockDictionary setObject:block forKey:[NSValue valueWithNonretainedObject:item]];
    }
}
- (void)handleDragGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint dragPoint = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _touchView = gesture.view;
        CGPoint dragPountInView = [gesture locationInView:gesture.view];
        _deviationPoint = CGPointMake(dragPountInView.x - gesture.view.frame.size.width/2, dragPountInView.y - gesture.view.frame.size.height/2);
        [self setUp];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        _prototypeView.center =  CGPointMake(dragPoint.x - _deviationPoint.x, dragPoint.y - _deviationPoint.y);
        [self drawRect];
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        if (_centerDistance > _maxDistance) {
            BOOL(^block)(UIView *view) = _separateBlockDictionary[[NSValue valueWithNonretainedObject:_touchView]];
            if (block) {
                BOOL animationEnable = block(_touchView);
                if (animationEnable) {
                    [_prototypeView removeFromSuperview];
                    [self explosion:_prototypeView.center radius:_bubbleWidth];
                }else{
                    [self springBack:_prototypeView point:_oldBackViewCenter];
                }
            }
        }else{
            _fillColorForCute = [UIColor clearColor];
            [_shapeLayer removeFromSuperlayer];
            [self springBack:_prototypeView point:_oldBackViewCenter];
        }
    }
}

- (void)setUp {
    [kKeyWindow addSubview:self];
    CGPoint animationViewOrigin = [_touchView convertPoint:CGPointMake(0, 0) toView:self];
    _prototypeView.frame = CGRectMake(animationViewOrigin.x, animationViewOrigin.y, _touchView.frame.size.width, _touchView.frame.size.height);
    _prototypeView.image = [self getImageFromView:_touchView];
    [self addSubview:_prototypeView];
    
    _shapeLayer = [CAShapeLayer layer];
    _bubbleWidth = MIN(_prototypeView.frame.size.width, _prototypeView.frame.size.height) - 1;
    _R2 = _bubbleWidth/2;
    _offset2 = _R2*2/3.6;
    _centerDistance = 0;
    _oldBackViewCenter = CGPointMake(animationViewOrigin.x + _touchView.frame.size.width/2, animationViewOrigin.y + _touchView.frame.size.height/2);
    _X1 = _oldBackViewCenter.x;
    _Y1 = _oldBackViewCenter.y;
    _fillColorForCute = _bubbleColor;
    
    _touchView.hidden = YES;
    self.userInteractionEnabled = YES;
    _status = AdhesivePlateStickers;
}

//求出所有关键点，用贝塞尔曲线绘制出黏贴效果。
- (void)drawRect {
    _X2 = _prototypeView.center.x;
    _Y2 = _prototypeView.center.y;
    _centerDistance = sqrtf((_X2 - _X1)*(_X2 - _X1) + (_Y2 - _Y1)*(_Y2 - _Y1));
    if (_status == AdhesivePlateSeparate) {
        return;
    }
    if (_centerDistance > _maxDistance) {
        _status = AdhesivePlateSeparate;
        _fillColorForCute = [UIColor clearColor];
        [_shapeLayer removeFromSuperlayer];
        return;
    }
    if (_centerDistance == 0) {
        _cosDigree = 1;
        _sinDigree = 0;
    } else {
        _cosDigree = (_Y2 - _Y1)/_centerDistance;
        _sinDigree = (_X2 - _X1)/_centerDistance;
    }
     _percentage = _centerDistance/_maxDistance;
    _R1 = (2 - _percentage/2)*_bubbleWidth/4;
    _offset1 = _R1*2/3.6;
    _offset2 = _R2*2/3.6;
    _pointA = CGPointMake(_X1 - _R1*_cosDigree, _Y1 + _R1*_sinDigree);
    _pointB = CGPointMake(_X1 + _R1*_cosDigree, _Y1 - _R1*_sinDigree);
    _pointE = CGPointMake(_X1 - _R1*_sinDigree, _Y1 - _R1*_cosDigree);
    _pointC = CGPointMake(_X2 + _R2*_cosDigree, _Y2 - _R2*_sinDigree);
    _pointD = CGPointMake(_X2 - _R2*_cosDigree, _Y2 + _R2*_sinDigree);
    _pointF = CGPointMake(_X2 + _R2*_sinDigree, _Y2 + _R2*_cosDigree);
    
    _pointEA2 = CGPointMake(_pointA.x - _offset1*_sinDigree, _pointA.y - _offset1*_cosDigree);
    _pointEA1 = CGPointMake(_pointE.x - _offset1*_cosDigree, _pointE.y + _offset1*_sinDigree);
    _pointBE2 = CGPointMake(_pointE.x + _offset1*_cosDigree, _pointE.y - _offset1*_sinDigree);
    _pointBE1 = CGPointMake(_pointB.x - _offset1*_sinDigree, _pointB.y - _offset1*_cosDigree);
    
    _pointFC2 = CGPointMake(_pointC.x + _offset2*_sinDigree, _pointC.y + _offset2*_cosDigree);
    _pointFC1 = CGPointMake(_pointF.x + _offset2*_cosDigree, _pointF.y - _offset2*_sinDigree);
    _pointDF2 = CGPointMake(_pointF.x - _offset2*_cosDigree, _pointF.y + _offset2*_sinDigree);
    _pointDF1 = CGPointMake(_pointD.x + _offset2*_sinDigree, _pointD.y + _offset2*_cosDigree);
    
    _pointTemp = CGPointMake(_pointD.x + _percentage*(_X2 - _pointD.x), _pointD.y + _percentage*(_Y2 - _pointD.y));//关键点
    _pointTemp2 = CGPointMake(_pointD.x + (2 - _percentage)*(_X2 - _pointD.x), _pointD.y + (2 - _percentage)*(_Y2 - _pointD.y));
    
    _pointO = CGPointMake(_pointA.x + (_pointTemp.x - _pointA.x)/2, _pointA.y + (_pointTemp.y - _pointA.y)/2);
    _pointP = CGPointMake(_pointB.x + (_pointTemp2.x - _pointB.x)/2, _pointB.y + (_pointTemp2.y - _pointB.y)/2);
    
    _offset1 = _offset2 = _centerDistance/8;
    
    _pointAO1 = CGPointMake(_pointA.x + _offset1*_sinDigree, _pointA.y + _offset1*_cosDigree);
    _pointAO2 = CGPointMake(_pointO.x - (3*_offset2-_offset1)*_sinDigree, _pointO.y - (3*_offset2-_offset1)*_cosDigree);
    _pointOD1 = CGPointMake(_pointO.x + 2*_offset2*_sinDigree, _pointO.y + 2*_offset2*_cosDigree);
    _pointOD2 = CGPointMake(_pointD.x - _offset2*_sinDigree, _pointD.y - _offset2*_cosDigree);
    
    _pointCP1 = CGPointMake(_pointC.x - _offset2*_sinDigree, _pointC.y - _offset2*_cosDigree);
    _pointCP2 = CGPointMake(_pointP.x + 2*_offset2*_sinDigree, _pointP.y + 2*_offset2*_cosDigree);
    _pointPB1 = CGPointMake(_pointP.x - (3*_offset2-_offset1)*_sinDigree, _pointP.y - (3*_offset2-_offset1)*_cosDigree);
    _pointPB2 = CGPointMake(_pointB.x + _offset1*_sinDigree, _pointB.y + _offset1*_cosDigree);
    
    UIBezierPath *_cutePath = [UIBezierPath bezierPath];
    [_cutePath moveToPoint:_pointB];
    [_cutePath addCurveToPoint:_pointE controlPoint1:_pointBE1 controlPoint2:_pointBE2];
    [_cutePath addCurveToPoint:_pointA controlPoint1:_pointEA1 controlPoint2:_pointEA2];
    [_cutePath addCurveToPoint:_pointO controlPoint1:_pointAO1 controlPoint2:_pointAO2];
    [_cutePath addCurveToPoint:_pointD controlPoint1:_pointOD1 controlPoint2:_pointOD2];
    
    [_cutePath addCurveToPoint:_pointF controlPoint1:_pointDF1 controlPoint2:_pointDF2];
    [_cutePath addCurveToPoint:_pointC controlPoint1:_pointFC1 controlPoint2:_pointFC2];
    [_cutePath addCurveToPoint:_pointP controlPoint1:_pointCP1 controlPoint2:_pointCP2];
    [_cutePath addCurveToPoint:_pointB controlPoint1:_pointPB1 controlPoint2:_pointPB2];
    
    _shapeLayer.path = [_cutePath CGPath];
    _shapeLayer.fillColor = [_fillColorForCute CGColor];
    [self.layer insertSublayer:_shapeLayer below:_prototypeView.layer];
}
//爆炸效果
- (void)explosion:(CGPoint)explosionPoint radius:(CGFloat)radius{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 1; i < 6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"KJBase.bundle/qipao_%d",i]];
        [array addObject:image];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, radius*2, radius*2);
    imageView.center = explosionPoint;
    imageView.animationImages = array;
    [imageView setAnimationDuration:0.25];
    [imageView setAnimationRepeatCount:1];
    [imageView startAnimating];
    [self addSubview:imageView];
    [self performSelector:@selector(explosionComplete) withObject:nil afterDelay:0.25 inModes:@[NSDefaultRunLoopMode]];
}
//爆炸动画结束
- (void)explosionComplete {
    _touchView.hidden = YES;
    [self removeFromSuperview];
}
//回弹效果
- (void)springBack:(UIView*)view point:(CGPoint)point {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.center = point;
    } completion:^(BOOL finished) {
        if (finished) {
            self.touchView.hidden = NO;
            self.userInteractionEnabled = NO;
            [view removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

//将 view 的显示效果转成一张 image
- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
