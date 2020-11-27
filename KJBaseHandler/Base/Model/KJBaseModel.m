//
//  KJBaseModel.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/19.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJBaseModel.h"
#import <objc/runtime.h>
@implementation KJBaseModel
- (NSString*)description{
    return [NSString stringWithFormat:@"%@",[self kj_getDictionary:self]];
}
- (void)setValue:(id)value forUndefinedKey:(NSString*)key{ }
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone*)zone{
    return nil;
}
#pragma mark - NSCoding
/// 归档
- (void)encodeWithCoder:(NSCoder*)aCoder{
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        NSString * key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}
/// 解档
- (id)initWithCoder:(NSCoder*)aDecoder{
    if (self == [super init]){
        unsigned int count;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++){
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString * key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

#pragma mark - public method
+ (instancetype)kj_modelWithDictionary:(NSDictionary*)dict{
    id obj = [[self alloc] init];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    /// 关键字排除
    if ([[tempDict allKeys] containsObject:@"id"]){
        [obj setKid:tempDict[@"id"] ?: @""];
        [tempDict removeObjectForKey:@"id"];
    }else if ([[tempDict allKeys] containsObject:@"description"]){
        [obj setKdescription:tempDict[@"description"] ?: @""];
        [tempDict removeObjectForKey:@"description"];
    }
    [obj setValuesForKeysWithDictionary:tempDict.mutableCopy];
    return obj;
}
#pragma mark - privately method
/// 转换成相对应的属性
- (id)kj_transformObject:(id)obj{
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]){
        return obj;
    }else if ([obj isKindOfClass:[NSArray class]]){
        NSArray *temps = obj;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:temps.count];
        for(int i = 0;i < temps.count; i++){
            [array setObject:[self kj_transformObject:[temps objectAtIndex:i]] atIndexedSubscript:i];
        }
        return array;
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self kj_transformObject:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self kj_getDictionary:obj];
}
/// 将对象转为NSDictionary
- (NSDictionary*)kj_getDictionary:(id)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if (value == nil){
            value = [NSNull null];
        }else{
            value = [self kj_transformObject:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

@end
