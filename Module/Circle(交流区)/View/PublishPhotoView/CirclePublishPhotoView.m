

//
//  CirclePublishPhotoView.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/26.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CirclePublishPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface CirclePublishPhotoView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@property (nonatomic, strong) NSArray *buttonsArray;

@end

@implementation CirclePublishPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSMutableArray *temp = [NSMutableArray new];
    NSMutableArray *buttons = [NSMutableArray array];
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
        
        // 取消按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = i;
        btn.frame = CGRectMake(0, 0, 22, 22);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setImage:[UIImage imageNamed:@"Circle.bundle/delete"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:30];
        [buttons addObject:btn];
    }
    self.imageViewsArray = temp;
    self.buttonsArray = buttons;
}

- (void)tapImageView:(UIGestureRecognizer *)tap {
    UIImageView *tapView = (UIImageView *)tap.view;
    int i = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (UIImage *image in self.images) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.image = image;
        mjphoto.index = i;
        mjphoto.firstShow = YES;
        mjphoto.srcImageView = tapView;
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    browser.currentPhotoIndex = tapView.tag;
    browser.isSavePhoto = YES;
    [browser show];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    for (long i = images.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
        UIButton *btn = [self.buttonsArray objectAtIndex:i];
        btn.hidden = YES;
    }
    
    if (images.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemWH, margin = 12;
    long perRowItemCount;// 列数
    if (self.circlePublishStyle == CirclePublishStyleCircle) {
        perRowItemCount = 4;
        itemWH = (self.txby_width - (perRowItemCount + 1) * margin) / perRowItemCount;
    } else {
        perRowItemCount = 3;
        itemWH = (self.txby_width - (perRowItemCount + 1) * margin) / perRowItemCount;
    }
    
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        imageView.image = image;
        imageView.frame = CGRectMake(columnIndex * (itemWH + margin) + margin, rowIndex * (itemWH + margin) + margin, itemWH, itemWH);
        UIButton *btn = _buttonsArray[idx];
        btn.hidden = NO;
        btn.txby_centerY = imageView.txby_y;
        btn.txby_centerX = CGRectGetMaxX(imageView.frame);
    }];
//    long rowCount = images.count/perRowItemCount;
//    CGFloat h = (rowCount + 1) * itemWH + margin * rowCount + 16;
//    self.height = h;
//    
//    self.fixedHeight = @(h);
}

- (void)cancelImageBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(photoViewClickCancelImage:)]) {
        [self.delegate photoViewClickCancelImage:btn];
    }
}

@end
