//
//  NSURL+TXBY.m
//  txzjPatient
//
//  Created by hj on 2017/5/28.
//  Copyright © 2017年 eeesys. All rights reserved.
//

#import "NSURL+TXBY.h"

@implementation NSURL (TXBY)

+ (instancetype)URLWithString:(NSString *)URLString {
    NSURL *URL;
    if (URLString) {
        URLString = [URLString stringByURLDecode];
        URL = [[NSURL alloc] initWithString:[URLString stringByURLEncode]];
    }
    return URL;
}

@end
