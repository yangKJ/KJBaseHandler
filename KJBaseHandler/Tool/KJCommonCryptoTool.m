//
//  KJCommonCryptoTool.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/17.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBaseHandler

#import "KJCommonCryptoTool.h"

@interface KJCommonCryptoTool (){
    SecKeyRef _publicKeyRef;// 公钥引用
    SecKeyRef _privateKeyRef;// 私钥引用
}
@end

@implementation KJCommonCryptoTool
#pragma mark - DES 加密/解密
/// 加密
+ (NSData*)kj_DESEncryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv{
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCEncrypt keyString:keyString iv:iv];
}
+ (NSString*)kj_DESEncryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self kj_DESEncryptData:data keyString:keyString iv:iv];
    return [result base64EncodedStringWithOptions:0];
}
/// 解密
+ (NSData*)kj_DESDecryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv{
    return [self CCCryptData:data algorithm:kCCAlgorithmDES operation:kCCDecrypt keyString:keyString iv:iv];
}
+ (NSString*)kj_DESDecryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self kj_DESDecryptData:data keyString:keyString iv:iv];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark - AES 加密/解密
/// 加密
+ (NSData*)kj_AESEncryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv{
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCEncrypt keyString:keyString iv:iv];
}
+ (NSString*)kj_AESEncryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self kj_AESEncryptData:data keyString:keyString iv:iv];
    return [result base64EncodedStringWithOptions:0];
}
/// 解密
+ (NSData*)kj_AESDecryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv{
    return [self CCCryptData:data algorithm:kCCAlgorithmAES operation:kCCDecrypt keyString:keyString iv:iv];
}
+ (NSString*)kj_AESDecryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *result = [self kj_AESDecryptData:data keyString:keyString iv:iv];
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

#pragma mark - 对称加密&解密核心方法
/// 对称加密&解密核心方法
+ (NSData*)CCCryptData:(NSData*)data algorithm:(CCAlgorithm)algorithm operation:(CCOperation)operation keyString:(NSString*)keyString iv:(NSData*)iv{
    int keySize   = (algorithm == kCCAlgorithmAES) ? kCCKeySizeAES128 : kCCKeySizeDES;
    int blockSize = (algorithm == kCCAlgorithmAES) ? kCCBlockSizeAES128 : kCCBlockSizeDES;
    // 设置密钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keySize];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keySize];
    // 设置 IV 向量
    uint8_t cIv[blockSize];
    bzero(cIv, blockSize);
    int option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    if (iv) {
        [iv getBytes:cIv length:blockSize];
        option = kCCOptionPKCS7Padding;
    }
    // 设置输出缓冲区
    size_t bufferSize = [data length] + blockSize;
    void *buffer = malloc(bufferSize);
    // 加密或解密
    size_t cryptorSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          algorithm,
                                          option,
                                          cKey,
                                          keySize,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &cryptorSize);
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:cryptorSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密或解密失败 | 状态编码: %d", cryptStatus);
    }
    return result;
}

#pragma mark - RSA 加密/解密算法
- (void)kj_loadPublicKeyWithFilePath:(NSString*)filePath; {
    NSAssert(filePath.length != 0, @"公钥路径为空");
    // 删除当前公钥
    if (_publicKeyRef) CFRelease(_publicKeyRef);
    // 从一个 DER 表示的证书创建一个证书对象
    NSData *certificateData = [NSData dataWithContentsOfFile:filePath];
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    NSAssert(certificateRef != NULL, @"公钥文件错误");
    // 返回一个默认 X509 策略的公钥对象，使用之后需要调用 CFRelease 释放
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    // 包含信任管理信息的结构体
    SecTrustRef trustRef;
    // 基于证书和策略创建一个信任管理对象
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"创建信任管理对象失败");
    
    // 信任结果
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    
    // 评估之后返回公钥子证书
    _publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(_publicKeyRef != NULL, @"公钥创建失败");
    if (certificateRef) CFRelease(certificateRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}

- (void)kj_loadPrivateKey:(NSString*)filePath password:(NSString*)password {
    NSAssert(filePath.length != 0, @"私钥路径为空");
    // 删除当前私钥
    if (_privateKeyRef) CFRelease(_privateKeyRef);
    
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:filePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    // 从 PKCS #12 证书中提取标示和证书
    SecIdentityRef myIdentity = NULL;
    SecTrustRef myTrust = NULL;
    const void *keys[] = {kSecImportExportPassphrase};
    const void *values[] = {passwordRef};
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    // 返回 PKCS #12 格式数据中的标示和证书
    OSStatus status = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    if (status == noErr) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        myIdentity = (SecIdentityRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        myTrust = (SecTrustRef)CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
    }
    if (optionsDictionary) CFRelease(optionsDictionary);
    NSAssert(status == noErr, @"提取身份和信任失败");
    SecTrustResultType trustResult;
    // 评估指定证书和策略的信任管理是否有效
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"信任评估失败");
    // 提取私钥
    status = SecIdentityCopyPrivateKey(myIdentity, &_privateKeyRef);
    NSAssert(status == errSecSuccess, @"私钥创建失败");
    CFRelease(items);
}

- (NSString*)kj_RSAEncryptString:(NSString*)string {
    NSData *cipher = [self kj_RSAEncryptData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return [cipher base64EncodedStringWithOptions:0];
}

- (NSData*)kj_RSAEncryptData:(NSData*)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    NSAssert(data, @"明文数据为空");
    NSAssert(_publicKeyRef, @"公钥为空");
    NSData *cipher = nil;
    uint8_t *cipherBuffer = NULL;
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(_publicKeyRef);
    keyBufferSize = data.length;
    if (kSecPaddingPKCS1 == kSecPaddingNone) {
        NSAssert(keyBufferSize <= cipherBufferSize, @"加密内容太大");
    } else {
        NSAssert(keyBufferSize <= (cipherBufferSize - 11), @"加密内容太大");
    }
    // 分配缓冲区
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0x0, cipherBufferSize);
    // 使用公钥加密
    sanityCheck = SecKeyEncrypt(_publicKeyRef,
                                kSecPaddingPKCS1,
                                (const uint8_t *)data.bytes,
                                keyBufferSize,
                                cipherBuffer,
                                &cipherBufferSize
                                );
    NSAssert(sanityCheck == noErr, @"加密错误，OSStatus == %d", sanityCheck);
    // 生成密文数据
    cipher = [NSData dataWithBytes:(const void *)cipherBuffer length:(NSUInteger)cipherBufferSize];
    if (cipherBuffer) free(cipherBuffer);
    return cipher;
}

- (NSString*)kj_RSADecryptString:(NSString*)string {
    NSData *keyData = [self kj_RSADecryptData:[[NSData alloc] initWithBase64EncodedString:string options:0]];
    return [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
}

- (NSData*)kj_RSADecryptData:(NSData*)data {
    OSStatus sanityCheck = noErr;
    size_t cipherBufferSize = 0;
    size_t keyBufferSize = 0;
    NSData *key = nil;
    uint8_t *keyBuffer = NULL;
    SecKeyRef privateKey = _privateKeyRef;
    NSAssert(privateKey != NULL, @"私钥不存在");
    // 计算缓冲区大小
    cipherBufferSize = SecKeyGetBlockSize(privateKey);
    keyBufferSize = data.length;
    NSAssert(keyBufferSize <= cipherBufferSize, @"解密内容太大");
    // 分配缓冲区
    keyBuffer = malloc(keyBufferSize * sizeof(uint8_t));
    memset((void *)keyBuffer, 0x0, keyBufferSize);
    // 使用私钥解密
    sanityCheck = SecKeyDecrypt(privateKey,
                                kSecPaddingPKCS1,
                                (const uint8_t *)data.bytes,
                                cipherBufferSize,
                                keyBuffer,
                                &keyBufferSize
                                );
    NSAssert1(sanityCheck == noErr, @"解密错误，OSStatus == %d", sanityCheck);
    // 生成明文数据
    key = [NSData dataWithBytes:(const void *)keyBuffer length:(NSUInteger)keyBufferSize];
    if (keyBuffer) free(keyBuffer);
    return key;
}

#pragma mark - 32位 小写
+(NSString*)MD5ForLower32Bate:(NSString*)string{
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

#pragma mark - 32位 大写
+ (NSString*)MD5ForUpper32Bate:(NSString*)string{
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}

#pragma mark - 16位 大写
+ (NSString*)MD5ForUpper16Bate:(NSString*)string{
    NSString *md5Str = [self MD5ForUpper32Bate:string];
    NSString *_string;
    for (int i=0; i<24; i++) {
        _string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return _string;
}

#pragma mark - 16位 小写
+ (NSString*)MD5ForLower16Bate:(NSString*)string{
    NSString *md5Str = [self MD5ForLower32Bate:string];
    NSString *_string;
    for (int i=0; i<24; i++) {
        _string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return _string;
}
// BASE 64
+ (NSString*)decodeBase64:(NSString*)base64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
+ (NSString *)encodeBase64:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    return [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
}

#pragma mark - 快速接口
/// 生成key
+ (NSString*)kj_createKey{
    NSUInteger size = 16;
    char data[size];
    for (int x=0;x<size;x++) {
        int randomint = arc4random_uniform(2);
        if (randomint == 0) {
            data[x] = (char)('a' + (arc4random_uniform(26)));
        } else {
            data[x] = (char)('0' + (arc4random_uniform(9)));
        }
    }
    return [[NSString alloc] initWithBytes:data length:size encoding:NSUTF8StringEncoding];
}
/// 生成token
+ (NSString*)kj_createToken{
    return [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
/// MD5加密32位大写
+ (NSString*)kj_MD5:(NSString*)string{
    return [self MD5ForUpper32Bate:string];
}
/// 两次连续MD5加密32位大写
+ (NSString*)kj_MD5Twice:(NSString*)string{
    return [self MD5ForUpper32Bate:[self MD5ForUpper32Bate:string]];
}
/// Base64加密
+ (NSString*)kj_Base64Encrypt:(NSString*)string{
    return [self encodeBase64:string];
}
/// Base64解密
+ (NSString*)kj_Base64Decrypt:(NSString*)string{
    return [self decodeBase64:string];
}
/// DES加密
+ (NSString*)kj_DESEncrypt:(NSString*)string key:(NSString*)key{
    return [self kj_DESEncryptString:string keyString:key iv:[key dataUsingEncoding:NSUTF8StringEncoding]];
}
/// DES解密
+ (NSString*)kj_DESDecrypt:(NSString*)string key:(NSString*)key{
    return [self kj_DESDecryptString:string keyString:key iv:[key dataUsingEncoding:NSUTF8StringEncoding]];
}
/// AES加密
+ (NSString*)kj_AESEncrypt:(NSString*)string key:(NSString*)key{
    return [self kj_AESEncryptString:string keyString:key iv:[key dataUsingEncoding:NSUTF8StringEncoding]];
}
/// AES解密
+ (NSString*)kj_AESDecrypt:(NSString*)string key:(NSString*)key{
    return [self kj_AESDecryptString:string keyString:key iv:[key dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
