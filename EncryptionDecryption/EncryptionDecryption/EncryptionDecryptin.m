//
//  EncryptionDecryptin.m
//  EncryptionDecryption
//
//  Created by kaxiaoer on 14-6-3.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "EncryptionDecryptin.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation EncryptionDecryptin

@end
@implementation NSData (DES)
- (NSData *)DESByKey:(NSString *)key Operation:(CCOperation)operation{
    const void *dataIn;
    size_t dataInLength;
    dataIn = [self bytes];
    dataInLength = [self length];
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = 1+(dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, '\0', dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //    NSString *initIv = @"12345678";
    Byte iv[] = {1,2,3,4,5,6,7,8};
    const void *vkey = (const void *) [key UTF8String];
    //    const void *iv = ;
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(operation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,// (des:对每块分组加一次密
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    if (ccStatus == kCCSuccess) {
        NSData *result = [NSData dataWithBytes:dataOut length:dataOutAvailable];
        free(dataOut);
        return result;
    }
    return nil;
}

- (NSData *)DESEncryptByKey:(NSString *)key{
    NSData *data = [self DESByKey:key Operation:kCCEncrypt];
    return [GTMBase64 encodeData:data];
}
- (NSData *)DESDecryptByKey:(NSString *)key{
    NSData *data = [GTMBase64 decodeData:self];
    NSData *dataOut = [data DESByKey:key Operation:kCCDecrypt];
    return dataOut;
}
- (NSString *)DESDecryptToStringByKey:(NSString *)key{
    NSData *data = [GTMBase64 decodeData:self];
    NSData *dataOut = [data DESByKey:key Operation:kCCDecrypt];
    return [[NSString alloc] initWithData:dataOut encoding:NSUTF8StringEncoding];
}
@end

@implementation NSString (DES)
- (NSData *)DESEncryptByKey:(NSString *)key{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *outData = [data DESEncryptByKey:key];
    return outData;
}
- (NSString *)DESEncryptToStringByKey:(NSString *)key{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSData *outData = [data DESByKey:key Operation:kCCEncrypt];
    return [GTMBase64 stringByEncodingData:outData];
}
- (NSString *)DESDecryptToStringByKey:(NSString *)key{
    NSData *data = [GTMBase64 decodeString:self];
    NSData *outData = [data DESByKey:key Operation:kCCDecrypt];
    return [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
}
@end