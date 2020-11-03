//
//  KJVideoEncodeTool.m
//  KJRecordVideoDemo
//
//  Created by 杨科军 on 2020/10/12.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJVideoEncodeTool.h"
@implementation KJVideoEncodeInfo
- (instancetype)init{
    if (self==[super init]) {
        self.qualityType = KJExportPresetQualityTypeHighestQuality;
        self.videoType = KJVideoFileTypeMp4;
    }
    return self;
}
/// 获取导出质量
+ (NSString * const)getAVAssetExportPresetQuality:(KJExportPresetQualityType)qualityType{
    switch (qualityType) {
        case KJExportPresetQualityTypeLowQuality:return AVAssetExportPresetLowQuality;
        case KJExportPresetQualityTypeMediumQuality:return AVAssetExportPresetMediumQuality;
        case KJExportPresetQualityTypeHighestQuality:return AVAssetExportPresetHighestQuality;
        case KJExportPresetQualityType640x480:return AVAssetExportPreset640x480;
        case KJExportPresetQualityType960x540:return AVAssetExportPreset960x540;
        case KJExportPresetQualityType1280x720:return AVAssetExportPreset1280x720;
        case KJExportPresetQualityType1920x1080:return AVAssetExportPreset1920x1080;
        case KJExportPresetQualityType3840x2160:return AVAssetExportPreset3840x2160;
    }
}
/// 获取导出格式
+ (NSString * const)getVideoFileType:(KJVideoFileType)videoType{
    switch (videoType) {
        case KJVideoFileTypeMov:return AVFileTypeQuickTimeMovie;
        case KJVideoFileTypeMp4:return AVFileTypeMPEG4;
        case KJVideoFileTypeWav:return AVFileTypeWAVE;
        case KJVideoFileTypeM4v:return AVFileTypeAppleM4V;
        case KJVideoFileTypeM4a:return AVFileTypeAppleM4A;
        case KJVideoFileTypeCaf:return AVFileTypeCoreAudioFormat;
        case KJVideoFileTypeAif:return AVFileTypeAIFF;
        case KJVideoFileTypeMp3:return AVFileTypeMPEGLayer3;
    }
}
@end
@implementation KJVideoEncodeTool
+ (void)kj_videoConvertEncodeInfo:(KJVideoEncodeInfo*(^)(KJVideoEncodeInfo*))infoblock Block:(kVideoEncodeBlock)block{
    KJVideoEncodeInfo *info = [KJVideoEncodeInfo new];
    if (infoblock) info = infoblock(info);
    __block NSString *presetName = [KJVideoEncodeInfo getAVAssetExportPresetQuality:info.qualityType];
    __block NSString *videoType  = [KJVideoEncodeInfo getVideoFileType:info.videoType];
    NSString *suffix = KJVideoFileTypeStringMap[info.videoType];
    if (![info.videoName hasSuffix:suffix]) {
        info.videoName = [info.videoName stringByAppendingString:suffix];
    }
    if (info.URL == nil && info.PHAsset == nil && info.AVURLAsset == nil) {
        NSError *error = [self kj_setErrorCode:10008 DescriptionKey:@"The source data is nil"];
        block(nil, error);
    }else if (info.URL) {
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:info.URL options:nil];
        [self convertAVURLAsset:avAsset Name:info.videoName Path:info.videoPath FileType:videoType PresetName:presetName Block:block];
    }else if (info.AVURLAsset) {
        [self convertAVURLAsset:info.AVURLAsset Name:info.videoName Path:info.videoPath FileType:videoType PresetName:presetName Block:block];
    }else if (info.PHAsset) {
        __block NSString *name = info.videoName;
        __block NSString *path = info.videoPath;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = true;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:info.PHAsset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                [self convertAVURLAsset:(AVURLAsset*)asset Name:name Path:path FileType:videoType PresetName:presetName Block:block];
            }else{
                NSError *error = [self kj_setErrorCode:10008 DescriptionKey:@"PHAsset error"];
                block(nil, error);
            }
        }];
    }
}
#pragma mark - MOV转码MP4
+ (void)convertAVURLAsset:(AVURLAsset*)asset Name:(NSString*)name Path:(NSString*)path FileType:(NSString*)fileType PresetName:(NSString*)presetName Block:(kVideoEncodeBlock)block{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:asset.URL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:presetName]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirectory = FALSE;
        BOOL isDirExist  = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if(!(isDirExist && isDirectory)) [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *resultPath = path;
        if (![path hasSuffix:name]) resultPath = [path stringByAppendingFormat:@"/%@",name];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:presetName];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = fileType;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                case AVAssetExportSessionStatusWaiting:
                case AVAssetExportSessionStatusExporting:
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:{
                    NSString *key  = [self kj_getDescriptionKey:exportSession.status];
                    NSError *error = [self kj_setErrorCode:exportSession.status+10001 DescriptionKey:key];
                    block(nil,error);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                    block(exportSession.outputURL,nil);
                    break;
            }
        }];
    }else{
        NSError *error = [self kj_setErrorCode:10007 DescriptionKey:@"AVAssetExportSessionStatusNoPreset"];
        block(nil, error);
    }
}
+ (NSString*)kj_getDescriptionKey:(AVAssetExportSessionStatus)status{
    switch (status) {
        case AVAssetExportSessionStatusUnknown:return @"AVAssetExportSessionStatusUnknown";
        case AVAssetExportSessionStatusWaiting:return @"AVAssetExportSessionStatusWaiting";
        case AVAssetExportSessionStatusExporting:return @"AVAssetExportSessionStatusExporting";
        case AVAssetExportSessionStatusCompleted:return @"AVAssetExportSessionStatusCompleted";
        case AVAssetExportSessionStatusFailed:return @"AVAssetExportSessionStatusFailed";
        case AVAssetExportSessionStatusCancelled:return @"AVAssetExportSessionStatusCancelled";
    }
}
+ (NSError*)kj_setErrorCode:(NSInteger)code DescriptionKey:(NSString*)key{
    return [NSError errorWithDomain:@"ConvertErrorDomain" code:code userInfo:@{NSLocalizedDescriptionKey:key}];
}
+ (NSDictionary*)getVideoInfo:(PHAsset*)asset{
    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: asset] firstObject];
    NSMutableArray *resourceArray = nil;
    if (@available(iOS 13.0, *)) {
        NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@" - " withString:@" "];
        NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@": " withString:@"="];
        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"{" withString:@""];
        NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSString *string5 = [string4 stringByReplacingOccurrencesOfString:@", " withString:@" "];
        resourceArray = [NSMutableArray arrayWithArray:[string5 componentsSeparatedByString:@" "]];
        [resourceArray removeObjectAtIndex:0];
        [resourceArray removeObjectAtIndex:0];
    }else {
        NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@"{" withString:@""];
        NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
        NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@", " withString:@","];
        resourceArray = [NSMutableArray arrayWithArray:[string3 componentsSeparatedByString:@" "]];
        [resourceArray removeObjectAtIndex:0];
        [resourceArray removeObjectAtIndex:0];
    }
    NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc] init];
    for (NSString *string in resourceArray) {
        NSArray *array = [string componentsSeparatedByString:@"="];
        videoInfo[array[0]] = array[1];
    }
    videoInfo[@"duration"] = @(asset.duration).description;
    return videoInfo;
}

@end
