//
//  NSData+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "NSData+TXBY.h"
#include <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"

// 密钥
NSString *const TXBYCryptKey = @"iloveeeesys&&ilovehealth";

@implementation NSData (TXBY)

- (NSString *)utf8String {
    return [self stringWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding {
    if (!self.length) return @"";
    return [[NSString alloc] initWithData:self encoding:encoding];
}

- (NSString *)md5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)base64EncodedString {
    return [GTMBase64 stringByEncodingData:self];
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString {
    return [GTMBase64 decodeData:[base64EncodedString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)encrypt {
    return [self encryptWithKey:nil];
}

- (NSData *)encryptWithKey:(NSString *)key {
    return [self encryptOrDecrypt:kCCEncrypt key:key];
}

- (NSData *)decrypt {
    return [self decryptWithKey:nil];
}

- (NSData *)decryptWithKey:(NSString *)key {
    return [self encryptOrDecrypt:kCCDecrypt key:key];
}

- (NSData *)encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString *)key {
    const void *vplainText;
    size_t plainTextBufferSize;
    if (!key) key = TXBYCryptKey;
    
    if (encryptOrDecrypt == kCCDecrypt) { // 解密
        NSData *EncryptData = [NSData dataWithBase64EncodedString:[self utf8String]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else { // 加密
        NSData* data = self;
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return data;
}

@end