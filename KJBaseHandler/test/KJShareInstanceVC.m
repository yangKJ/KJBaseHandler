//
//  KJShareInstanceVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/27.
//

#import "KJShareInstanceVC.h"

@interface KJShareInstanceVC ()

@end

@implementation KJShareInstanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kRandomColor();
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = self.view.center;
    button.borderColor = UIColor.whiteColor;
    button.borderWidth = 1;
    [self.view addSubview:button];
    button.titleLabel.font = kSystemBlodFontSize(16);
    [button setTitle:@"销毁单例" forState:(UIControlStateNormal)];
    _weakself;
    [button kj_addAction:^(UIButton * _Nonnull kButton) {
        [weakself.navigationController popViewControllerAnimated:YES];
        [KJShareInstanceVC kj_attempDealloc];
    }];
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
