//
//  NSURL+KJRouter.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/20.
//  https://github.com/yangKJ/KJBaseHandler
//  解析参数

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (KJRouter)
/// 解析获取参数
- (NSDictionary*)kj_analysisParameterGetQuery;
@end

NS_ASSUME_NONNULL_END
