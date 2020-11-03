//
//  KJDownloadTool.m
//  KJPhotoBrowserDemo
//
//  Created by 杨科军 on 2019/11/22.
//  Copyright © 2019 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJDownloadTool.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

/// 网络下载相关
@interface KJDownloader : NSObject<NSURLSessionDownloadDelegate>//,NSURLConnectionDataDelegate>
//@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDownloadTask *task;
@property (nonatomic,assign) unsigned long long totalLength;
@property (nonatomic,assign) unsigned long long currentLength;
@property (nonatomic,copy,readwrite) KJLoadProgressBlock progressBlock;
@property (nonatomic,copy,readwrite) KJLoadDataBlock  dataBlock;
/// 下载数据
- (void)kj_startDownloadImageWithURL:(NSURL*)url Progress:(KJLoadProgressBlock)progress Complete:(KJLoadDataBlock)complete;

@end

NS_ASSUME_NONNULL_END

@implementation KJDownloader

- (void)kj_startDownloadImageWithURL:(NSURL*)url Progress:(KJLoadProgressBlock)progress Complete:(KJLoadDataBlock)complete{
    if (url == nil) {
        if (complete) {
            NSError *error = [NSError errorWithDomain:@"Domain" code:101 userInfo:@{@"message":@"URL不正确"}];
            complete(nil,error);
        }
        return;
    }
    self.progressBlock = progress;
    self.dataBlock = complete;
//    self.url = url;
    self.currentLength = self.totalLength = 0;
    /// 开启下载请求
    [self kj_downloadImageWithURL:url];
}
- (void)kj_downloadImageWithURL:(NSURL*)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
//    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    request.allHTTPHeaderFields = @{@"Accept" : @"image/webp,image/*;q=0.8"};
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    [task resume];
    self.task = task;
}
//- (void)getUrlFileLength:(NSString *)url ResultBlock:(KJFileLength)block{
//    _block = block;
//    NSMutableURLRequest *mURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [mURLRequest setHTTPMethod:@"HEAD"];
//    mURLRequest.timeoutInterval = 5.0;
//    NSURLConnection *URLConnection = [NSURLConnection connectionWithRequest:mURLRequest delegate:self];
//    [URLConnection start];
//}
//
//#pragma mark - NSURLConnectionDelegate
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
//    NSNumber *length = [dict objectForKey:@"Content-Length"];
//    [connection cancel];
//    if (_block) {
//        _block([length longLongValue]);    // length单位是byte，除以1000后是KB（文件的大小计算好像都是1000，而不是1024），
//    }
//}
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"获取文件大小失败：%@",error);
//    if (_block) {
//        _block(0);
//    }
//    [connection cancel];
//}

#pragma mark - NSURLSessionDownloadDelegate
/// 下载成功
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (self.dataBlock) {
        self.dataBlock(data, nil);
        _dataBlock = nil;// 防止重复调用
    }
}
/// 下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    /// totalBytesExpectedToWrite为-1表示服务器未返回文件大小
    if (totalBytesExpectedToWrite != -1) {
        self.totalLength = totalBytesExpectedToWrite;
    }
    self.currentLength = totalBytesWritten;
    !self.progressBlock?:self.progressBlock(self.totalLength, self.currentLength);
}
/// 下载失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        if (self.dataBlock) self.dataBlock(nil, error);
        _dataBlock = nil;
    }
}

@end

@interface KJDownloadTool ()
@property (nonatomic,strong) NSMutableDictionary *faileDict; /// 失败数据临时缓存
@property (nonatomic,copy,class) KJLoadImageBlock xxblock;
@end

@implementation KJDownloadTool
static KJDownloadTool *_tool = nil;
static KJLoadImageBlock _xxblock = nil;
static KJLoadProgressBlock _xxxblock = nil;
+ (KJLoadImageBlock)xxblock{
    if (_xxblock == nil) {
        _xxblock = ^void(UIImage*image){ };
    }
    return _xxblock;
}
+ (void)setXxblock:(KJLoadImageBlock)xxblock{
    if (xxblock != _xxblock) {
        _xxblock = [xxblock copy];
    }
}
+ (KJLoadProgressBlock)progressblock{
    if (_xxxblock == nil) {
        _xxxblock = ^void(unsigned long long totalLength,unsigned long long currentLength){ };
    }
    return _xxxblock;
}
+ (void)setProgressblock:(KJLoadProgressBlock)xxxblock{
    if (xxxblock != _xxxblock) {
        _xxxblock = [xxxblock copy];
    }
}
/// 下载数据
+ (NSData*)kj_downloadDataWithURL:(NSString*)url{
    @synchronized (self) {
        if (_tool == nil) {
            _tool = [[self alloc]init];
        }
    }
    NSData *data = [_tool xxxWithURL:[NSURL URLWithString:url]];
    return data;
}
/// 递归拿到Data
- (NSData*)xxxWithURL:(NSURL*)url{
    if ([self kj_failNumsForRequest:[NSURLRequest requestWithURL:url]] >= kMaxLoadNum) {
//        [self kj_cancelRequest];
        return nil;
    }
    NSData *data = [self kj_getDataWithURL:url];
    return data?:[self xxxWithURL:url];
}
/// Block 同步执行
- (NSData*)kj_getDataWithURL:(NSURL*)url{
//    __weak typeof(self) weakself = self;
    __block NSData *__data = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
//        [weakself kj_cancelRequest];
        KJDownloader *downloader = [[KJDownloader alloc] init];
//        weakself.downloader = downloader;
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
        [downloader kj_startDownloadImageWithURL:theRequest.URL Progress:^(unsigned long long totalLength,unsigned long long currentLength) {
            !KJDownloadTool.progressblock?:KJDownloadTool.progressblock(totalLength,currentLength);
        } Complete:^(NSData *data, NSError *error) {
            if (error) [self kj_cacheFailRequest:theRequest];
            __data = data;
            dispatch_semaphore_signal(sem);
        }];
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return __data;
}

#pragma mark - 下载图片相关
+ (void)kj_loadImageWithURL:(NSString*)url Complete:(KJLoadImageBlock)block{
    @synchronized (self) {
        if (_tool == nil) {
            _tool = [[KJDownloadTool alloc]init];
        }
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    /// 开启子线程异步下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [_tool kj_getImageWithRequest:request HaveProgress:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(image);
        });
    });
}

//+ (void)kj_loadImageWithURL:(NSString*)url LoadProgress:(KJLoadProgressBlock)progess Complete:(KJLoadImageBlock)block{
//    @synchronized (self) {
//        if (_tool == nil) {
//            _tool = [[KJLoadImageTool alloc]init];
//        }
//    }
//    self.xxblock = block;
//    if (progess) self.progressblock = progess;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [_tool kj_downloadWithReqeust:request HaveProgress:progess?YES:NO];
//}
#pragma mark - 内部方法
- (UIImage*)kj_getImageWithRequest:(NSURLRequest*)request HaveProgress:(BOOL)haveProgress{
    UIImage *cachedImage = getCacheImage(request);
    if (cachedImage) return cachedImage;
    if ([self kj_failNumsForRequest:request] >= kMaxLoadNum) {
        return nil;
    }
    __weak typeof(self) weakself = self;
    __block NSData *__data = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_group_async(dispatch_group_create(), queue, ^{
        KJDownloader *downloader = [[KJDownloader alloc] init];
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:request.URL];
        [downloader kj_startDownloadImageWithURL:theRequest.URL Progress:^(unsigned long long totalLength,unsigned long long currentLength) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (haveProgress) _xxxblock(totalLength,currentLength);
//            });
        } Complete:^(NSData *data, NSError *error) {
            if (error) [weakself kj_cacheFailRequest:theRequest];
            __data = data;
            dispatch_semaphore_signal(sem);
        }];
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    UIImage *image = [UIImage imageWithData:__data];
    if (image) {
        cacheImage(image,request);
    } else {
        return [weakself kj_getImageWithRequest:request HaveProgress:haveProgress];
    }
    return image;
}

///// 下载图片
//- (void)kj_downloadWithReqeust:(NSURLRequest*)request HaveProgress:(BOOL)haveProgress{
//    UIImage *cachedImage = getCacheImage(request);
//    if (cachedImage) {
//        _xxblock(cachedImage);
//        return;
//    }
//    /// 判断失败次数
//    if ([self kj_failNumsForRequest:request] >= kMaxLoadNum) {
//        return;
//    }
//    [self kj_cancelRequest];
//    if (_downloader == nil) {
//        self.downloader = [[KJDownloader alloc] init];
//    }
//    [_downloader kj_startDownloadImageWithURL:request.URL.absoluteString Progress:^(unsigned long long totalLength,unsigned long long currentLength) {
//        if (haveProgress) _xxxblock(totalLength,currentLength);
//    } Complete:^(NSData *data, NSError *error) {
//        if (data != nil && error == nil) {
//            UIImage *image = [UIImage imageWithData:data];
//            if (image) {
//                cacheImage(image,request);
//            } else {
//                [self kj_cacheFailRequest:request];
//            }
//            _xxblock(image);
//        } else { // error
//            [self kj_cacheFailRequest:request];
//            _xxblock(nil);
//        }
//    }];
//}
///// 取消网络请求
//- (void)kj_cancelRequest {
//    [self.downloader.task cancel];
//    _downloader = nil;
//}

/// 缓存相关，实现原理：将下载好的数据通过将链接地址MD5的方式加密放在沙盒
#pragma mark - 缓存相关方法
/// 获取缓存数据大小
+ (unsigned long long)kj_imagesCacheSize {
    NSString *directoryPath = KJLoadImages;
    BOOL isDir = NO;
    unsigned long long total = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
                    if (!error) total += [dict[NSFileSize] longLongValue];
                }
            }
        }
    }
    return total;
}
/// 清除缓存
+ (void)kj_clearImagesCache {
    @synchronized (self) {
        if (_tool == nil) {
            _tool = [[KJDownloadTool alloc]init];
        }
    }
    [_tool clearDiskCaches];
}
- (void)clearDiskCaches {
    NSString *directoryPath = KJLoadImages;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }
    [self.faileDict removeAllObjects];
    _faileDict = nil;
}
- (NSMutableDictionary*)faileDict {
    if (_faileDict == nil) {
        _faileDict = [NSMutableDictionary dictionary];
    }
    return _faileDict;
}
/// 失败次数
- (NSUInteger)kj_failNumsForRequest:(NSURLRequest*)request {
    NSNumber *failes = [self.faileDict objectForKey:md5KeyForRequest(request)];
    return (failes && [failes respondsToSelector:@selector(integerValue)]) ? failes.integerValue : 0;
}
/// 缓存失败
- (void)kj_cacheFailRequest:(NSURLRequest*)request {
    NSString *key = md5KeyForRequest(request);
    NSNumber *failes = [self.faileDict objectForKey:key];
    NSUInteger nums = 0;
    if (failes && [failes respondsToSelector:@selector(integerValue)]) {
        nums = [failes integerValue];
    }
    nums++;
    [self.faileDict setObject:@(nums) forKey:key];
}
/// 获取缓存图片
static inline UIImage * getCacheImage(NSURLRequest*request){
    NSString *directoryPath = KJLoadImages;
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,md5KeyForRequest(request)];
    return [UIImage imageWithContentsOfFile:path];
}
/// 存储图片
static inline bool cacheImage(UIImage *image,NSURLRequest *request){
    if (image == nil || request == nil) return false;
    NSString *directoryPath = KJLoadImages;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) return false;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath,md5KeyForRequest(request)];
    NSData   *data = UIImagePNGRepresentation(image);
    bool boo = false;
    if (data) {/// 缓存数据
        boo = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
    return boo;
}
/// 生成MD5文件名
static inline NSString * md5KeyForRequest(NSURLRequest *request){
    BOOL portait = NO;
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        portait = YES;
    }
    NSString *string = [NSString stringWithFormat:@"%@%@", request.URL.absoluteString, portait ? @"portait" : @"lanscape"];
    /// md5加密
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

@end
