//
//  KJRunloopManager.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/25.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJRunloopManager.h"
@interface KJRunloopManager()
@property(nonatomic,strong)NSMutableArray *temps;
@end
@implementation KJRunloopManager
+ (instancetype)sharedInstance {
    static KJRunloopManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:_shared selector:@selector(timeCount) userInfo:nil repeats:YES];
    });
    return _shared;
}
/// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone*)zone {
    return [KJRunloopManager sharedInstance];
}
/// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone*)zone {
    return [KJRunloopManager sharedInstance];
}

- (void)timeCount{ }

- (instancetype)init{
    if(self == [super init]){
        CFRunLoopRef ref = CFRunLoopGetCurrent();
        CFRunLoopObserverContext ctx = {0, (__bridge void *)self, &CFRetain, &CFRelease, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &kCallback, &ctx);
        CFRunLoopAddObserver(ref, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    }
    return self;
}
void kCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    KJRunloopManager *manager = (__bridge KJRunloopManager*)info;
    if(!manager.temps.count) return;
    void (^kCallback)(void) = manager.temps.firstObject;
    kCallback();
    [manager.temps removeObjectAtIndex:0];
}
- (void)kj_addRunloopBlock:(void (^)(void))block{
    [self.temps addObject:block];
}

@end
