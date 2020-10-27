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
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"拍摄视频" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.greenColor forState:(UIControlStateNormal)];
    button.titleLabel.font = kSystemFontSize(14);
    button.frame = CGRectMake(0, 0, 100, 30);
    [self.view addSubview:button];
    button.center = self.view.center;
    button.centerY -= 30;
    button.borderColor = UIColor.greenColor;
    button.borderWidth = 1;
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
    
    UIButton *button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button2 setTitle:@"转换视频" forState:(UIControlStateNormal)];
    [button2 setTitleColor:UIColor.greenColor forState:(UIControlStateNormal)];
    button2.titleLabel.font = kSystemFontSize(14);
    button2.frame = CGRectMake(0, 0, 100, 30);
    [self.view addSubview:button2];
    button2.center = self.view.center;
    button2.centerY += 30;
    button2.borderColor = UIColor.greenColor;
    button2.borderWidth = 1;
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
        [KJVideoEncodeTool kj_videoConvertEncodeInfo:^KJVideoEncodeInfo * _Nonnull(KJVideoEncodeInfo * _Nonnull info) {
            info.URL = URL;
            info.videoName = timeStr;
            info.videoPath = path;
            return info;
        } Block:^(NSURL * _Nullable mp4URL, NSError * _Nullable error) {
            NSLog(@"--%@",mp4URL);
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
