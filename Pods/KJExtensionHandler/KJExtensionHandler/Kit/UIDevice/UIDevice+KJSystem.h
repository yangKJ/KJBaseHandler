//
//  UIDevice+KJSystem.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/23.
//  https://github.com/yangKJ/KJExtensionHandler
//  系统相关的操作

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIDevice (KJSystem)
/// App版本号
@property(nonatomic,strong,class)NSString *appCurrentVersion;
/// App名称
@property(nonatomic,strong,class)NSString *appName;

/// 对比版本号
+ (BOOL)kj_comparisonVersion:(NSString*)version;
/// 获取AppStore版本号和详情信息
+ (NSString*)kj_getAppStoreVersionWithAppid:(NSString*)appid Details:(void(^)(NSDictionary *dic))block;

/// 跳转到指定URL
+ (void)kj_openURL:(id)URL;
/// 调用AppStore
+ (void)kj_skipToAppStoreWithAppid:(NSString*)appid;
/// 调用自带浏览器safari
+ (void)kj_skipToSafari;
/// 调用自带Mail
+ (void)kj_skipToMail;

/// 保存到相册
+ (void)kj_savedPhotosAlbumWithImage:(UIImage*)image Complete:(void(^)(BOOL success))complete;
/// 系统自带分享
+ (UIActivityViewController*)kj_shareActivityWithItems:(NSArray*)items ViewController:(UIViewController*)vc Complete:(void(^)(BOOL success))complete;
/// 切换根视图控制器
+ (void)kj_changeRootViewController:(UIViewController*)vc Complete:(void(^)(BOOL success))complete;

@end

NS_ASSUME_NONNULL_END
