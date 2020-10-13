//
//  KJVideoEncodeVC.m
//  KJBaseHandler
//
//  Created by 杨科军 on 2020/10/13.
//

#import "KJVideoEncodeVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "KJVideoEncodeTool.h"
@interface KJVideoEncodeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation KJVideoEncodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _weakself;
    KJBaseButton *button = [KJBaseButton kj_createButtonWithState:(UIControlStateNormal) ExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
        obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 100, 30)).kBackgroundColor(UIColor.redColor);
    }];
    button.center = self.view.center;
    [button kj_addAction:^(UIButton * _Nonnull kButton) {
        UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
        pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerCon.mediaTypes = @[(NSString*)kUTTypeMovie];//设定相机为视频
        pickerCon.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置相机后摄像头
        pickerCon.videoMaximumDuration = 5;//最长拍摄时间
        pickerCon.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;//拍摄质量
        pickerCon.allowsEditing = NO;//是否可编辑
        pickerCon.delegate = weakself;
        [weakself presentViewController:pickerCon animated:YES completion:nil];
    }];
    
    KJBaseButton *button2 = [KJBaseButton kj_createButtonWithState:(UIControlStateNormal) ExtendParameterBlock:^(KJBaseButton * _Nonnull obj) {
        obj.kAddView(weakself.view).kFrame(CGRectMake(0, 0, 100, 30)).kBackgroundColor(UIColor.redColor);
    }];
    button2.center = self.view.center;
    button2.centerY += 50;
    [button2 kj_addAction:^(UIButton * _Nonnull kButton) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.mediaTypes = @[(NSString*)kUTTypeMovie];
        pickerController.allowsEditing = NO;
        pickerController.delegate = weakself;
        [weakself presentViewController:pickerController animated:YES completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        if (image!=nil) {
            NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            NSLog(@"URL:%@",imageURL);
            NSData * imageData = UIImageJPEGRepresentation(image,0.1);
            NSLog(@"压缩到0.1的图片大小:%lu",[imageData length]);
        }
    }else if([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
        NSLog(@"进入视频环节!!!");
        NSURL *URL = info[UIImagePickerControllerMediaURL];
        NSData *file = [NSData dataWithContentsOfURL:URL];
        NSLog(@"输出视频的大小:%lu",(unsigned long)[file length]);
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoData"];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
        NSString * timeStr = [formatter stringFromDate:NowDate];
        KJVideoEncodeInfo *info = [KJVideoEncodeInfo new];
        info.URL = URL;
        info.videoName = timeStr;
        info.videoPath = path;
        [KJVideoEncodeTool kj_videoConvertEncodeInfo:info Block:^(NSURL * _Nullable mp4URL, NSError * _Nullable error) {
            NSLog(@"--%@",mp4URL);
            //测试使用，保存在手机相册里面
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary writeVideoAtPathToSavedPhotosAlbum:mp4URL completionBlock:^(NSURL *assetURL, NSError *error){
                
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"视频录制取消了...");
}


@end
