//
//  MyStepViewController.m
//  publicCommon
//
//  Created by Limmy on 2017/2/15.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "MyStepViewController.h"
#import "StepParam.h"
#import "saoSeven.h"
#import "AccountTool.h"

#define HeadViewHeight TXBYApplicationH * 0.42

@interface MyStepViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/**
 *  当前view
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  头部背景图
 */
@property (nonatomic, strong) UIImageView *headBackImgView;
/**
 *  chatView
 */
@property (nonatomic, strong) UIView *chatView;
/**
 *  x轴数据
 */
@property (nonatomic, strong) NSMutableArray *dataX;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *data;

/**
 *  allStep
 */
@property (nonatomic, assign) NSInteger allStep;

@end

@implementation MyStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化view
    [self initalView];
    // 获取一周数据
    [self requestList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  网络请求
 */
- (void)requestList {
    [self accountUnExpired:^{
        // 请求参数
        StepParam *param = [StepParam param];
        param.date = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
        param.uid = self.myModel.uid;
        WeakSelf;
        // 发送请求
//        [MBProgressHUD showMessage:@"加载中..." toView:selfWeak.view];
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYWeekStepListStepAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:selfWeak.view];
            if ([responseObject[@"errcode"] integerValue] == 0) {
                NSMutableArray *array1 = [NSMutableArray array];
                NSMutableArray *array2 = [NSMutableArray array];
                int i = 0;
                for (NSDictionary *dict in responseObject[@"data"]) {
                    if (i == 0) {
                        [array1 addObject:[dict[@"date"] substringFromIndex:5]];
                    } else {
                        [array1 addObject:[dict[@"date"] substringFromIndex:8]];
                    }
                    self.allStep += [dict[@"step"] integerValue];
                    [array2 addObject:dict[@"step"]];
                    i++;
                }
                self.data = array2;
                self.dataX = array1;
                [self setUpChatView];
            }
        } failure:^(NSError *error) {
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:selfWeak.view];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

- (void)initalView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(HeadViewHeight, 0, 0, 0);
    // 创建头部视图
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.headerView];
    self.headerView.frame = CGRectMake(0, -HeadViewHeight, TXBYApplicationW, HeadViewHeight);
    
    // 创建头部视图的背景图
    self.headBackImgView = [[UIImageView alloc] init];
    [self.headBackImgView sd_setImageWithURL:[NSURL URLWithString:self.myModel.background] placeholderImage:[UIImage imageNamed:@"myStep.bundle/stepbg"]];
    self.headBackImgView.contentMode = UIViewContentModeScaleToFill;
    self.headBackImgView.clipsToBounds = YES;
    [self.headerView addSubview:self.headBackImgView];
    [self.headBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.left);
        make.right.equalTo(self.headerView.right);
        make.top.equalTo(self.headerView.top);
        make.bottom.equalTo(self.headerView.bottom);
    }];
    self.headBackImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackImgView)];
    if (self.myModel.uid.integerValue == [AccountTool account].uid.integerValue) {
        [self.headBackImgView addGestureRecognizer:tap];
    }
    
    UIImageView *myImage = [UIImageView new];
    [self.tableView addSubview:myImage];
    [myImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.centerX);
        make.centerY.equalTo(self.headBackImgView.bottom);
        make.width.equalTo(60);
        make.height.equalTo(60);
    }];
    myImage.layer.masksToBounds = YES;
    myImage.layer.cornerRadius = 30;
    myImage.layer.borderWidth = 2;
    myImage.layer.borderColor = [UIColor colorWithWhite:255 alpha:0.2].CGColor;
    [myImage sd_setImageWithURL:[NSURL URLWithString:self.myModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    // 创建chatView
    [self setUpChatView];
}

- (void)clickBackImgView {
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"修改背景"];
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"从相册选择" operation:^{
        [self showPhoto:0];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"拍照" operation:^{
        [self showPhoto:1];
    }];
    actionSheet.otherButtonItems = @[item1, item2];
    [actionSheet show];
}

/**
 *  从相册选择
 */
- (void)showPhoto:(NSInteger)index {
    // 要选择头像，需要使用UIImagePickerController
    // 实例化照片选择控制器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:TXBYMainColor] forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.barTintColor = TXBYMainColor;
    [imagePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 设置照片源
    if (index) { // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [MBProgressHUD showInfo:@"相机不可用" toView:self.view];
        }
    } else { // 从相册选择
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // 3. 设置是否允许编辑
    [imagePicker setAllowsEditing:YES];
    
    // 4. 设置代理
    [imagePicker setDelegate:self];
    
    // 5. 显示控制器，由当前视图控制器负责展现照片选择控制器
    [self presentViewController:imagePicker animated:YES completion:nil];
    // 判断相机权限
    if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self alertForNoCameraAuthorization];
    }
}

#pragma mark － UIImagePickerControllerDelegate
/**
 *  实现了这一代理方法之后，需要手动关闭照片选择控制器
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 取出图像
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    // 按比例裁剪照片
    image = [self cutImage:image];
    // 处理头像上传
    [self formatAvatarWithImage:image];
    self.headBackImgView.image = image;
    
    // 让当前控制器关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


//裁剪图片
- (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (self.headBackImgView.txby_width / self.headBackImgView.txby_height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * self.headBackImgView.txby_height / self.headBackImgView.txby_width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * self.headBackImgView.txby_width / self.headBackImgView.txby_height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

/**
 *  处理头像上传
 */
- (void)formatAvatarWithImage:(UIImage *)image {
    // 请求参数
    StepParam *param = [StepParam param];
    param.act = @"multi";
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [MBProgressHUD showMessage:@"图片上传中..." toView:self.view];
    [sessionManager POST:TXBYCommunityUploadImageAPI parameters:param.mj_keyValues constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileStr, *name, *mimeType;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = fileStr;
        if (fileStr == nil || ![fileStr isKindOfClass:[NSString class]] || fileStr.length == 0) {
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
            fileName = @"file[]";
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:fileName fileName:imageFileName mimeType:imageMineType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            NSArray *imgs = responseObject[@"result"][0];
            NSString *str = imgs.mj_JSONString;
            str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            // 修改头像
            [self checkAccount:str];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showInfo:@"上传失败,请稍候重试" toView:self.view];
        NSLog(@"%@", error);
    }];
}

/**
 *  检查账号是否过期
 */
- (void)checkAccount:(NSString *)img {
    [self accountUnExpired:^{
        [self updateAvatar:img];
    }];
}

/**
 *  修改头像
 */
- (void)updateAvatar:(NSString *)img {
    // 请求参数
    StepParam *param = [StepParam param];
    param.background = img;
    WeakSelf;
    // 修改请求
    [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYUploadStepBackImgeAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([responseObject[@"errcode"] integerValue] == 0) {
            [MBProgressHUD showSuccess:@"背景设置成功" toView:selfWeak.view];
            if([self.delegate respondsToSelector:@selector(updateStepViewData)]) {
                [self.delegate updateStepViewData];
            }
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 错误提示
        [selfWeak requestFailure:error];
    }];
}

- (void)setUpChatView {
    [self.chatView removeAllSubviews];
    
    UIView *chatView = [UIView new];
    self.chatView = chatView;
    chatView.frame = CGRectMake(10, 50, TXBYApplicationW - 20, (TXBYApplicationW - 20) * 0.6);
    chatView.layer.cornerRadius = 8;
    chatView.layer.masksToBounds = YES;
    [self.tableView addSubview:chatView];
    
    saoSeven *sView=[[saoSeven alloc]initWithFrame:CGRectMake(0, 0, chatView.txby_width, chatView.txby_height)];
    
    sView.title = @"周";
    sView.backgroundColor = TXBYColor(104, 176, 247);
    CGFloat max = 0;
    for (NSString *str in self.data) {
        if (max < str.floatValue) {
            max = str.floatValue;
        }
    }
    sView.number = [NSString stringWithFormat:@"%ld", (long)(NSInteger)(1.1 * max)];
    sView.rightTitle = [NSString stringWithFormat:@"步数: %ld", (long)self.allStep];
    if (max == 0) {
        self.data = nil;
    }
    sView.array = self.data;
    sView.dataX = self.dataX;
    sView.count = [NSString stringWithFormat:@"%lu",(unsigned long)self.data.count];
    [chatView addSubview:sView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y + HeadViewHeight;
    
    // 2.设置图片的拉伸效果
    // 向上的阻力系数（值越大，阻力越大，向上的力越大）
    CGFloat upFactor = 0.6;
    
    if (offsetY > 0) {
        // 将图片恢复原状
        self.headBackImgView.transform = CGAffineTransformIdentity;
        return;
    }
    
    // 到什么位置开始放大
    CGFloat upMin = 0;
    
    // 还没到顶部位置，就向上挪动
    if (offsetY >= upMin) {
        self.headBackImgView.transform = CGAffineTransformMakeTranslation(0, offsetY * upFactor);
    }
    else {
        // 中点位置
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offsetY - upMin * (upFactor));
        // 图片在x轴的放大比例
        CGFloat scaleX = 1 + (upMin - offsetY) * 0.005;
        // 图片在y轴的放大比例
        CGFloat scaleY = -(offsetY * 2 - (HeadViewHeight)) / (HeadViewHeight);
        self.headBackImgView.transform = CGAffineTransformScale(transform, scaleX, scaleY);
    }
}

- (NSString *)title {
    if ([AccountTool account].uid.integerValue == self.myModel.uid.integerValue) {
        return @"我的主页";
    }
    return [NSString stringWithFormat:@"%@的主页", self.myModel.name.length?self.myModel.name:@""];
}
@end
