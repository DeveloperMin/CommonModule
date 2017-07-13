//
//  CommunityCommentController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#define margin 8
#define imageW (TXBYApplicationW - 16 - margin * 2)/3

#import "CommunityCommentController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CommunityParam.h"
#import "CommunityListCell.h"
#import "CommunityToolBar.h"

@interface CommunityCommentController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
/**
 *  placehold
 */
@property (nonatomic, weak) UILabel *placehold;
/**
 *  工具条
 */
@property (nonatomic, weak) UIView *toolView;
/**
 *  photoView
 */
@property (nonatomic, strong) UIView *photosView;
/**
 *  上传图片的str
 */
@property (nonatomic, copy) NSString *imgStr;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *images;
/**
 *  contentView
 */
@property (nonatomic, weak) UITextView *contentView;
/**
 *  tableview
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  headerView
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  communityCell
 */
@property (nonatomic, strong) UITableViewCell *commentCell;

@end

@implementation CommunityCommentController

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBarFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 创建tableView
    [self setUpTableView];
    // 创建view
    //[self setUpViews];
    // 创建navitem
    [self setupNavBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contentView becomeFirstResponder];
}

- (void)toolBarFrameChange:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y == self.view.txby_height + 64) { //没有弹出键盘
        [UIView animateWithDuration:duration animations:^{
            [self.toolView updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            [self.toolView updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-frame.size.height);
            }];
            self.tableView.contentOffset = CGPointMake(0, self.communityCellFrame.cellHeight - 30);
        }];
    }
}

- (void)setUpTableView {
    self.tableView = [UITableView new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 创建cell
        static NSString *CellIdentifier = @"CommunityListCell";
        CommunityListCell *cell = [CommunityListCell cellWithTableView:tableView classString:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellFrame = self.communityCellFrame;
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[CommunityToolBar class]]) {
                [view removeFromSuperview];
                break;
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.commentCell = cell;
        // 创建view
        [self setUpViews];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.communityCellFrame.cellHeight - 30;
    }
    return self.view.txby_height * 0.25 + imageW + 16;
}

- (void)setUpViews {
    UILabel *square = [UILabel new];
    square.frame = CGRectMake(20, 4, 20, 20);
    square.backgroundColor = TXBYColor(235, 235, 235);
    [self.commentCell.contentView addSubview:square];
    square.transform = CGAffineTransformMakeRotation(95.0);
    
    self.photosView = [UIView new];
    [self.commentCell.contentView addSubview:self.photosView];
    [self.photosView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentCell.contentView.mas_bottom).offset(20);
        make.left.equalTo(self.commentCell.contentView.mas_left).offset(8);
        make.right.equalTo(self.commentCell.contentView.mas_right).offset(-8);
        make.height.equalTo(imageW + 16);
    }];
    
    UITextView *contentView = [UITextView new];
    self.contentView = contentView;
    [self.commentCell.contentView addSubview:contentView];
    contentView.backgroundColor = TXBYColor(235, 235, 235);
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 5;
    contentView.delegate = self;
    contentView.font = [UIFont systemFontOfSize:16];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentCell.contentView.mas_left).offset(8);
        make.right.equalTo(self.commentCell.contentView.mas_right).offset(-8);
        make.top.equalTo(self.commentCell.contentView.mas_top).offset(8);
        make.bottom.equalTo(self.photosView.mas_top);
    }];
    
    UILabel *placehold = [UILabel new];
    self.placehold = placehold;
    placehold.font = [UIFont systemFontOfSize:16];
    placehold.textColor = [UIColor darkGrayColor];
    placehold.text = @"写评论...";
    [self.commentCell.contentView addSubview:placehold];
    [placehold makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentCell.contentView.mas_top).offset(15);
        make.left.equalTo(self.commentCell.contentView.mas_left).offset(10);
    }];
    
    UIView *toolView = [UIView new];
    self.toolView = toolView;
    [self.view addSubview:toolView];
    toolView.backgroundColor = ESGlobalBgColor;
    [toolView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(40);
    }];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:cameraBtn];
    cameraBtn.tag = 0;
    [cameraBtn addTarget: self action:@selector(clickToolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setImage:[UIImage imageNamed:@"community.bundle/camera@2x.png"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"community.bundle/camera_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [cameraBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView.mas_centerY);
        make.left.equalTo(toolView.mas_left).offset(12);
        make.width.equalTo(24);
        make.height.equalTo(24);
    }];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:photoBtn];
    photoBtn.tag = 1;
    [photoBtn addTarget: self action:@selector(clickToolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setImage:[UIImage imageNamed:@"community.bundle/picture@3x.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"community.bundle/picture_highlighted@3x.png"] forState:UIControlStateHighlighted];
    [photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView.mas_centerY);
        make.left.equalTo(cameraBtn.mas_right).offset(22);
        make.width.equalTo(24);
        make.height.equalTo(24);
    }];
}

#pragma mark - private
/**
 *  添加导航栏按钮
 */
- (void)setupNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
}

- (void)sendClick {
    // 结束编辑
    [self.view endEditing:YES];
    if (!self.contentView.text.length || self.contentView.text.length < 3) {
        [MBProgressHUD showInfo:@"评论内容不少于3个字符" toView:self.view];
        return;
    }
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
    // 关闭确定按钮交互
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.images.count) {
        [self uploadImage];
    } else {
        [self sendContent];
    }
}

- (void)uploadImage {
    // 请求参数
    CommunityParam *param = [CommunityParam param];
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
            NSString *str = imgs.mj_JSONString;
            self.imgStr = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            [self sendContent];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self sendContent];
    }];
}

/**
 *  发表按钮点击事件
 */
- (void)sendContent {
    // 取出文字
    NSString *content = self.contentView.text.trim;
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        CommunityParam *param = [CommunityParam param];
        param.quest_id = self.communityCellFrame.communityItem.ID;
        param.imgs = self.imgStr.encrypt;
        param.content = content;
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestReplyAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            if ([responseObject[@"errcode"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"发送成功" toView:self.view animated:YES];
                [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
            } else {
                TXBYAlert(responseObject[@"errmsg"]);
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [self requestFailure:error];
        }];
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addChildImage{
    [self.photosView removeAllSubviews];
    
    for (NSInteger i = 0; i < self.images.count + 1; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.userInteractionEnabled = YES;
        CGFloat imageX = (imageW + margin) * i;
        // 取消按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(imageW - 20, 0, 20, 20);
        [btn setBackgroundColor:[UIColor darkGrayColor]];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.alpha = 0.7;
        [btn setTitle:@"×" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:30];
        if (i < 3) {
            image.frame = CGRectMake(imageX, 8, imageW, imageW);
            [self.photosView addSubview:image];
            if (i < 3 && i == self.images.count) {
                image.image = [UIImage imageNamed:@"community.bundle/compose_pic_add@3x.png"];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
                [image addGestureRecognizer:tap];
            } else {
                image.image = self.images[i];
                image.tag = i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
                [image addGestureRecognizer:tap];
                btn.tag = i;
                [image addSubview:btn];
            }
        }
    }
}

- (void)addImage {
    [self.view endEditing:YES];
    // 最简单的常见TXBYActionSheet方式
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"选择图片"];
    
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"从相册选择" operation:^{
        [self showPhoto:1];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"拍照" operation:^{
        [self showPhoto:0];
    }];
    actionSheet.otherButtonItems = @[item1, item2];
    [actionSheet show];
}

- (void)cancelImageBtn:(UIButton *)btn {
    if (self.images.count) {
        [self.images removeObjectAtIndex:btn.tag];
        [self addChildImage];
    }
}

- (void)clickToolBarBtn:(UIButton *)btn {
    if (btn.tag == 0) {
        [self showPhoto:0];
    } else {
        [self showPhoto:1];
    }
}

/**
 *  从相册选择
 */
- (void)showPhoto:(NSInteger)index {
    if (self.images.count == 3) {
        // 4. 让当前控制器关闭照片选择控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showInfo:@"最多只能添加三张图片" toView:self.view];
        return;
    }
    // 要选择头像，需要使用UIImagePickerController
    // 实例化照片选择控制器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    // 设置照片源
    if (!index) { // 拍照
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
    
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:ESMainColor] forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.barTintColor = ESMainColor;
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
    }
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.5);
    UIImage *imageToUpload = [UIImage imageWithData:dataObj];
    [self.images addObject:[UIImage fixOrientation:imageToUpload]];
    
    [self addChildImage];
    
    // 4. 让当前控制器关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bigImage:(UIGestureRecognizer *)tap {
    UIImageView *tapView = (UIImageView *)tap.view;
    int i= 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (UIImage *image in self.images) {
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.image = image;
        mjphoto.index = i;
        mjphoto.srcImageView = tapView;
        [tempArray addObject:mjphoto];
        i++;
    }
    //创建图片浏览器对象
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //MJPhoto
    browser.photos = tempArray;
    browser.currentPhotoIndex = tapView.tag;
    
    [browser show];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placehold.hidden = YES;
        //CGFloat textH = [textView.text sizeWithFont:[UIFont systemFontOfSize:16] maxW:TXBYApplicationW - 25].height;
        //CGFloat offSetH = textH - textView.txby_height;
        //NSLog(@"%lf---%lf", textH, textView.txby_height);
        //if (offSetH > 0) {
            //self.headerView.txby_height = textH + imageW + 5;
            //self.scrollView.contentSize = CGSizeMake(TXBYApplicationW, self.headerView.txby_height);
        //}
    } else {
        self.placehold.hidden = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        ////在这里做你响应return键的代码
        //[self.view endEditing:YES];
        //return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    //}
    //return YES;
//}

- (NSString *)title {
    return @"发评论";
}


@end
