//
//  KJBaseNavigationController.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJBaseNavigationController.h"
#import "UINavigationItem+KJExtension.h"
@interface KJBaseNavigationController ()<UINavigationControllerDelegate>
@property(nonatomic,strong) id popGestureDelegate;

@end

@implementation KJBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

/// 返回指定的控制器
- (NSArray*)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated{
    UIViewController *viewController;
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(className)]) {
            viewController = vc;
            break;
        }
    }
    if (viewController == nil) return [self popToRootViewControllerAnimated:animated];
    return [self popToViewController:viewController animated:YES];
}

- (void)navigationController:(UINavigationController*)navigationController didShowViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if ([self.topViewController isEqual:self.viewControllers[0]]) {
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        __weak __typeof(&*self) weakself = self;
        [viewController.navigationItem kj_makeNavigationItem:^(UINavigationItem * _Nonnull make) {
            make.kAddBarButtonItemInfo(^KJNavigationItemInfo * _Nonnull(KJNavigationItemInfo * _Nonnull info) {
                info.imageName = @"KJBase.bundle/Arrow";
                info.tintColor = UIColor.whiteColor;
                return info;
            }, ^(UIButton * _Nonnull kButton) {
                [weakself.view endEditing:YES];
                [weakself popViewControllerAnimated:YES];
            });
        }];
    }
    [super pushViewController:viewController animated:animated];
}

@end
