//
//  KJLineView.h
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/11/3.
//  线条控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KJLinePositionType){
    KJLinePositionTypeTop = 0,
    KJLinePositionTypeBottom = 1,
    KJLinePositionTypeLeft = 2,
    KJLinePositionTypeRight = 3
};
IB_DESIGNABLE
@interface KJLineView : UIView
/// 线条颜色，默认灰色
@property(nonatomic,strong) IBInspectable UIColor *lineColor;
/// 线条位置，默认顶部
@property(nonatomic,assign) IBInspectable NSInteger linePosition;

@end

NS_ASSUME_NONNULL_END
