//
//  UIImage+KJJoint.h
//  KJExtensionHandler
//
//  Created by 杨科军 on 2020/11/4.
//  https://github.com/yangKJ/KJExtensionHandler
//  图片拼接相关处理

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Accelerate/Accelerate.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KJJointImageType) {
    KJJointImageTypeCustom = 0,/// 正常平铺
    KJJointImageTypePositively,/// 正斜对花
    KJJointImageTypeBackslash,/// 反斜对花
    KJJointImageTypeAcross,/// 横对花
    KJJointImageTypeVertical,/// 竖对花
};
/// 进阶版图片拼接类型
typedef NS_ENUM(NSInteger, KJAdvanceJointImageType) {
    KJAdvanceJointImageTypeCustom = 0,/// 艺术平铺
    KJAdvanceJointImageTypeDouble,/// 两拼法
    KJAdvanceJointImageTypeThree,/// 三拼法
    KJAdvanceJointImageTypeLengthMix,/// 长短混合
    KJAdvanceJointImageTypeClassical,/// 古典拼法
    KJAdvanceJointImageTypeConcaveConvex,/// 凹凸效果
    KJAdvanceJointImageTypeConcaveConvexMismatch,/// 凹凸错位效果
    KJAdvanceJointImageTypeLongShortThird,/// 长短三分之一效果
    KJAdvanceJointImageTypeLadder,/// 阶梯拼法
    KJAdvanceJointImageTypeDoubleAndOne,/// 两长一短拼接
};
@interface UIImage (KJJoint)
/// 旋转图片和镜像处理
- (UIImage*)kj_rotationImageWithOrientation:(UIImageOrientation)orientation;

#pragma mark - UIKit
/// 竖直方向拼接随意张图片，固定主图的宽度
- (UIImage*)kj_moreJointVerticalImage:(UIImage*)jointImage,...;
/// 水平方向拼接随意张图片，固定主图的高度
- (UIImage*)kj_moreJointLevelImage:(UIImage*)jointImage,...;
/// 图片多次合成处理
- (UIImage*)kj_imageCompoundWithLoopNums:(NSInteger)loopTimes Orientation:(UIImageOrientation)orientation;

#pragma mark - Accelerate
/// 水平方向拼接随意张图片，固定主图的高度
- (UIImage*)kj_moreAccelerateJointLevelImage:(UIImage*)jointImage,...;
/// 图片拼接艺术
- (UIImage*)kj_jointImageWithJointType:(KJJointImageType)type Size:(CGSize)size Maxw:(CGFloat)maxw;

/// 倒角
struct KJChamfer {
    bool openAcross;/// 横倒角，默认no
    bool openVertical;/// 竖倒角，默认no
    float lineWidth;/// 线条宽度，默认1px
    UIColor *lineColor;/// 线条颜色，默认黑色
};
/// 图片切割刀数，默认横两刀，竖零刀
struct KJKnife {int acrossKnife;int verticalKnife;};
typedef struct KJAdvanceJointImageParameter {;
    struct KJChamfer chamfer;
    struct KJKnife knife;
}KJAdvanceJointImageParameter;
/// 进阶版图片拼接艺术，待完善
- (UIImage*)kj_jointImageWithAdvanceJointType:(KJAdvanceJointImageType)type Size:(CGSize)size Maxw:(CGFloat)maxw Parameter:(KJAdvanceJointImageParameter)parameter;

@end

NS_ASSUME_NONNULL_END
