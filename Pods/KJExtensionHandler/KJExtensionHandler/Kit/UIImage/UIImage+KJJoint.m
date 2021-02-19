//
//  UIImage+KJJoint.m
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/11/4.
//

#import "UIImage+KJJoint.h"

@implementation UIImage (KJJoint)
/// 旋转图片和镜像处理
- (UIImage*)kj_rotationImageWithOrientation:(UIImageOrientation)orientation{
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    CGRect bounds = rect;
    CGRect (^kSwapWidthAndHeight)(CGRect) = ^CGRect(CGRect rect) {
        CGFloat swap = rect.size.width;
        rect.size.width  = rect.size.height;
        rect.size.height = swap;
        return rect;
    };
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(rect.size.width,rect.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeft:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeftMirrored:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height,rect.size.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            bounds = kSwapWidthAndHeight(bounds);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (orientation){
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -rect.size.height, 0.0);
        break;
        default:
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0.0, -rect.size.height);
        break;
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// 随意张拼接图片
- (UIImage*)kj_moreJointVerticalImage:(UIImage*)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat w = size.width;
    size.height += w*jointImage.size.height/jointImage.size.width;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.height += w*tempImage.size.height/tempImage.size.width;
        [temps addObject:tempImage];
    }
    va_end(args);
    UIGraphicsBeginImageContext(size);
    CGFloat y = 0;
    for (UIImage *img in temps) {
        CGFloat h = w*img.size.height/img.size.width;
        [img drawInRect:CGRectMake(0, y, w, h)];
        y += h;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
/// 水平方向拼接随意张图片
- (UIImage*)kj_moreJointLevelImage:(UIImage*)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat h = size.height;
    size.width += h*jointImage.size.width/jointImage.size.height;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.width += h*tempImage.size.width/tempImage.size.height;
        [temps addObject:tempImage];
    }
    va_end(args);
    UIGraphicsBeginImageContext(size);
    CGFloat x = 0;
    for (UIImage *img in temps) {
        CGFloat w = h*img.size.width/img.size.height;
        [img drawInRect:CGRectMake(x, 0, w, h)];
        x += w;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
/// 图片多次合成处理
- (UIImage*)kj_imageCompoundWithLoopNums:(NSInteger)loopNums Orientation:(UIImageOrientation)orientation{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGFloat X = 0,Y = 0;
    switch (orientation) {
        case UIImageOrientationUp:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width / loopNums;
                CGFloat H = self.size.height;
                X = W * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        case UIImageOrientationLeft:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width;
                CGFloat H = self.size.height / loopNums;
                Y = H * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        case UIImageOrientationRight:
            for (int i = 0; i < loopNums; i++) {
                CGFloat W = self.size.width;
                CGFloat H = self.size.height / loopNums;
                Y = H * i;
                [self drawInRect:CGRectMake(X, Y, W, H)];
            }
            break;
        default:
            break;
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
#pragma mark - Accelerate
/// 水平方向拼接随意张图片，固定主图的高度
- (UIImage*)kj_moreAccelerateJointLevelImage:(UIImage*)jointImage,...{
    NSMutableArray<UIImage*>* temps = [NSMutableArray arrayWithObjects:self,jointImage,nil];
    CGSize size = self.size;
    CGFloat h = size.height;
    size.width += h*jointImage.size.width/jointImage.size.height;
    
    va_list args;UIImage *tempImage;
    va_start(args, jointImage);
    while ((tempImage = va_arg(args, UIImage*))) {
        size.width += h*tempImage.size.width/tempImage.size.height;
        [temps addObject:tempImage];
    }
    va_end(args);
    
    const size_t width = size.width, height = size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGFloat x = 0;
    for (UIImage *img in temps) {
        CGFloat w = h*img.size.width/img.size.height;
        CGContextDrawImage(bmContext, CGRectMake(x, 0, w, h), img.CGImage);
        x += w;
    }
    UInt8 * data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){
        CGContextRelease(bmContext);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(bmContext);
    return newImage;
}
/// 图片拼接艺术
- (UIImage*)kj_jointImageWithJointType:(KJJointImageType)type Size:(CGSize)size Maxw:(CGFloat)maxw{
    __block CGFloat scale = [UIScreen mainScreen].scale;
    const size_t width = size.width * scale, height = size.height * scale;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    __block CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, bitmapInfo);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGFloat maxh = (maxw*self.size.height)/self.size.width;
    int row = (int)ceilf(size.width/maxw);
    int col = (int)ceilf(size.height/maxh);
    UIImage *tempImage = nil;
    if (type == 3) {
        tempImage = [self kj_rotationImageWithOrientation:UIImageOrientationUpMirrored];
    }else if (type == 4) {
        tempImage = [self kj_rotationImageWithOrientation:UIImageOrientationDownMirrored];
    }
    __block CGFloat x = 0,y = 0;
    void (^kDrawImage)(UIImage*) = ^(UIImage *image) {
        CGContextDrawImage(bmContext, CGRectMake(x, y, maxw*scale+1, maxh*scale+1), image.CGImage);
    };
    for (int i = 0; i < row; i++) {
        for (int k = 0; k < col; k++) {
            x = maxw * i * scale;y = maxh * k * scale;
            if (type == 0) {
                kDrawImage(self);
            }else if (type == 1) {
                if (i&1) {
                    y += maxh*scale/2;
                    if (k+1 == col) kDrawImage(self);
                    y -= maxh*scale;
                }
                kDrawImage(self);
            }else if (type == 2) {
                if (!(i&1)) {
                    y += maxh*scale/2;
                    if (k+1 == col) kDrawImage(self);
                    y -= maxh*scale;
                }
                kDrawImage(self);
            }else if (type == 3) {
                kDrawImage(i&1 ? tempImage : self);
            }else if (type == 4) {
                kDrawImage(k%2 ? tempImage : self);
            }
        }
    }
    UInt8 * data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){
        CGContextRelease(bmContext);
        return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(bmContext);
    return newImage;
}

/// 进阶版图片拼接艺术
- (UIImage*)kj_jointImageWithAdvanceJointType:(KJAdvanceJointImageType)type Size:(CGSize)size Maxw:(CGFloat)maxw Parameter:(KJAdvanceJointImageParameter)parameter{
    return self;
}

@end
