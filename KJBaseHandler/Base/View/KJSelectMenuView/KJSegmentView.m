//
//  KJSegmentView.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/29.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJSegmentView.h"

@implementation KJSegmentViewInfo
- (instancetype)init{
    if (self==[super init]) {
        self.backgroundColor = UIColor.yellowColor;
        self.selectedBackgroundColor = UIColor.redColor;
        self.textColor = UIColor.blackColor;
        self.selectedTextColor = UIColor.whiteColor;
        self.textFont = kSystemFontSize(15);
        self.animateDuration = 0.3;
        self.selectIndex = 0;
    }
    return self;
}
@end
@interface KJSegmentView ()
@property(nonatomic,strong,class) KJSegmentViewInfo *info;
@property(nonatomic,strong) UILabel *selectLabel;
@end
@implementation KJSegmentView
static KJSegmentViewInfo *_info = nil;
+ (KJSegmentViewInfo*)info{
    return _info;
}
+ (void)setInfo:(KJSegmentViewInfo*)info{
    _info = info;
}
/// 初始化
+ (instancetype)kj_createSelectMenuViewWithInfoBlock:(KJSegmentViewInfo*(^)(KJSegmentViewInfo *info))block{
    KJSegmentViewInfo *info = [[KJSegmentViewInfo alloc]init];
    if (block) self.info = block(info);
    return [[self alloc]init];
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    if(!dataSource.count) return;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:self];
    __block NSInteger count = dataSource.count;
    CGFloat w = self.width / count;
    CGFloat h = self.height;
    _weakself;
    for (int i = 0; i < count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * w, 0, w, h)];
        label.text = dataSource[i];
        label.backgroundColor = KJSegmentView.info.backgroundColor;
        label.textColor = KJSegmentView.info.textColor;
        label.font = KJSegmentView.info.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 520 + i;
        [self addSubview:label];
        [label kj_AddTapGestureRecognizerBlock:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
            weakself.selectLabel.text = dataSource[view.tag-520];
            [UIView animateWithDuration:KJSegmentView.info.animateDuration animations:^{
                [weakself kj_changeSelectWithIndex:view.tag-520];
            }];
        }];
    }
    UILabel *selectView = [[UILabel alloc]initWithFrame:CGRectMake((count-1) * w, 0, w, h)];
    self.selectLabel = selectView;
    selectView.textAlignment = NSTextAlignmentCenter;
    selectView.textColor = KJSegmentView.info.selectedTextColor;
    selectView.font = KJSegmentView.info.textFont;
    selectView.backgroundColor = KJSegmentView.info.selectedBackgroundColor;
    [self addSubview:selectView];
    [selectView kj_AddGestureRecognizer:(KJGestureTypePan) block:^(UIView * _Nonnull view, UIGestureRecognizer * _Nonnull gesture) {
        CGFloat tempX = view.center.x;
        CGPoint translation = [(UIPanGestureRecognizer*)gesture translationInView:view.superview];
        if (tempX <= w/2.) {
            if(translation.x < 0) translation.x = 0;
        }
        if (tempX >= weakself.width-w/2.) {
            if(translation.x > 0) translation.x = 0;
        }
        view.center = CGPointMake(tempX+translation.x, weakself.height/2.);
        [(UIPanGestureRecognizer*)gesture setTranslation:CGPointZero inView:view.superview];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            weakself.selectLabel.text = @"";
        }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            [UIView animateWithDuration:KJSegmentView.info.animateDuration animations:^{
                [self kj_changeSelectWithIndex:tempX / w];
            }];
        }
    }];
    //默认选中
    KJSegmentView.info.selectIndex = MIN(KJSegmentView.info.selectIndex, count-1);
    [self kj_changeSelectWithIndex:KJSegmentView.info.selectIndex];
}
/// 改变选中状态
- (void)kj_changeSelectWithIndex:(NSInteger)index{
    CGFloat w = self.width / self.dataSource.count;
    self.selectLabel.center = CGPointMake(w * index + 0.5 * w, self.height / 2.);
    self.selectLabel.text = ((UILabel*)[self viewWithTag:520+index]).text;
    if (self.kSelectedMenuBlock) {
        self.kSelectedMenuBlock(index,self.selectLabel.text);
    }
}

@end
