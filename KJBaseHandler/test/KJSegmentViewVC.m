//
//  KJSegmentViewVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/29.
//

#import "KJSegmentViewVC.h"
#import "KJSegmentView.h" /// 选择菜单控件
@interface KJSegmentViewVC ()

@end

@implementation KJSegmentViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KJSegmentView *view = [KJSegmentView kj_createSelectMenuViewWithInfoBlock:^KJSegmentViewInfo * _Nonnull(KJSegmentViewInfo * _Nonnull info) {
        info.selectIndex = 5;
        return info;
    }];
    view.frame = CGRectMake(0, 100, kScreenW, 40);
    [self.view addSubview:view];
//    view.dataSource = @[@"A",@"B",@"C"];
    view.kSelectedMenuBlock = ^(NSInteger index, NSString * _Nonnull text) {
        NSLog(@"%@",[NSString stringWithFormat:@"index:%ld, text:%@",index,text]);
    };
    view.dataSource = @[@"X",@"B",@"C",@"D"];
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
