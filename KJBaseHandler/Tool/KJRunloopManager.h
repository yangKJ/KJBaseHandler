//
//  KJRunloopManager.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/9/25.
//  Copyright © 2020 杨科军. All rights reserved.
//  Runloop工具 - 解决UI耗时操作

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJRunloopManager : NSObject
/// 单例
+ (instancetype)sharedInstance;
/// Runloop回调
- (void)kj_addRunloopBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
