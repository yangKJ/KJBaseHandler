//
//  KJCryptoTool.h
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/17.
//  Copyright © 2020 杨科军. All rights reserved.
//  加密解密工具

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
NS_ASSUME_NONNULL_BEGIN

@interface KJCommonCryptoTool : NSObject
/// 生成key
+ (NSString*)kj_createKey;
/// 生成token
+ (NSString*)kj_createToken;
/// 过滤空格、回车、换行
+ (NSString*)kj_filtrationString:(NSString*)string;
/// MD5 加密 32位大写
+ (NSString*)kj_MD5:(NSString*)string;
/// 两次 MD5 加密 32位大写
+ (NSString*)kj_MD5Twice:(NSString*)string;
/// Base64 加密
+ (NSString*)kj_Base64Encrypt:(NSString*)string;
/// Base64 解密
+ (NSString*)kj_Base64Decrypt:(NSString*)string;
/// DES 加密
+ (NSString*)kj_DESEncrypt:(NSString*)string key:(NSString*)key;
/// DES 解密
+ (NSString*)kj_DESDecrypt:(NSString*)string key:(NSString*)key;
/// AES 加密
+ (NSString*)kj_AESEncrypt:(NSString*)string key:(NSString*)key;
/// AES  解密
+ (NSString*)kj_AESDecrypt:(NSString*)string key:(NSString*)key;

#pragma mark - DES 加密/解密
/// DES 加密
+ (NSData*)kj_DESEncryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv;
/// DES 加密字符串
+ (NSString*)kj_DESEncryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv;
/// DES 解密
+ (NSData*)kj_DESDecryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv;
/// DES 解密
+ (NSString*)kj_DESDecryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv;

#pragma mark - AES 加密/解密
/// AES加密
+ (NSData*)kj_AESEncryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv;
/// AES加密字符串
+ (NSString*)kj_AESEncryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv;
/// AES解密
+ (NSData*)kj_AESDecryptData:(NSData*)data keyString:(NSString*)keyString iv:(NSData*)iv;
/// AES解密
+ (NSString*)kj_AESDecryptString:(NSString*)string keyString:(NSString*)keyString iv:(NSData*)iv;

#pragma mark - RSA 加密/解密算法
/// 加载公钥 filePath：Der公钥文件路径
- (void)kj_loadPublicKeyWithFilePath:(NSString*)filePath;
/// 加载私钥 filePath：P12 私钥文件路径  password：P12 密码
- (void)kj_loadPrivateKey:(NSString*)filePath password:(NSString*)password;
/// RSA 加密数据
- (NSData*)kj_RSAEncryptData:(NSData*)data;
/// RSA 加密字符串
- (NSString*)kj_RSAEncryptString:(NSString*)string;
/// RSA 解密数据
- (NSData*)kj_RSADecryptData:(NSData*)data;
/// RSA 解密字符串
- (NSString*)kj_RSADecryptString:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
