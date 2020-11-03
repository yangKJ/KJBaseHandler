//
//  NSURL+KJRouter.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/20.
//  https://github.com/yangKJ/KJBaseHandler

#import "NSURL+KJRouter.h"

@implementation NSURL (KJRouter)
/// 解析获取参数
- (NSDictionary*)kj_analysisParameterGetQuery{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    [URLComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

//NSURL *URL = [NSURL URLWithString:@"https://www.test.com/test?className=KJVideoEncodeVC&title=title"];
//URL.query              // className=KJVideoEncodeVC&title=title
//URL.scheme             // https
//URL.host               // www.test.com
//URL.path               // /test
//URL.absoluteString     // https://www.test.com/test?className=KJVideoEncodeVC&title=title

@end
