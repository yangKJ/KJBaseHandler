//
//  KJBaseNavigationController.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJBaseNavigationController.h"

@interface KJBaseNavigationController ()

@end

@implementation KJBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
