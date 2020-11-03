//
//  KJBaseViewController.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/13.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJBaseViewController.h"

@interface KJBaseViewController ()

@end

@implementation KJBaseViewController
static KJBaseViewController *_instance = nil;
static dispatch_once_t chatOnceToken;
+ (instancetype)kj_shareInstance{
    dispatch_once(&chatOnceToken, ^{
        if(_instance == nil) _instance = [[self alloc] init];
    });
    return _instance;
}
/// 销毁单例
+ (void)kj_attempDealloc{
    chatOnceToken = 0;
    _instance = nil;
}

//+ (instancetype)alloc{
//    if (_instance) {
//        NSString *name = NSStringFromClass([self class]);
//        NSException *exception = [NSException exceptionWithName:@"提示" reason:[NSString stringWithFormat:@"%@类只能初始化一次",name] userInfo:nil];
//        [exception raise];
//    }
//    return [super alloc];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
}


@end
