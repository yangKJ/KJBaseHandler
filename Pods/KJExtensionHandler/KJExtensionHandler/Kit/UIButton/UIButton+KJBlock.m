//
//  UIButton+KJBlock.m
//  KJEmitterView
//
//  Created by 杨科军 on 2019/4/4.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExtensionHandler

#import "UIButton+KJBlock.h"
#import <objc/runtime.h>
@implementation UIButton (KJBlock)
static NSString * const _Nonnull KJButtonControlEventsStringMap[] = {
    [UIControlEventTouchDown]        = @"KJ_X_UIControlEventTouchDown",
    [UIControlEventTouchDownRepeat]  = @"KJ_X_UIControlEventTouchDownRepeat",
    [UIControlEventTouchDragInside]  = @"KJ_X_UIControlEventTouchDragInside",
    [UIControlEventTouchDragOutside] = @"KJ_X_UIControlEventTouchDragOutside",
    [UIControlEventTouchDragEnter]   = @"KJ_X_UIControlEventTouchDragEnter",
    [UIControlEventTouchDragExit]    = @"KJ_X_UIControlEventTouchDragExit",
    [UIControlEventTouchUpInside]    = @"KJ_X_UIControlEventTouchUpInside",
    [UIControlEventTouchUpOutside]   = @"KJ_X_UIControlEventTouchUpOutside",
    [UIControlEventTouchCancel]      = @"KJ_X_UIControlEventTouchCancel",
};
#define KJButtonAction(name) \
- (void)kj_action##name{ \
KJButtonBlock block = objc_getAssociatedObject(self, _cmd);\
if (block) block(self);\
}
/// 事件响应方法
KJButtonAction(KJ_X_UIControlEventTouchDown);
KJButtonAction(KJ_X_UIControlEventTouchDownRepeat);
KJButtonAction(KJ_X_UIControlEventTouchDragInside);
KJButtonAction(KJ_X_UIControlEventTouchDragOutside);
KJButtonAction(KJ_X_UIControlEventTouchDragEnter);
KJButtonAction(KJ_X_UIControlEventTouchDragExit);
KJButtonAction(KJ_X_UIControlEventTouchUpInside);
KJButtonAction(KJ_X_UIControlEventTouchUpOutside);
KJButtonAction(KJ_X_UIControlEventTouchCancel);

/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)kj_addAction:(KJButtonBlock)block{
    [self kj_addAction:block forControlEvents:UIControlEventTouchUpInside];
}
/// 添加事件
- (void)kj_addAction:(KJButtonBlock)block forControlEvents:(UIControlEvents)controlEvents{
    if (block == nil || controlEvents>(1<<8)) return;
    if (controlEvents != UIControlEventTouchDown && (controlEvents&1)) return;
    NSString *actionName = [@"kj_action" stringByAppendingFormat:@"%@",KJButtonControlEventsStringMap[controlEvents]];
    SEL selector = NSSelectorFromString(actionName);
    objc_setAssociatedObject(self, selector, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:selector forControlEvents:controlEvents];
}


#pragma mark - 时间相关方法交换
/// 是否开启时间间隔的方法交换
+ (void)kj_openTimeExchangeMethod{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orSel = @selector(sendAction:to:forEvent:);
        SEL swSel = @selector(kj_sendAction:to:forEvent:);
        Method orMethod = class_getInstanceMethod(self.class, orSel);
        Method swMethod = class_getInstanceMethod(self.class, swSel);
        if (class_addMethod(self.class, orSel, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))){
            class_replaceMethod(self.class, swSel, method_getImplementation(orMethod), method_getTypeEncoding(orMethod));
        }else{
            method_exchangeImplementations(orMethod, swMethod);
        }
    });
}
/// 交换方法后实现
- (void)kj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (self.kj_AcceptEventTime <= 0 && self.kj_AcceptDealTime <= 0) {
        [self kj_sendAction:action to:target forEvent:event];
        return;
    }
    NSTimeInterval time = self.kj_AcceptEventTime > 0 ? self.kj_AcceptEventTime : self.kj_AcceptDealTime;
    BOOL boo = (CFAbsoluteTimeGetCurrent() - self.kLastTime >= time);
    if (self.kj_AcceptEventTime > 0) {
        self.kLastTime = CFAbsoluteTimeGetCurrent();
    }
    if (boo) {
        if (self.kj_AcceptDealTime > 0) {
            self.kLastTime = CFAbsoluteTimeGetCurrent();
        }
        [self kj_sendAction:action to:target forEvent:event];
    }
}
#pragma mark - associated
- (NSTimeInterval)kj_AcceptEventTime{
    return [objc_getAssociatedObject(self, @selector(kj_AcceptEventTime)) doubleValue];
}
- (void)setKj_AcceptEventTime:(NSTimeInterval)kj_AcceptEventTime{
    objc_setAssociatedObject(self, @selector(kj_AcceptEventTime), @(kj_AcceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)kj_AcceptDealTime{
    return [objc_getAssociatedObject(self, @selector(kj_AcceptDealTime)) doubleValue];
}
- (void)setKj_AcceptDealTime:(NSTimeInterval)kj_AcceptDealTime{
    objc_setAssociatedObject(self, @selector(kj_AcceptDealTime), @(kj_AcceptDealTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)kLastTime{
    return [objc_getAssociatedObject(self, @selector(kLastTime)) doubleValue];
}
- (void)setKLastTime:(NSTimeInterval)kLastTime{
    objc_setAssociatedObject(self, @selector(kLastTime), @(kLastTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
