//
//  KJVideoEncodeTool.h
//  KJRecordVideoDemo
//
//  Created by 杨科军 on 2020/10/12.
//  https://github.com/yangKJ/KJBaseHandler
//  视频格式转换工具

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger, KJExportPresetQualityType) {
    KJExportPresetQualityTypeLowQuality = 0, //低质量 可以通过移动网络分享
    KJExportPresetQualityTypeMediumQuality,  //中等质量 可以通过WIFI网络分享
    KJExportPresetQualityTypeHighestQuality, //高等质量
    KJExportPresetQualityType640x480,
    KJExportPresetQualityType960x540,
    KJExportPresetQualityType1280x720,
    KJExportPresetQualityType1920x1080,
    KJExportPresetQualityType3840x2160,
};
typedef NS_ENUM(NSInteger, KJVideoFileType) {
    KJVideoFileTypeMov = 0, /// .mov
    KJVideoFileTypeMp4, /// .mp4
    KJVideoFileTypeWav,
    KJVideoFileTypeM4v,
    KJVideoFileTypeM4a,
    KJVideoFileTypeCaf,
    KJVideoFileTypeAif,
    KJVideoFileTypeMp3,
};
static NSString * const _Nonnull KJVideoFileTypeStringMap[] = {
    [KJVideoFileTypeMov] = @".mov",
    [KJVideoFileTypeMp4] = @".mp4",
    [KJVideoFileTypeWav] = @".wav",
    [KJVideoFileTypeM4v] = @".m4v",
    [KJVideoFileTypeM4a] = @".m4a",
    [KJVideoFileTypeCaf] = @".caf",
    [KJVideoFileTypeAif] = @".aif",
    [KJVideoFileTypeMp3] = @".mp3",
};
typedef void(^kVideoEncodeBlock)(NSURL * _Nullable mp4URL, NSError * _Nullable error);
NS_ASSUME_NONNULL_BEGIN
@interface KJVideoEncodeInfo : NSObject
@property(nonatomic,strong)NSString *videoName;
@property(nonatomic,strong)NSString *videoPath;
@property(nonatomic,assign)KJExportPresetQualityType qualityType;
@property(nonatomic,assign)KJVideoFileType videoType; /// 视频转换格式，默认.mp4
/// URL、PHAsset、AVURLAsset互斥三者选其一
@property(nonatomic,strong)PHAsset *PHAsset;
@property(nonatomic,strong)NSURL *URL;
@property(nonatomic,strong)AVURLAsset *AVURLAsset;
/// 获取导出质量
+ (NSString * const)getAVAssetExportPresetQuality:(KJExportPresetQualityType)qualityType;
/// 获取导出格式
+ (NSString * const)getVideoFileType:(KJVideoFileType)videoType;
@end
@interface KJVideoEncodeTool : NSObject
/// 视频格式转换处理
+ (void)kj_videoConvertEncodeInfo:(KJVideoEncodeInfo*(^)(KJVideoEncodeInfo*info))infoblock Block:(kVideoEncodeBlock)block;
@end

NS_ASSUME_NONNULL_END
