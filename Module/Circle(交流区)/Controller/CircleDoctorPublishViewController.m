//
//  CirclePublishViewController.m
//  txzjPatient
//
//  Created by Limmy on 2017/4/26.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "CircleDoctorPublishViewController.h"
#import "TXBYCircleModel.h"
#import "TXBYCircleReply.h"
#import "TXBYCircleParam.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "CircleTipsView.h"
#import "ChangeInfoParam.h"
#import "AccountTool.h"

@interface CircleDoctorPublishViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, CirclePublishPhotoViewDelegate, TZImagePickerControllerDelegate, CircleTipsViewDelegate>
//{
//    NSMutableArray *_selectedAssets;
//}
///**
// * photosView
// */
//@property (strong, nonatomic) CirclePublishPhotoView *photosView;
///**
// *  图片数组
// */
//@property (nonatomic, strong) NSMutableArray *images;
///**
// *  photoBtn
// */
//@property (nonatomic, strong) UIButton *photoBtn;
///**
// *  imgStr
// */
//@property (nonatomic, copy) NSString *imgStr;
///**
// *  content
// */
//@property (nonatomic, strong) UITextView *content;
///**
// *  placehold
// */
//@property (nonatomic, weak) UILabel *placehold;
///**
// *  headerView
// */
//@property (nonatomic, weak) UIView *headerView;
///**
// *  tipsView
// */
//@property (nonatomic, weak) CircleTipsView *tipsView;
/**
 *  textField
 */
@property (nonatomic, weak) UITextField *textField;

@end

@implementation CircleDoctorPublishViewController
- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"Circle.bundle/circle_addImage"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableView
    [self initialView];
    [self setupNavBarButton];
    _selectedAssets = [NSMutableArray array];
//    if (![AccountTool account].nick_name.length) {
//        [self setUpTipsView];
//    }
}

- (void)setUpTipsView {
    CircleTipsView *tipsView = [CircleTipsView new];
    tipsView.delegate = self;
    self.tipsView = tipsView;
    tipsView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH);
    [TXBYWindow.rootViewController.view addSubview:tipsView];
}

#pragma mark - CircleTipsViewDelegate
- (void)clickCircleTipsViewWithBtn:(UIButton *)btn nickName:(NSString *)nickName {
    if (btn.tag == 0) {
        [self.tipsView removeFromSuperview];
        [self popVc];
    } else {
        if (!nickName.length) {
            [MBProgressHUD showInfo:@"请您输入昵称" toView:self.tipsView];
            return;
        } else {
            [self.tipsView removeFromSuperview];
//            [self accountUnExpired:^{
//                [self modifyNickName:nickName];
//            }];
        }
    }
}

//- (void)modifyNickName:(NSString *)nickName {
//    ChangeInfoParam *param = [ChangeInfoParam param];
//    param.nick_name = nickName;
//    WeakSelf;
//    [MBProgressHUD showMessage:@"正在修改..." toView:selfWeak.view];
//    [[TXBYHTTPSessionManager sharedManager]encryptPost:TXBYUserNicknameModAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
//        
//        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
//        if ([responseObject[@"errcode"] intValue] ==[TXBYSuccessCode intValue]) {
//            [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
//            [MBProgressHUD showSuccess:@"修改成功" toView:selfWeak.view completion:^(BOOL finished) {
//                
//                Account *tempaccount = [AccountTool account];
//                if (param.nick_name) {
//                    tempaccount.nick_name = param.nick_name;
//                }
//                [AccountTool saveAccountExceptTime:tempaccount];
//            }];
//        }else{
//            [MBProgressHUD showInfo:responseObject[@"errmsg"] toView:selfWeak.view];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:selfWeak.view animated:YES];
//        [selfWeak requestFailure:error];
//    }];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
/**
 * 初始化view
 */
- (void)initialView {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = TXBYColor(245, 245, 245);
    // setUpHeaderView
    [self setUpHeaderView];
}

/**
 * setUpHeaderView
 */
- (void)setUpHeaderView {
    UIView *headerView = [UIView new];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *fieldView = [UIView new];
    if (self.circlePublishStyle == CirclePublishStyleCircle) {
        fieldView.backgroundColor = [UIColor whiteColor];
        fieldView.frame = CGRectMake(0, 0, TXBYApplicationW, 45);
        [self.headerView addSubview:fieldView];
        
        UITextField *textField = [UITextField new];
        self.textField = textField;
        textField.frame = CGRectMake(12, 0, TXBYApplicationW - 24, 44);
        textField.placeholder = @"请输入标题";
        textField.font = [UIFont systemFontOfSize:16];
        [fieldView addSubview:textField];
        
        UILabel *fieldLine = [UILabel new];
        fieldLine.frame = CGRectMake(0, 44, TXBYApplicationW, 1);
        fieldLine.backgroundColor = TXBYGlobalBgColor;
        [fieldView addSubview:fieldLine];
    }
    UITextView *content = [UITextView new];
    self.content = content;
    content.delegate = self;
    content.returnKeyType = UIReturnKeyDone;
    content.font = [UIFont systemFontOfSize:16];
    content.textColor = [UIColor darkGrayColor];
    [headerView addSubview:content];
    CGFloat contentY = CGRectGetMaxY(fieldView.frame);
    content.frame = CGRectMake(8, contentY, TXBYApplicationW - 16, 150);
    
    UILabel *placehold = [UILabel new];
    self.placehold = placehold;
    [headerView addSubview:placehold];
    placehold.textColor = TXBYColor(199, 199, 199);
    placehold.font = [UIFont systemFontOfSize:16];
    if (self.circlePublishStyle == CirclePublishStyleCircle) {
        placehold.text = @"请输入内容";
    } else {
        placehold.text = [NSString stringWithFormat:@"回复%@:", self.circleReply?self.circleReply.user_name:self.circleModel.user_name];
    }
    placehold.frame = CGRectMake(12, contentY + 7, 200, 21);
    
    [headerView addSubview:self.photoBtn];
    self.photoBtn.frame = CGRectMake(TXBYApplicationW - 38, CGRectGetMaxY(content.frame), 30, 30);
    
    // line
    UILabel *line = [UILabel new];
    line.backgroundColor = TXBYGlobalBgColor;
    [headerView addSubview:line];
    line.frame = CGRectMake(0, CGRectGetMaxY(self.photoBtn.frame) + 5, TXBYApplicationW, 1);
    
    self.photosView = [CirclePublishPhotoView new];
    [headerView addSubview:self.photosView];
    self.photosView.delegate = self;
    self.photosView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), TXBYApplicationW, 0);
    headerView.frame = CGRectMake(0, 0, TXBYApplicationW, CGRectGetMaxY(line.frame));
    self.photosView.circlePublishStyle = self.circlePublishStyle;
    self.photosView.hidden = YES;
    self.tableView.tableHeaderView = headerView;
}
/**
 *  添加导航栏按钮
 */
- (void)setupNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
}

- (void)clickBack {
    if (self.content.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否离开编辑界面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        [self.content resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)sendClick {
    // 结束编辑
    [self.view endEditing:YES];
    // 取出文字
    NSString *content = self.content.text.trim;
    NSString *title = self.textField.text.trim;
    // 输入校验
    if (self.circlePublishStyle == CirclePublishStyleCircle && self.isDoctorUser) {
        if (!title.length) {
            [MBProgressHUD showInfo:@"标题不能为空哦" toView:self.view];
            return;
        }
        if (title.length < 3) {
            [MBProgressHUD showInfo:@"标题不少于3个字" toView:self.view];
            return;
        }
        if (title.length > 20) {
            [MBProgressHUD showInfo:@"标题应不多于20个字" toView:self.view];
            return;
        }
    }
    if (!content.length) {
        [MBProgressHUD showInfo:@"内容不能为空哦" toView:self.view];
        return;
    }
    if (content.length < 3) {
        [MBProgressHUD showInfo:@"内容不少于3个字" toView:self.view];
        return;
    }
    if (content.length > 2000) {
        [MBProgressHUD showInfo:@"内容应不多于2000个字" toView:self.view];
        return;
    }
    
    // 关闭确定按钮交互
    [MBProgressHUD showMessage:@"请稍候..." toView:self.view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (self.images.count) {
        [self uploadImage];
    } else {
        if (self.circlePublishStyle == CirclePublishStyleReply) {
            [self replyCircle];
        } else {
            [self createCircle];
        }
    }
}

- (void)uploadImage {
    // 请求参数
    TXBYCircleParam *param = [TXBYCircleParam param];
    param.act = @"multi";
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager POST:TXBYCommunityUploadImageAPI parameters:param.mj_keyValues constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < self.images.count; i++) {
            UIImage *image = self.images[i];
            NSString *fileStr, *name, *mimeType;
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            NSString *imageFileName = fileStr;
            if (fileStr == nil || ![fileStr isKindOfClass:[NSString class]] || fileStr.length == 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@%ld.png", str, (long)i];
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
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"errcode"] integerValue] == 0) {
            NSArray *imgs = responseObject[@"result"];
            self.imgStr = [imgs componentsJoinedByString:@"|"];
            if (self.circlePublishStyle == CirclePublishStyleReply) {
                [self replyCircle];
            } else {
                [self createCircle];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self requestFailure:error];
        [MBProgressHUD hideHUDForView:self.view];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }];
}

- (void)addImage:(UIButton *)sender {
    // 结束编辑
    [self.view endEditing:YES];
    // 最简单的常见TXBYActionSheet方式
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"选择图片"];
    
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"从相册选择" operation:^{
        [self pushImagePickerController];
//        [self showPhoto:0];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"拍照" operation:^{
        [self showPhoto:1];
    }];
    actionSheet.otherButtonItems = @[item1, item2];
    [actionSheet show];
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    NSInteger maxPhotoCount = 9 - self.images.count;
    if (self.circlePublishStyle == CirclePublishStyleReply) {
        maxPhotoCount = 3 - self.images.count;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.naviBgColor = TXBYMainColor;
    imagePickerVc.oKButtonTitleColorNormal = TXBYMainColor;
    imagePickerVc.oKButtonTitleColorDisabled = TXBYColor(200, 200, 200);
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    if (maxPhotoCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    // 5. Single selection mode, valid when maxImagesCount = 1
    // 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *newPhotos = [NSMutableArray array];
    for (UIImage *photo in photos) {
        UIImage *newPhoto = photo;
        if (photo.size.width > 1080) {
            newPhoto = [UIImage compressImage:photo newWidth:1080];
        }
        NSData *dataObj = UIImageJPEGRepresentation(newPhoto, 0.5);
        UIImage *imageToUpload = [UIImage imageWithData:dataObj];
        [newPhotos addObject:imageToUpload];
    }
    [self.images addObjectsFromArray:newPhotos];
    [self setUpPhotoView];
}

/**
 *  从相册选择
 */
- (void)showPhoto:(NSInteger)index {
    // 要选择头像，需要使用UIImagePickerController
    // 实例化照片选择控制器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
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
    [imagePicker setAllowsEditing:NO];
    
    // 4. 设置代理
    imagePicker.delegate = self;
    
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:TXBYMainColor] forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.barTintColor = TXBYMainColor;
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
    // 1. 取出图像
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    if (image.size.width > 1080) {
        image = [UIImage compressImage:image newWidth:1080];
//        [MBProgressHUD showInfo:@"图片过大, 请重新选取" toView:self.view];
        //// 4. 让当前控制器关闭照片选择控制器
        //[self dismissViewControllerAnimated:YES completion:nil];
        //return;
    }
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.5);
    UIImage *imageToUpload = [UIImage imageWithData:dataObj];
    [self.images addObject:[UIImage fixOrientation:imageToUpload]];
    [self setUpPhotoView];
    
    // 4. 让当前控制器关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CirclePublishPhotoViewDelegate
- (void)photoViewClickCancelImage:(UIButton *)btn {
    [self.images removeObjectAtIndex:btn.tag];
    self.photoBtn.hidden = NO;
    [self setUpPhotoView];
}

- (void)setUpPhotoView {
    if (self.circlePublishStyle == CirclePublishStyleReply && self.images.count == 3) {
        self.photoBtn.hidden = YES;
    } else if(self.circlePublishStyle == CirclePublishStyleCircle && self.images.count == 9) {
        self.photoBtn.hidden = YES;
    }
    CGFloat margin = 12;
    NSInteger cols;
    if (self.circlePublishStyle == CirclePublishStyleReply) {
        cols = 3;
    } else {
        cols = 4;
    }
    NSInteger row = (self.images.count - 1) / cols;
    CGFloat imageH = (TXBYApplicationW - margin * (cols + 1))/cols;
    CGFloat photoViewH = (row + 1) * (margin + imageH) + margin;
    if (self.images.count) {
        self.photosView.txby_height = photoViewH;
    } else {
        self.photosView.txby_height = 0;
    }
    self.photosView.hidden = NO;
    self.headerView.txby_height = CGRectGetMaxY(self.photosView.frame);
    self.photosView.images = self.images;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.content resignFirstResponder];
        [self.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

/**
 *  发表按钮点击事件
 */
- (void)createCircle {
    // 取出文字
    NSString *content = self.content.text.trim;
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        TXBYCircleParam *param = [TXBYCircleParam param];
        if (self.isDoctorUser) {
            param.title = self.textField.text.trim;
        } else {
            param.title = @"发布圈子";
        }
        param.content = content;
        param.imgs = self.imgStr;
        param.group = @"1";
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionCreateAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            if ([responseObject[@"errcode"] integerValue] == 0) {
                if (selfWeak.createSuccessBlock) {
                    selfWeak.createSuccessBlock();
                }
                [MBProgressHUD showSuccess:@"提问成功" toView:self.view animated:YES];
                [selfWeak performSelector:@selector(popVc) withObject:nil afterDelay:1.5];
            } else { // 注册失败
                TXBYAlert(responseObject[@"errmsg"]);
            }
        } failure:^(NSError *error) {
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:self.view];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

/**
 *  发表按钮点击事件
 */
- (void)replyCircle {
    // 取出文字
    NSString *content = self.content.text.trim;
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        TXBYCircleParam *param = [TXBYCircleParam param];
        if (self.circleReply) {
            // 如果 questionReply 存在，说明是回复评论，即现在是二级评论
            // 需要传问题 ID
            param.ID = self.circleModel.ID;
            // 要回复的评论的ID
            param.parent_id = self.circleReply.ID;
            // 一级评论的ID
            if (self.circleReply.parent_id.length) {
                // 如果评论的父ID存在，说明要评论的评论时也是二级评论，则是@某人
                // @那人的ID
                param.at_uid = self.circleReply.uid;
                // 要回复的评论的ID，这里需要传一级评论的 ID
                param.parent_id = self.circleReply.parent_id;
            }
        } else if (self.circleModel) {
            // 回复问题
            param.ID = self.circleModel.ID;
        }
        param.imgs = self.imgStr;
        param.content = content;
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestionReplyAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            // 返回结果对象
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
            if ([responseObject[@"errcode"] integerValue] == 0) {
                if (selfWeak.replySuccessBlock) {
                    selfWeak.replySuccessBlock();
                }
                [MBProgressHUD showSuccess:@"回复成功" toView:self.view animated:YES];
                [selfWeak performSelector:@selector(popVc) withObject:nil afterDelay:1.5];
            } else { // 注册失败
                TXBYAlert(responseObject[@"errmsg"]);
            }
        } failure:^(NSError *error) {
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            selfWeak.navigationItem.leftBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [MBProgressHUD hideHUDForView:self.view];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

- (void)popVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placehold.hidden = YES;
    } else {
        self.placehold.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (NSString *)title {
    if (self.circleModel || self.circlePublishStyle == CirclePublishStyleReply) {
        return @"回复";
    } else {
        return @"提问";
    }
}

@end
