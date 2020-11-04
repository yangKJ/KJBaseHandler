//
//  KJBaseNavigationController.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/27.
//  https://github.com/yangKJ/KJBaseHandler

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJBaseNavigationController : UINavigationController

/// 返回指定的控制器
- (NSArray*)popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
