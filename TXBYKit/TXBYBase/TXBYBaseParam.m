//
//  TXBYBaseParam.m
//  TXBYBaseParam
//
//  Created by hj on 16/5/9.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import "TXBYBaseParam.h"
#import "TXBYKitConst.h"
#import "AccountTool.h"

@implementation TXBYBaseParam

- (NSString *)token {
    if (!_token) {
        _token = [AccountTool account].token;
    }
    return _token;
}

/**
 *  快速创建一个请求参数对象
 */
+ (instancetype)param {
    // 默认使用pch中的医院ID
    id param = [[self alloc] init];
    
    NSException *hospitalException = [NSException
                                      exceptionWithName: @"参数未初始化"
                                      reason: @"未设置医院ID"
                                      userInfo: nil];
    NSException *apptypeException = [NSException
                                     exceptionWithName: @"参数未初始化"
                                     reason: @"未设置apptype"
                                     userInfo: nil];
    NSString *hospital = TXBYHospital;
    NSString *app_type = TXBYApp_type;
    NSString *branch = TXBYBranch;
    
    if (!hospital) {
#ifdef TXBYCStrHospital
        hospital = [NSString stringWithFormat:@"%s",TXBYCStrHospital];
#endif
        if (!hospital) {
            @throw hospitalException;
        }
    }
    if (!app_type) {
#ifdef TXBYCStrApp_type
        app_type = [NSString stringWithFormat:@"%s",TXBYCStrApp_type];
#endif
        if (!app_type) {
            @throw apptypeException;
        }
    }
    if (branch) {
        [param setBranch:branch];
    }
    [param setHospital:hospital];
    [param setApp_type:app_type];
    return param;

}

@end
