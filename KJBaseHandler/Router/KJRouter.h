//
//  KJRouter.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/20.
//  https://github.com/yangKJ/KJBaseHandler
//  路由 - 基于URL实现控制器转场的框架

#import <Foundation/Foundation.h>
#import "NSURL+KJRouter.h"
NS_ASSUME_NONNULL_BEGIN
typedef UIViewController * _Nonnull (^kRouterBlock)(NSURL *URL, UIViewController *sourcevc);
@interface KJRouter : NSObject
/// 注册路由URL
+ (void)kj_routerRegisterWithURL:(NSURL*)URL Block:(kRouterBlock)block;
/// 移除路由URL
+ (void)kj_routerRemoveWithURL:(NSURL*)URL;
/// 执行跳转处理
+ (void)kj_routerTransferWithURL:(NSURL*)URL SourceViewController:(UIViewController*)vc;
+ (void)kj_routerTransferWithURL:(NSURL*)URL SourceViewController:(UIViewController*)vc Completion:(void(^_Nullable)(UIViewController *govc))block;

@end

NS_ASSUME_NONNULL_END
