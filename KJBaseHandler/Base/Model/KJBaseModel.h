//
//  KJBaseModel.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/19.
//  模型基类，

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJBaseModel : NSObject<NSCoding, NSCopying>
/// 关键字排除
@property(nonatomic,strong)NSString *kid;// 对应id
@property(nonatomic,strong)NSString *kdescription;// 对应description
/// 动态映射 将字典里的数据赋值到模型
+ (instancetype)kj_modelWithDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
