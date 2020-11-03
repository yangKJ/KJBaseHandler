//
//  KJProgressViewVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/11/3.
//

#import "KJProgressViewVC.h"
#import "KJLoopProgressView.h"
@interface KJProgressViewVC ()
@property(nonatomic,strong)KJLoopProgressView *progressView;
@end

@implementation KJProgressViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    KJLoopProgressView *view = [KJLoopProgressView kj_createProgressViewWithInfoBlock:^KJLoopProgressViewInfo * _Nonnull(KJLoopProgressViewInfo * _Nonnull info) {
        return info;
    }];
    view.frame = CGRectMake(0, 0, 100, 100);
    view.center = self.view.center;
    [self.view addSubview:view];
    view.backgroundColor = UIColor.whiteColor;
    self.progressView = view;
    
    view.percent = 0.3;
    
    UISlider *slder = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    slder.centerX = view.centerX;
    slder.y = view.bottom + 50;
    slder.minimumValue = 0;
    slder.maximumValue = 1;
    slder.value = view.percent;
    [self.view addSubview:slder];
    [slder addTarget:self action:@selector(change:) forControlEvents:(UIControlEventValueChanged)];
}
- (void)change:(UISlider*)sender{
    self.progressView.percent = sender.value;
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
