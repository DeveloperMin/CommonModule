//
//  CommunityListCell.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/24.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "CommunityListCell.h"
#import "CommunityToolBar.h"
#import "CommunityListItem.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AccountTool.h"
#import "CommunityParam.h"

@interface CommunityListCell ()<CommunityToolBarDelegate>
/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *avatar;
/**
 *  用户名
 */
@property (nonatomic, strong) UILabel *userLabel;
/**
 *  时间
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  内容
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 *  图片view
 */
@property (nonatomic, strong) UIView *photoView;
/**
 *  toolBar
 */
@property (nonatomic, strong) CommunityToolBar *toolBar;
/**
 *  communityItem
 */
@property (nonatomic, strong) CommunityListItem *communityItem;
/**
 *  给评论者点赞
 */
@property (nonatomic, strong) UIButton *loveBtn;
/**
 *  给评论者点踩
 */
@property (nonatomic, strong) UIButton *unLoveBtn;

@end

@implementation CommunityListCell

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 18;
        [self.contentView addSubview:_avatar];
    }
    return _avatar;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.font = [UIFont systemFontOfSize:16];
        _userLabel.textColor = [UIColor darkGrayColor];
        _userLabel.numberOfLines = 0;
        [self.contentView addSubview:_userLabel];
    }
    return _userLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)photoView {
    if (!_photoView) {
        _photoView = [UIView new];
        [self.contentView addSubview:_photoView];
    }
    return _photoView;
}

- (CommunityToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[CommunityToolBar alloc] init];
        [self.contentView addSubview:_toolBar];
    }
    return _toolBar;
}

//- (UILabel *)communtyLabel {
    //if (!_communtyLabel) {
        //_communtyLabel = [UILabel new];
        //_communtyLabel.textAlignment = NSTextAlignmentRight;
        //_communtyLabel.textColor = [UIColor darkGrayColor];
        //_communtyLabel.font = [UIFont systemFontOfSize:15];
        //[self.contentView addSubview:_communtyLabel];
    //}
    //return _communtyLabel;
//}

- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loveBtn setImage:[UIImage imageNamed:@"community.bundle/unlike"] forState:UIControlStateNormal];
        [_loveBtn setImage:[UIImage imageNamed:@"community.bundle/like"] forState:UIControlStateSelected];
        [_loveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_loveBtn addTarget:self action:@selector(clickLoveBtn:) forControlEvents:UIControlEventTouchUpInside];
        _loveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _loveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [self.contentView addSubview:_loveBtn];
    }
    return _loveBtn;
}

- (UIButton *)unLoveBtn {
    if (!_unLoveBtn) {
        _unLoveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unLoveBtn setImage:[UIImage imageNamed:@"community.bundle/undotlike"] forState:UIControlStateNormal];
        _unLoveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [_unLoveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_unLoveBtn setImage:[UIImage imageNamed:@"community.bundle/dotlike"] forState:UIControlStateSelected];
        _unLoveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_unLoveBtn addTarget:self action:@selector(clickUnLoveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_unLoveBtn];
    }
    return _unLoveBtn;
}

- (void)setCellFrame:(CommunityCellFrame *)cellFrame {
    _cellFrame = cellFrame;
    self.communityItem = cellFrame.communityItem;
    
    self.avatar.frame = cellFrame.avatarFrame;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.communityItem.avatar] placeholderImage:[UIImage imageNamed:@"community.bundle/mine_avatar"]];
    
    self.userLabel.frame = cellFrame.userNameFrame;
    self.userLabel.text = self.communityItem.name;
    
    self.timeLabel.frame = cellFrame.createTimeFrame;
    self.timeLabel.text = [self.communityItem.create_time minutesAgo];
    
    if (self.comment) {
        self.loveBtn.frame = CGRectMake(TXBYApplicationW - 60, 15, 60, 30);
        self.loveBtn.selected = [self.communityItem.is_loved isEqualToString:@"1"] ? YES:NO;
        if (self.communityItem.love.integerValue > 0) {
            [self.loveBtn setTitle:self.communityItem.love forState:UIControlStateNormal];
        }
        if (self.isTread) {
            self.unLoveBtn.frame = CGRectMake(TXBYApplicationW - 120, 15, 60, 30);
            self.unLoveBtn.selected = [self.communityItem.is_treaded isEqualToString:@"1"] ? YES:NO;
            if (self.communityItem.tread.integerValue > 0) {
                [self.unLoveBtn setTitle:self.communityItem.tread forState:UIControlStateNormal];
            }
        }
    }
    self.titleLabel.frame = cellFrame.titleFrame;
    self.titleLabel.text = self.communityItem.title;
    
    self.contentLabel.frame = cellFrame.contentFrame;
    self.contentLabel.text = self.communityItem.content;
    if (self.communityItem.imgs.count) {
        [self.photoView removeAllSubviews];
        // 图片view
        self.photoView.frame = cellFrame.photoFrame;
        self.photoView.hidden = NO;
        CGFloat margin = 8;
        CGFloat imageW = (TXBYApplicationW - 8 * 4)/3;
        if (self.comment) {
            imageW = (TXBYApplicationW - 8 * 3 - cellFrame.titleFrame.origin.x)/3;
        } else {
            imageW = (TXBYApplicationW - 8 * 4)/3;
        }
        if (self.communityItem.imgs.count == 1) {
            self.photoView.txby_height = imageW + 40;
            UIImageView *image = [[UIImageView alloc] init];
            image.userInteractionEnabled = YES;
            NSArray *array = [self.communityItem.imgs[0] componentsSeparatedByString:@"/"];
            NSString *urlStr = [NSString stringWithFormat:@"%@?name=%@", TXBYCommunityThumbAPI, array.lastObject];
            [image sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"community.bundle/avatar_default"]];
            if (self.comment) {
                image.frame = CGRectMake(cellFrame.titleFrame.origin.x, 8, imageW * 2, imageW + 40);
            } else {
                image.frame = CGRectMake(margin, 8, imageW * 2, imageW + 40);
            }
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [self.photoView addSubview:image];
            image.tag = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
            [image addGestureRecognizer:tap];
        } else  {
            for (NSInteger i = 0; i < self.communityItem.imgs.count; i++) {
                UIImageView *image = [[UIImageView alloc] init];
                image.userInteractionEnabled = YES;
                NSArray *array = [self.communityItem.imgs[i] componentsSeparatedByString:@"/"];
                NSString *urlStr = [NSString stringWithFormat:@"%@?name=%@", TXBYCommunityThumbAPI, array.lastObject];
                [image sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"community.bundle/avatar_default"]];
                CGFloat imageX;
                if (self.comment) {
                    imageX = (imageW + margin) * i + cellFrame.titleFrame.origin.x;
                } else {
                    imageX = (imageW + margin) * i + margin;
                }
                
                image.frame = CGRectMake(imageX, 8, imageW, imageW );
                image.contentMode = UIViewContentModeScaleAspectFill;
                image.clipsToBounds = YES;
                [self.photoView addSubview:image];
                image.tag = i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
                [image addGestureRecognizer:tap];
            }
        }
    } else {
        self.photoView.hidden = YES;
    }
    self.toolBar.frame = cellFrame.toolBarFrame;
    self.toolBar.isTread = self.isTread;
    self.toolBar.communityItem = self.communityItem;
    self.toolBar.barDelegate = self;
}

- (void)bigImage:(UIGestureRecognizer *)tap {
    int i = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *imageStr in self.communityItem.imgs) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        NSURL *url = [NSURL URLWithString:imageStr];
        mjphoto.url = url;
        mjphoto.index = i;
        mjphoto.srcImageView = self.photoView.subviews[i];
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    browser.currentPhotoIndex = tap.view.tag;
    
    [browser show];
}

- (void)clickCommunityToolBarBtn:(UIButton *)btn {
    if (self.toolBarBlock) {
        self.toolBarBlock(btn.tag);
    }
}

- (void)clickUnLoveBtn:(UIButton *)btn {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"请先登录" toView:ESWindow];
        return;
    }
    if (self.loveBtn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    NSInteger count = self.communityItem.tread.integerValue;
    if (btn.selected) {
        [self requsetUnLove];
        count++;
    } else {
        [self requsetCancelUnLove];
        count--;
    }
    self.communityItem.tread = [NSString stringWithFormat:@"%ld", (long)count];
    if (count > 0) {
        [self.unLoveBtn setTitle:self.communityItem.tread forState:UIControlStateNormal];
    } else {
        [self.unLoveBtn setTitle:@"" forState:UIControlStateNormal];
    }
}
- (void)requsetUnLove {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityItem.ID;
    param.category = @"4";
    param.operate = @"4";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityItem.treaded_id = responseObject[@"ID"];
            selfWeak.communityItem.is_treaded = @"1";
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelUnLove {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityItem.treaded_id;
    param.category = @"4";
    param.operate = @"4";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityItem.is_treaded = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

- (void)clickLoveBtn:(UIButton *)btn {
    if (![AccountTool account]) {
        [MBProgressHUD showInfo:@"请先登录" toView:ESWindow];
        return;
    }
    if (self.unLoveBtn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    NSInteger count = self.communityItem.love.integerValue;
    if (btn.selected) {
        [self requsetLove];
        count++;
    } else {
        [self requsetCancelLove];
        count--;
    }
    self.communityItem.love = [NSString stringWithFormat:@"%ld", (long)count];
    if (count > 0) {
        [self.loveBtn setTitle:self.communityItem.love forState:UIControlStateNormal];
    } else {
        [self.loveBtn setTitle:@""forState:UIControlStateNormal];
    }
}

- (void)requsetLove {
    CommunityParam *param = [CommunityParam param];
    param.oid = self.communityItem.ID;
    param.category = @"4";
    param.operate = @"3";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityItem.loved_id = responseObject[@"ID"];
            selfWeak.communityItem.is_loved = @"1";
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requsetCancelLove {
    CommunityParam *param = [CommunityParam param];
    param.ID = self.communityItem.loved_id;
    param.category = @"4";
    param.operate = @"3";
    WeakSelf;
    // 发送请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYCommunityCancelLoveAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            selfWeak.communityItem.is_loved = @"0";
        }
    } failure:^(NSError *error) {
    }];
}

@end
