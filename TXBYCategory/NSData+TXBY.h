//
//  NSData+TXBY.h
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TXBY)

#pragma mark - Hash
/**
 *  返回一个md5 hash的NSString
 */
- (NSString *)md5String;

#pragma mark - Encode and Decode
/**
 *  返回一个utf8String
 */
- (NSString *)utf8String;

/**
 *  返回一个使用指定encoding编码的NSString
 *  @param encoding   编码类型
 */
- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;

/**
 *  返回一个使用base64编码的NSString
 */
- (NSString *)base64EncodedString;

/**
 *  返回一个使用base64解码的NSData
 *  @param base64EncodedString 要解码的NSString
 */
+ (NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

#pragma mark - Encrypt and Decrypt
/**
 *  返回使用默认的key加密后的NSData
 */
- (NSData *)encrypt;

/**
 *  返回使用指定的key加密后的NSData
 *  @param key 指定的key
 */
- (NSData *)encryptWithKey:(NSString *)key;

/**
 *  返回使用默认的key解密后的NSData
 */
- (NSData *)decrypt;

/**
 *  返回使用指定的key解密后的NSData
 *  @param key 指定的key
 */
- (NSData *)decryptWithKey:(NSString *)key;

@end