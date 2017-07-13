//
//  TXBYCommunityPhotoView.m
//  TXBYCommunity
//
//  Created by Limmy on 2017/4/13.
//  Copyright © 2017年 Limmy. All rights reserved.
//

#import "TXBYCirclePhotoView.h"
#import "TXBYCircleImg.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface TXBYCirclePhotoView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation TXBYCirclePhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [temp addObject:imageView];
    }
    self.imageViewsArray = temp;
}

- (void)setImgModels:(NSArray *)imgModels {
    _imgModels = imgModels;
    for (long i = imgModels.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_imgModels.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_imgModels ];
    CGFloat itemH = 0;
    if (_imgModels.count == 1) {
        TXBYCircleImg *imageModel = _imgModels.lastObject;
        if (imageModel.width) {
            itemH = imageModel.height / imageModel.width * itemW;
        }
        if (imageModel.height / imageModel.width > 2) {
            itemH = itemW * 1.5;
        }
    } else {
        itemH = itemW;
    }
    
    long perRowItemCount = 3;// 3列
    CGFloat margin = 2;
    [_imgModels enumerateObjectsUsingBlock:^(TXBYCircleImg *imageModel, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.url] placeholderImage:[UIImage imageNamed:@"image_default"]];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 20;
    long rowCount = (_imgModels.count - 1)/perRowItemCount;
    CGFloat h = (rowCount + 1) * itemH + margin * rowCount;
    self.width_sd = w;
    self.height_sd = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array {
    if (array.count == 1) {
        TXBYCircleImg *imageModel = _imgModels.lastObject;
        CGFloat wh = imageModel.height / imageModel.width;
        if (wh <= 0.75) {
            return [UIScreen mainScreen].bounds.size.width - 20;
        } else if(wh > 0.75 && wh < 1) {
            return [UIScreen mainScreen].bounds.size.width * 0.75;
        } else {
            return [UIScreen mainScreen].bounds.size.width * 0.45;
        }
    } else {
//        if (array.count < 3) {
//            return ([UIScreen mainScreen].bounds.size.width - 20 - (array.count - 1) * 2) / array.count;
//        } else {
            CGFloat w = ([UIScreen mainScreen].bounds.size.width - 24) / 3;
            return w;
//        }
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array {
    if (array.count <= 3) {
        return 1;
    } else if (array.count <= 6) {
        return 2;
    } else {
        return 3;
    }
}

- (void)tapImageView:(UIGestureRecognizer *)tap {
    int i = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (TXBYCircleImg *imgModel in self.imgModels) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        NSURL *url = [NSURL URLWithString:imgModel.url];
        mjphoto.url = url;
        mjphoto.index = i;
        mjphoto.srcImageView = self.subviews[i];
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    browser.isSavePhoto = YES;
    browser.currentPhotoIndex = tap.view.tag;
    
    [browser show];
}

@end
