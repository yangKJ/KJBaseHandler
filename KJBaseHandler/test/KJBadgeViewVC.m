//
//  KJBadgeViewVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/27.
//

#import "KJBadgeViewVC.h"
#import "KJBadgeView.h"
@interface KJBadgeViewVC ()

@end

@implementation KJBadgeViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, 100, 50);
    view.center = self.view.center;
    view.centerY -= 20;
    view.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:view];
    
    __block NSInteger index = 7;
    __block KJBadgeView *badgeView = [KJBadgeView kj_createBadgeView:view InfoBlock:^KJBadgeViewInfo * _Nonnull(KJBadgeViewInfo * _Nonnull info) {
        info.badgeValue = index;
        info.positionType = KJBadgePositionTypeTopLeft;
        return info;
    }];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 100, 40);
    button.center = self.view.center;
    button.centerY += 50;
    button.borderColor = UIColor.blueColor;
    button.borderWidth = 1;
    [self.view addSubview:button];
    button.titleLabel.font = kSystemBlodFontSize(16);
    [button setTitle:@"增加" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [button kj_addAction:^(UIButton * _Nonnull kButton) {
        index+=9;
        [badgeView kj_setBadgeValue:index Animated:YES];
    }];
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 0, 100, 40);
        button.center = self.view.center;
        button.centerY += 100;
        button.borderColor = UIColor.blueColor;
        button.borderWidth = 1;
        [self.view addSubview:button];
        button.titleLabel.font = kSystemBlodFontSize(16);
        [button setTitle:@"减小" forState:(UIControlStateNormal)];
        [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
        [button kj_addAction:^(UIButton * _Nonnull kButton) {
            index-=32;
            [badgeView kj_setBadgeValue:index Animated:YES];
        }];
    }
    
    {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 0, 100, 40);
        button.center = self.view.center;
        button.centerY += 150;
        button.borderColor = UIColor.blueColor;
        button.borderWidth = 1;
        [self.view addSubview:button];
        button.titleLabel.font = kSystemBlodFontSize(16);
        [button setTitle:@"归零" forState:(UIControlStateNormal)];
        [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
        [button kj_addAction:^(UIButton * _Nonnull kButton) {
            index = 0;
            [badgeView kj_setBadgeValue:index Animated:YES];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
