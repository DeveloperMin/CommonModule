//
//  TXBYHTTPSessionManager.m
//  TXBYHTTPSessionManager
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "TXBYHTTPSessionManager.h"
#import "AFNetworking.h"
#import "TXBYCategory.h"

@interface TXBYHTTPSessionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray <NSDictionary<NSString *,NSURLSessionDataTask *> *> *networkingManagerArray;

@end

@implementation TXBYHTTPSessionManager

- (NSMutableArray<NSDictionary<NSString *,NSURLSessionDataTask *> *> *)networkingManagerArray {
    if (!_networkingManagerArray) {
        _networkingManagerArray = [NSMutableArray array];
    }
    return _networkingManagerArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] init];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setHTTPShouldHandleCookies:NO];
    }
    return self;
}

+ (instancetype)sharedManager {
    static  TXBYHTTPSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager  = [[self  alloc] init];
    });
    return sessionManager;
}

#pragma mark - 上传图片
- (void)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
               fileName:(NSString *)fileName
                   name:(NSString *)name
               mimeType:(NSString *)mimeType
             parameters:(NSDictionary *)parameters
                success:(TXBYSuccessBlock)success
                failure:(TXBYFailureBlock)failure {
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:url parameters:parameters netIdentifier:@"uploadImage"  success:success failure:failure];
    [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = fileName;
        if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.png", str];
        }
        
        NSString *imageMineType = mimeType;
        if (!mimeType) {
            imageMineType = @"image/png";
        }
        NSString *fileName = name;
        if (!name) {
            fileName = @"file";
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:fileName fileName:imageFileName mimeType:imageMineType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task,id _Nullable responseObject) {
        if (success) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                responseObject = jsonDic;
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadWithImage:(UIImage *)image
                    url:(NSString *)url
                success:(TXBYSuccessBlock)success
                failure:(TXBYFailureBlock)failure {
    [self uploadWithImage:image url:url fileName:nil name:nil mimeType:nil parameters:nil success:success failure:failure];
}

#pragma mark - 加密请求
#pragma mark get
- (void)encryptGet:(NSString *)url
        parameters:(NSDictionary *)parameters
     netIdentifier:(NSString *)netIdentifier
           success:(TXBYSuccessBlock)success
           failure:(TXBYFailureBlock)failure {
#ifdef TXBYURLHostSplice
    url = [self URLStringByAppendingHostWithPathString:url];
#endif
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:url parameters:parameters netIdentifier:netIdentifier  success:success failure:failure];
    sessionManager.responseSerializer = [AFCompoundResponseSerializer serializer];
    if (!sessionManager) return;
    
    NSURLSessionDataTask *task = [sessionManager GET:url parameters:[parameters encryptParameters] progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (success) {
            responseObject = [self decryptWithResponseObject:responseObject];
            [self evaluateTokenWithResponseObject:responseObject];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failure) {
            failure(error);
        }
    }];
    
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

#pragma mark post
- (void)encryptPost:(NSString *)url
         parameters:(NSDictionary *)parameters
      netIdentifier:(NSString *)netIdentifier
            success:(TXBYSuccessBlock)success
            failure:(TXBYFailureBlock)failure {
#ifdef TXBYURLHostSplice
    url = [self URLStringByAppendingHostWithPathString:url];
#endif
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:url parameters:parameters netIdentifier:netIdentifier  success:success failure:failure];
    sessionManager.responseSerializer = [AFCompoundResponseSerializer serializer];
    if (!sessionManager) return;
    NSURLSessionDataTask *task = [sessionManager POST:url parameters:[parameters encryptParameters] progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (success) {
            responseObject = [self decryptWithResponseObject:responseObject];
            [self evaluateTokenWithResponseObject:responseObject];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failure) {
            failure(error);
        }
    }];
    
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

#pragma mark - 不加密请求
#pragma mark get
- (void)get:(NSString *)url
 parameters:(NSDictionary *)parameters
netIdentifier:(NSString *)netIdentifier
    success:(TXBYSuccessBlock)success
    failure:(TXBYFailureBlock)failure {
#ifdef TXBYURLHostSplice
    url = [self URLStringByAppendingHostWithPathString:url];
#endif
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:url parameters:parameters netIdentifier:netIdentifier  success:success failure:failure];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (!sessionManager) return;
    NSURLSessionDataTask *task = [sessionManager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failure) {
            failure(error);
        }
    }];
    
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}


#pragma mark post
- (void)post:(NSString *)url
  parameters:(NSDictionary *)parameters
netIdentifier:(NSString *)netIdentifier
     success:(TXBYSuccessBlock)success
     failure:(TXBYFailureBlock)failure {
#ifdef TXBYURLHostSplice
    url = [self URLStringByAppendingHostWithPathString:url];
#endif
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:url parameters:parameters netIdentifier:netIdentifier  success:success failure:failure];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    if (!sessionManager) return;
    NSURLSessionDataTask *task = [sessionManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failure) {
            failure(error);
        }
    }];
    
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

#pragma mark - 取消
- (void)cancelAllNetworking {
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        [task cancel];
    }
    [self.networkingManagerArray removeAllObjects];
}

- (void)cancelNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    for (NSString *netIdentifier in netIdentifierArray) {
        [self cancelNetworkingWithNetIdentifier:netIdentifier];
    }
}

- (void)cancelNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    if (!netIdentifier) return;
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            [task cancel];
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
            return;
        }
    }
}

- (NSArray <NSString *>*)getUnderwayNetIdentifierArray {
    NSMutableArray *muarr = [NSMutableArray array];
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        [muarr addObject:key];
    }
    return muarr;
}

#pragma mark - 暂停
- (void)suspendAllNetworking {
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        if (task.state == NSURLSessionTaskStateRunning) {
            [task suspend];
        }
    }
}

- (void)suspendNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    for (NSString *netIdentifier in netIdentifierArray) {
        [self suspendNetworkingWithNetIdentifier:netIdentifier];
    }
    
}

- (void)suspendNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    if (!netIdentifier) return;
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            [task suspend];
        }
    }
}

- (NSArray<NSString *> *)getSuspendNetIdentifierArray {
    NSMutableArray *muarr = [NSMutableArray array];
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        if (task.state == NSURLSessionTaskStateSuspended) {
            [muarr addObject:key];
        }
    }
    return muarr;
}

#pragma  mark - 恢复
- (void)resumeAllNetworking {
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        if (task.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
    }
}

- (void)resumeNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    for (NSString *netIdentifier in netIdentifierArray) {
        [self resumeNetworkingWithNetIdentifier:netIdentifier];
    }
}

- (void)resumeNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    if (!netIdentifier) return;
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            if (task.state == NSURLSessionTaskStateSuspended) {
                [task resume];
            }
        }
    }
}

#pragma  mark - 私有方法
- (AFHTTPSessionManager *)getManagerWithWithPath:(const NSString *)path
                                      parameters:(id)parameters
                                   netIdentifier:(NSString *)netIdentifier
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError   *error))failure {
    
    // 1.当前的请求是否正在进行
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            if (failure) {
                NSErrorDomain domain = [NSString stringWithFormat:@"\"%@\"请求正在进行!",netIdentifier];
                NSError *cancelError = [NSError errorWithDomain:domain code:(-12001) userInfo:nil];
                failure(cancelError);
            }
            return nil;
        }
    }
    
    // 2.检测是否有网络
    AFNetworkReachabilityStatus net = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if ( net == AFNetworkReachabilityStatusNotReachable) {
        if (failure) {
            NSError *cancelError = [NSError errorWithDomain:@"没有网络,请检测网络!" code:(-12002) userInfo:nil];
            failure(cancelError);
        }
        return nil;
    }
    
    return self.manager;
}

/**
 *  解密返回结果
 */
- (id)decryptWithResponseObject:(id)responseObject {
    NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    jsonString = [[jsonString decrypt] stringByReplacingOccurrencesOfString:@"\"id\"" withString:@"\"ID\""];
    return [NSJSONSerialization JSONObjectWithData:jsonString.dataValue options:kNilOptions error:nil];
}

/**
 *  根据返回结果验证token
 */
- (void)evaluateTokenWithResponseObject:(id)responseObject {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSInteger code = [responseObject[@"errcode"] integerValue];
    // token过期或未认证
    if (20004 == code || 20002 == code) {
        [MBProgressHUD showInfo:@"账号已过期, 请重新登录" toView:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TXBY_NOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#ifdef TXBYURLHostSplice
/**
 *  URL路径补全协议、主机和端口号
 */
- (NSString *)URLStringByAppendingHostWithPathString:(NSString *)path {
    if (![path hasPrefix:@"http://"]) {
        return [NSString stringWithFormat:@"%@%@",TXBYURLHost,path];
    }
    return path;
}
#endif

@end
