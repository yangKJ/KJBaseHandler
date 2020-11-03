//
//  KJBaseButtonVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/28.
//

#import "KJBaseButtonVC.h"

@interface KJBaseButtonVC ()

@end

@implementation KJBaseButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _weakself;
    {
        KJBaseButton *button = [KJBaseButton kj_createButtonWithExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
            obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 120, 100)).kBackgroundColor([UIColor.orangeColor colorWithAlphaComponent:0.3]);
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.title = @"按钮";
                info.imageName = @"IMG_4931";
                info.state = KJBaseButtonStateNormal;
                info.buttonStyle = KJBaseButtonLayoutStyleCenterImageRight;
                info.color = UIColor.orangeColor;
                return info;
            });
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.title = @"按钮选中";
                info.imageName = @"1wode_nor";
                info.state = KJBaseButtonStateSelected;
                info.buttonStyle = KJBaseButtonLayoutStyleCenterImageRight;
                info.color = UIColor.redColor;
                return info;
            });
            obj.kAction(^(KJBaseButton *kButton,KJBaseButtonState state) {
                NSLog(@"内容居中 - 图右文左");
                kButton.isSelected = !kButton.isSelected;
            });
        }];
        button.y = 20+64;
        button.centerX = self.view.centerX/2.;
        button.borderWidth = 1.5;
        button.borderColor = UIColor.orangeColor;
    }
    {
        KJBaseButton *button = [KJBaseButton kj_createButtonWithExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
            obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 120, 100)).kBackgroundColor([UIColor.orangeColor colorWithAlphaComponent:0.3]);
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.imageName = @"1wode_nor";
                return info;
            });
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.title = @"isDisabled";
                info.imageName = @"1wode_nor";
                info.state = KJBaseButtonStateDisabled;
                return info;
            });
            obj.kAction(^(KJBaseButton *kButton,KJBaseButtonState state) {
                NSLog(@"内容居中 - 图上文下");
                kButton.isDisabled = !kButton.isDisabled;
            });
        }];
        button.y = 20+64;
        button.centerX = self.view.centerX+self.view.centerX/2;
        button.borderWidth = 1.5;
        button.borderColor = UIColor.orangeColor;
    }
    {
        KJBaseButton *button = [KJBaseButton kj_createButtonWithExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
            obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 120, 100)).kBackgroundColor([UIColor.orangeColor colorWithAlphaComponent:0.3]);
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.imageName = @"IMG_4931";
                info.space = 20;
                info.buttonStyle = KJBaseButtonLayoutStyleCenterImageBottom;
                info.labelMaxSize = CGSizeMake(100, 20);
                return info;
            });
        }];
        button.y = 20+64+120;
        button.centerX = self.view.centerX/2.;
        button.borderWidth = 1.5;
        button.borderColor = UIColor.orangeColor;
    }
    {
        KJBaseButton *button = [KJBaseButton kj_createButtonWithExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
            obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 120, 100)).kBackgroundColor([UIColor.orangeColor colorWithAlphaComponent:0.3]);
            obj.kStateInfos(^KJBaseButtonInfo * _Nonnull(KJBaseButtonInfo * _Nonnull info) {
                info.title = @"按按按按按按按钮按按按按按按";
                info.imageName = @"1wode_nor";
                info.buttonStyle = KJBaseButtonLayoutStyleCenterImageTop;
                info.imageMaxSize = CGSizeMake(50, 50);
                return info;
            });
        }];
        button.label.font = kSystemFontSize(12);
        button.y = 20+64+120;
        button.centerX = self.view.centerX+self.view.centerX/2;
        button.borderWidth = 1.5;
        button.borderColor = UIColor.orangeColor;
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
