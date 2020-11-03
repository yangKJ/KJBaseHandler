//
//  KJWebDiscernTool.m
//  KJWebDiscernDemo
//
//  Created by 杨科军 on 2019/10/11.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJWebDiscernTool.h"

@interface KJWebDiscernTool ()<UIGestureRecognizerDelegate,WKNavigationDelegate>
@property(nonatomic,copy,class) KJQRCodeImageBlock xxblock; /// 类属性block
@property(nonatomic,strong) WKWebView *saveWebView;
@property(nonatomic,strong) UIImage *currentImage;

@end

@implementation KJWebDiscernTool
static KJQRCodeImageBlock _xxblock = nil;
static KJWebDiscernTool *kj_tool = nil;
+ (KJQRCodeImageBlock)xxblock{
    if (_xxblock == nil) {
        _xxblock = ^void(UIImage *image){ };
    }
    return _xxblock;
}
+ (void)setXxblock:(KJQRCodeImageBlock)xxblock{
    if (xxblock != _xxblock) {
        _xxblock = [xxblock copy];
    }
}

/// 回调获取长按识别的图片
/// WKNavigationDelegate内部实现了该协议，会导致外界的失效
+ (void)kj_initWithWKWebView:(WKWebView*)webView WKNavigationDelegate:(BOOL)delegate QRCodeImageBlock:(KJQRCodeImageBlock)block{
    self.xxblock = block;
    @synchronized (self) {
        if (kj_tool == nil) {
            kj_tool = [[KJWebDiscernTool alloc]init];
        }
    }
    [kj_tool kj_configWithWKWebView:webView WKNavigationDelegate:delegate];
}

- (void)kj_configWithWKWebView:(WKWebView*)webView WKNavigationDelegate:(BOOL)delegate{
    self.saveWebView = webView;
    if (delegate) self.saveWebView.navigationDelegate = self;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1;
    longPress.delegate = self;
    [webView addGestureRecognizer:longPress];
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) return;
    CGPoint touchPoint = [sender locationInView:self.saveWebView];
    __weak typeof(self) weakself = self;
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src", touchPoint.x, touchPoint.y];
    [self.saveWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        if (imgUrl) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            weakself.currentImage = [UIImage imageWithData:data];
        }
        _xxblock(weakself.currentImage);
    }];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /// 禁止弹出菜单
    [self.saveWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout = 'none';" completionHandler:nil];
    /// 禁止选中 - 禁止用户复制粘贴
    [self.saveWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect = 'none';" completionHandler:nil];
}

@end
