//
//  CommunityToolBar.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityToolBar.h"
#import "AccountTool.h"
#import "CommunityParam.h"

@interface CommunityToolBar ()
/**
 *  浏览数
 */
@property (nonatomic, strong) UILabel *scanLabel;
/**
 *  点赞按钮
 */
@property (nonatomic, strong) UIButton *loveBtn;
/**
 *  点踩按钮
 */
@property (nonatomic, strong) UIButton *treadBtn;
/**
 *  评论按钮
 */
@property (nonatomic, strong) UIButton *commonBtn;

@end

@implementation CommunityToolBar

- (UILabel *)scanLabel {
    if (!_scanLabel) {
        _scanLabel = [[UILabel alloc] init];
        _scanLabel.frame = CGRectMake(8, 0, 80, 30);
        _scanLabel.font = [UIFont systemFontOfSize:13];
        _scanLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.scanLabel];
    }
    return _scanLabel;
}

- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loveBtn.frame = CGRectMake(TXBYApplicationW - 50, 0, 30, 30);
        _loveBtn.tag = 2;
        [_loveBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_loveBtn setImage:[UIImage imageNamed:@"community.bundle/unlike@3x"] forState:UIControlStateNormal];
        [_loveBtn setImage:[UIImage imageNamed:@"community.bundle/like@3x"] forState:UIControlStateSelected];
        [self addSubview:self.loveBtn];
    }
    return _loveBtn;
}

- (UIButton *)treadBtn {
    if (!_treadBtn) {
        _treadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _treadBtn.frame = CGRectMake(TXBYApplicationW - 100, 0, 30, 30    );
        _treadBtn.tag = 1;
        [_treadBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_treadBtn setImage:[UIImage imageNamed:@"community.bundle/undotlike@3x"] forState:UIControlStateNormal];
        [_treadBtn setImage:[UIImage imageNamed:@"community.bundle/dotlike@3x"] forState:UIControlStateSelected];
        [self addSubview:self.treadBtn];
    }
    return _treadBtn;
}

- (UIButton *)commonBtn {
    if (!_commonBtn) {
        _commonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commonBtn.frame = CGRectMake(TXBYApplicationW - 150, 0, 30, 30    );
        _commonBtn.tag = 0;
        [_commonBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_commonBtn setImage:[UIImage imageNamed:@"community.bundle/comment@3x"] forState:UIControlStateNormal];
        [self addSubview:self.commonBtn];
    }
    return _commonBtn;
}

- (void)setCommunityItem:(CommunityListItem *)communityItem {
    _communityItem = communityItem;
    [self setUpViews];
    if (self.isTread) {
        self.treadBtn.hidden = NO;
    } else {
        self.treadBtn.hidden = YES;
        self.commonBtn.txby_x = self.treadBtn.txby_x;
    }
    self.scanLabel.text = [NSString stringWithFormat:@"浏览%@次",[self countScanData:communityItem.browse]];
    if ([communityItem.is_loved isEqualToString:@"1"]) {
        self.loveBtn.selected = YES;
    } else {
        self.loveBtn.selected = NO;
    }
    if ([communityItem.is_treaded isEqualToString:@"1"]) {
        self.treadBtn.selected = YES;
    } else {
        self.treadBtn.selected = NO;
    }
}

- (void)setUpViews {
    self.scanLabel.txby_centerY = self.txby_height/2;
    self.loveBtn.txby_centerY = self.txby_height/2;
    self.treadBtn.txby_centerY = self.txby_height/2;
    self.commonBtn.txby_centerY = self.txby_height/2;
}

- (void)clickBtn:(UIButton *)btn {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"请先登录" toView:ESWindow];
        return;
    }
    if (btn.tag == 0) {
        if ([self.barDelegate respondsToSelector:@selector(clickCommunityToolBarBtn:)]) {
            [self.barDelegate clickCommunityToolBarBtn:btn];
        }
    } else {
        if ((self.treadBtn.selected && btn.tag == 2) || (self.loveBtn.selected && btn.tag == 1)){
            return;
        }
        btn.selected = !btn.selected;
        if(btn.tag == 1) {
            if (btn.selected) {
                [self requsetTread];
            } else {
                [self requsetCancelTread];
            }
        } else {
            if (btn.selected) {
                [self requsetLove];
            } else {
                [self requsetCancelLove];
            }
        }
    }
}

- (void)requsetTread {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityItem.ID;
    param.category = @"2";
    param.operate = @"4";
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.communityItem.treaded_id = responseObject[@"ID"];
            self.communityItem.is_treaded = @"1";
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelTread {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityItem.treaded_id;
    param.category = @"2";
    param.operate = @"4";
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.communityItem.is_treaded = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

- (void)requsetLove {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityItem.ID;
    param.category = @"2";
    param.operate = @"3";
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.communityItem.loved_id = responseObject[@"ID"];
            self.communityItem.is_loved = @"1";
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelLove {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityItem.loved_id;
    param.category = @"2";
    param.operate = @"3";
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            self.communityItem.is_loved = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

- (NSString *)countScanData:(NSString *)str {
    NSInteger count = str.integerValue;
    NSString *title;
    if (count > 10000) {
        CGFloat floatCount = count/10000.0;
        title = [NSString stringWithFormat:@"%.1fW", floatCount];
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }else
    {
        title = [NSString stringWithFormat:@"%ld", (long)count];
    }
    return title;
}

@end
