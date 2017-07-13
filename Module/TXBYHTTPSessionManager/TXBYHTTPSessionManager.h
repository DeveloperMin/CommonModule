//
//  TXBYHTTPSessionManager.h
//  TXBYHTTPSessionManager
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TXBYHTTPSessionManager : NSObject

typedef void(^TXBYSuccessBlock) (id responseObject);
typedef void(^TXBYFailureBlock) (NSError *error);

#pragma mark - sharedManager
/**
 *  @return 网络管理者对象
 */
+ (instancetype)sharedManager;

#pragma mark - 上传图片
/**
 *  图片上传
 *
 *	@param image	    图片对象
 *	@param url		    上传图片的接口路径
 *	@param fileName		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`png`
 *	@param name		    与指定的图片相关联的名称，这是由后端写接口的人指定的，如file
 *	@param mimeType		默认为image/png
 *	@param parameters	参数
 *	@param success	    上传成功回调
 *	@param failure		上传失败回调
 */
- (void)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
               fileName:(NSString *)fileName
                   name:(NSString *)name
               mimeType:(NSString *)mimeType
             parameters:(NSDictionary *)parameters
                success:(TXBYSuccessBlock)success
                failure:(TXBYFailureBlock)failure;

/**
 *  图片上传
 */
- (void)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
                success:(TXBYSuccessBlock)success
                failure:(TXBYFailureBlock)failure;

#pragma mark - 加密请求
#pragma mark get
/**
 *  get请求
 *
 *  @param url              url
 *  @param parameter        参数
 *  @param netIdentifier    请求标志
 *  @param success          成功
 *  @param failure          失败
 */
- (void)encryptGet:(NSString *)url
        parameters:(NSDictionary *)parameters
     netIdentifier:(NSString *)netIdentifier
           success:(TXBYSuccessBlock)success
           failure:(TXBYFailureBlock)failure;

#pragma mark post
/**
 *  post请求
 *
 *  @param url              url
 *  @param parameter        参数
 *  @param netIdentifier    请求标志
 *  @param success          成功
 *  @param failure          失败
 */
- (void)encryptPost:(NSString *)url
         parameters:(NSDictionary *)parameters
      netIdentifier:(NSString *)netIdentifier
            success:(TXBYSuccessBlock)success
            failure:(TXBYFailureBlock)failure;

#pragma mark - 不加密请求
#pragma mark get
/**
 *  get请求
 *
 *  @param url              url
 *  @param parameter        参数
 *  @param netIdentifier    请求标志
 *  @param success          成功
 *  @param failure          失败
 */
- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
netIdentifier:(NSString *)netIdentifier
    success:(TXBYSuccessBlock)success
    failure:(TXBYFailureBlock)failure;

#pragma mark post
/**
 *  post请求
 *
 *  @param url              url
 *  @param parameter        参数
 *  @param netIdentifier    请求标志
 *  @param success          成功
 *  @param failure          失败
 */
- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
netIdentifier:(NSString *)netIdentifier
     success:(TXBYSuccessBlock)success
     failure:(TXBYFailureBlock)failure;


#pragma mark - 取消
/**
 *  取消所有网络请求
 */
- (void)cancelAllNetworking;

/**
 *  取消一组网络请求
 *
 *  @param netIdentifier 网络请求标志
 */
- (void)cancelNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifier;

/**
 *  取消对应的网络请求
 *
 *  @param netIdentifier 网络请求标志
 */
- (void)cancelNetworkingWithNetIdentifier:(NSString *)netIdentifier;

/**
 *  获取正在进行的网络请求
 *
 *  @return 正在进行的网络请求标志数组
 */
- (NSArray <NSString *>*)getUnderwayNetIdentifierArray;

#pragma mark - 暂停
/**
 *  暂停所有网络请求
 */
- (void)suspendAllNetworking;

/**
 *  暂停一组网络请求
 *
 *  @param netIdentifierArray 网络标志数组
 */
- (void)suspendNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray;

/**
 *  暂停对应的网络请求
 *
 *  @param netIdentifier 网络标志
 */
- (void)suspendNetworkingWithNetIdentifier:(NSString *)netIdentifier;

/**
 *  获取正暂停的网络请求
 *
 *  @return 返回网络标志数组
 */
- (NSArray <NSString *>*)getSuspendNetIdentifierArray;

#pragma mark - 恢复
/**
 *  恢复所有暂停的网络请求
 */
- (void)resumeAllNetworking;

/**
 *  恢复一组暂停的网络请求
 *
 *  @param netIdentifierArray 网络请求标志数组
 */
- (void)resumeNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray;

/**
 *  恢复暂停的的网络请求
 *
 *  @param netIdentifier  网络请求标志
 */
- (void)resumeNetworkingWithNetIdentifier:(NSString *)netIdentifier;

@end