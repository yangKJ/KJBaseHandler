//
//  KJBaseViewController.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/13.
//  https://github.com/yangKJ/KJBaseHandler

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJBaseViewController : UIViewController
/// 创建单例
+ (instancetype)kj_shareInstance;
/// 销毁单例
+ (void)kj_attempDealloc;

@end

NS_ASSUME_NONNULL_END
