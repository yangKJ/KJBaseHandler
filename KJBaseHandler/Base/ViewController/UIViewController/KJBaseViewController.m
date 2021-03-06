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
        if(_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}
/// 销毁单例
+ (void)kj_attempDealloc{
    chatOnceToken = 0;
    _instance = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
}


@end
