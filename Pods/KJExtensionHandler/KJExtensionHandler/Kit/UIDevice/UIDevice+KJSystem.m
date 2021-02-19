//
//  UIDevice+KJSystem.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/10/23.
//  https://github.com/yangKJ/KJExtensionHandler

#import "UIDevice+KJSystem.h"
#import <objc/runtime.h>
#import <stdatomic.h>
@implementation UIDevice (KJSystem)
@dynamic appCurrentVersion,appName;
+ (NSString*)appCurrentVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString*)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
/// 对比版本号
+ (BOOL)kj_comparisonVersion:(NSString*)version{
    if ([version compare:UIDevice.appCurrentVersion] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}
/// 获取AppStore版本号和详情信息
+ (NSString*)kj_getAppStoreVersionWithAppid:(NSString*)appid Details:(void(^)(NSDictionary*))block{
    __block NSString *appVersion = UIDevice.appCurrentVersion;
    if (appid == nil) return appVersion;
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary * dict = [json[@"results"] firstObject];
            appVersion = dict[@"version"];
            if (block) block(dict);
            dispatch_semaphore_signal(semaphore);
        }] resume];
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return appVersion;
}
/// 跳转到指定URL
+ (void)kj_openURL:(id)URL{
    if (URL == nil) return;
    if (![URL isKindOfClass:[NSURL class]]) {
        URL = [NSURL URLWithString:URL];
    }
    if ([[UIApplication sharedApplication] canOpenURL:URL]){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:URL];
#pragma clang diagnostic pop
        }
    }else{
        NSLog(@"can not go！！！！！");
    }
}
/// 调用AppStore
+ (void)kj_skipToAppStoreWithAppid:(NSString*)appid{
    NSString *urlString = [@"http://itunes.apple.com/" stringByAppendingFormat:@"%@?id=%@",self.appName,appid];
    [self kj_openURL:urlString];
}
/// 调用自带浏览器safari
+ (void)kj_skipToSafari{
    [self kj_openURL:@"http://www.abt.com"];
}
/// 调用自带Mail
+ (void)kj_skipToMail{
    [self kj_openURL:@"mailto://admin@abt.com"];
}

/// 保存到相册
static char kSavePhotosKey;
+ (void)kj_savedPhotosAlbumWithImage:(UIImage*)image Complete:(void(^)(BOOL success))complete{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    objc_setAssociatedObject(self, &kSavePhotosKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    void(^block)(BOOL success) = objc_getAssociatedObject(self, &kSavePhotosKey);
    if (block) block(error==nil?YES:NO);
}
/// 系统自带分享
+ (UIActivityViewController*)kj_shareActivityWithItems:(NSArray*)items ViewController:(UIViewController*)vc Complete:(void(^)(BOOL success))complete{
    if (items.count == 0) return nil;
    UIActivityViewController *__vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        __vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    }else if (@available(iOS 9.0, *)) {
        __vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    }else{
        __vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (complete) complete(completed);
    };
    __vc.completionWithItemsHandler = itemsBlock;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        __vc.popoverPresentationController.sourceView = vc.view;
        __vc.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
    }
    [vc presentViewController:__vc animated:YES completion:nil];
    return __vc;
}
/// 切换根视图控制器
+ (void)kj_changeRootViewController:(UIViewController*)vc Complete:(void(^)(BOOL success))complete{
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        [UIView setAnimationsEnabled:oldState];
    }completion:^(BOOL finished) {
        if (complete) complete(finished);
    }];
}

@end
