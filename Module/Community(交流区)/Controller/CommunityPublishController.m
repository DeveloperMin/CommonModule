//
//  CommunityPublishController.m
//  TXBYKit-master
//
//  Created by Limmy on 2016/10/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//
#define margin 8
#define imageW (TXBYApplicationW - margin * 4)/3

#import "CommunityPublishController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CommunityParam.h"
#import "CommunitySelectView.h"
#import "CommunityGroup.h"

@interface CommunityPublishController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
/**
 *  标题cell
 */
@property (nonatomic, strong) UITableViewCell *titleCell;
/**
 *  分类cell
 */
@property (nonatomic, strong) UITableViewCell *classifyCell;
/**
 *  内容cell
 */
@property (nonatomic, strong) UITableViewCell *contentCell;
/**
 *  分类
 */
@property (nonatomic, weak) UILabel *classifyLabel;
/**
 *  placehold
 */
@property (nonatomic, weak) UILabel *placehold;
/**
 *  photosView
 */
@property (strong, nonatomic) UIView *photosView;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *images;
/**
 *  photoBtn
 */
@property (nonatomic, weak) UIButton *photoBtn;
/**
 *  titleField
 */
@property (nonatomic, strong) UITextField *titleField;
/**
 *  imgStr
 */
@property (nonatomic, copy) NSString *imgStr;
/**
 *  content
 */
@property (nonatomic, strong) UITextView *content;
/**
 *  自定义pickerView
 */
@property (nonatomic, weak) CommunitySelectView *pickerView;
/**
 *  默认选中的group
 */
@property (nonatomic, weak) CommunityGroup *selGroup;

@end

@implementation CommunityPublishController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initialView {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.groups.count > 1) {
        return 3;
    }
    return 2;
    //return 0;
}

#pragma mark - private
/**
 *  添加导航栏按钮
 */
- (void)setupNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"community.bundle/nav_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 18, 20);
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)clickBack {
    if (self.content.text.length || self.titleField.text.length) {
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
    // 移除pickerview
    [self removePickerView];
    // 取出文字
    NSString *title = self.titleField.text.trim;
    NSString *content = self.content.text.trim;
    // 输入校验
    if (title.length < 3 || title.length > 20) {
        [MBProgressHUD showInfo:@"标题3-20个字符" toView:self.view];
        return;
    } else if (content.length < 3) {
        [MBProgressHUD showInfo:@"内容不少于3个字符" toView:self.view];
        return;
    }
    
    // 关闭确定按钮交互
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [MBProgressHUD showMessage:@"正在发送" toView:self.view];
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
    NSString *title = self.titleField.text.trim;
    NSString *content = self.content.text.trim;
    
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        CommunityParam *param = [CommunityParam param];
        param.title = title;
        param.content = content;
        param.group = self.selGroup.ID;
        param.imgs = self.imgStr.encrypt;
        WeakSelf;
        [[TXBYHTTPSessionManager sharedManager] encryptPost:TXBYQuestAddAPI parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            if ([responseObject[@"errcode"] integerValue] == 0) {
                [MBProgressHUD showSuccess:@"提问成功" toView:self.view animated:YES];
                [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
            } else {
                TXBYAlert(responseObject[@"errmsg"]);
            }
        } failure:^(NSError *error) {
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            [MBProgressHUD hideHUDForView:self.view];
            [self requestFailure:error];
        }];
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        if (!self.titleCell) {
            self.titleCell = cell;
            [self setUpTitleCellContent];
        }
    } else {
        if (self.groups.count > 1) {
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!self.classifyCell) {
                    self.classifyCell = cell;
                    [self setUpClassfiyCellContent];
                }
            } else if (indexPath.row == 2) {
                if (!self.content) {
                    self.contentCell = cell;
                    [self setUpContentCellContent];
                }
            }
        } else {
            if (!self.contentCell) {
                self.contentCell = cell;
                [self setUpContentCellContent];
            }
        }
    }
    
    return cell;
}

- (void)setUpTitleCellContent {
    UITextField *titleField = [[UITextField alloc] init];
    self.titleField = titleField;
    titleField.textColor = [UIColor darkGrayColor];
    [self.titleCell addSubview:titleField];
    titleField.placeholder = @"输入标题";
    titleField.font = [UIFont boldSystemFontOfSize:16];
    [titleField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleCell.mas_left).offset(8);
        make.top.equalTo(self.titleCell.mas_top);
        make.right.equalTo(self.titleCell.mas_right).offset(-8);
        make.bottom.equalTo(self.titleCell.mas_bottom);
    }];
}

- (void)setUpClassfiyCellContent {
    UILabel *line = [UILabel new];
    line.backgroundColor = ESGlobalBgColor;
    [self.classifyCell addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classifyCell.mas_top);
        make.left.equalTo(self.classifyCell.mas_left);
        make.right.equalTo(self.classifyCell.mas_right);
        make.height.equalTo(1);
    }];
    
    UILabel *title = [UILabel new];
    self.classifyCell.backgroundColor = ESGlobalBgColor;
    [self.classifyCell addSubview:title];
    title.text = @"标签";
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor lightGrayColor];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classifyCell.mas_centerY);
        make.left.equalTo(self.classifyCell.mas_left).offset(8);
        make.width.equalTo(50);
    }];
    
    UILabel *classifyLabel = [UILabel new];
    self.classifyLabel = classifyLabel;
    classifyLabel.textColor = ESMainColor;
    // 设置默认值
    self.selGroup = self.groups[0];
    self.classifyLabel.text = self.selGroup.name;
    classifyLabel.textAlignment = NSTextAlignmentCenter;
    classifyLabel.font = [UIFont systemFontOfSize:18];
    [self.classifyCell.contentView addSubview:classifyLabel];
    [classifyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(20);
        make.centerY.equalTo(self.classifyCell.mas_centerY);
        make.right.equalTo(self.classifyCell.contentView.right);
        make.height.equalTo(30);
    }];
}

- (void)setUpContentCellContent {
    UILabel *line = [UILabel new];
    line.backgroundColor = ESGlobalBgColor;
    [self.contentCell addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentCell.mas_top);
        make.left.equalTo(self.contentCell.mas_left);
        make.right.equalTo(self.contentCell.mas_right);
        make.height.equalTo(1);
    }];
    
    UITextView *content = [UITextView new];
    self.content = content;
    content.delegate = self;
    content.returnKeyType = UIReturnKeyDone;
    content.font = [UIFont systemFontOfSize:16];
    content.textColor = [UIColor darkGrayColor];
    [self.contentCell.contentView addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentCell.mas_left).offset(8);
        make.right.equalTo(self.contentCell.mas_right).offset(-8);
        make.top.equalTo(self.contentCell.top);
        make.height.equalTo(120);
    }];
    
    UILabel *placehold = [UILabel new];
    self.placehold = placehold;
    [self.contentCell.contentView addSubview:placehold];
    placehold.textColor = [UIColor lightGrayColor];
    placehold.font = [UIFont systemFontOfSize:16];
    placehold.text = @"输入内容";
    [placehold makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content.mas_left).offset(5);
        make.top.equalTo(content.mas_top).offset(8);
    }];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn = photoBtn;
    [self.contentCell addSubview:photoBtn];
    [photoBtn setImage:[UIImage imageNamed:@"community.bundle/picture@3x.png"] forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"community.bundle/picture_highlighted@3x.png"] forState:UIControlStateHighlighted];
    [photoBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentCell.mas_right).offset(-8);
        make.bottom.equalTo(self.contentCell.mas_bottom).offset(-8);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    
    self.photosView = [UIView new];
    [self.contentCell.contentView addSubview:self.photosView];
    self.photosView.frame = CGRectMake(0, 128, TXBYApplicationW,imageW + 16);
    [self.photosView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentCell.mas_left);
        make.right.equalTo(self.contentCell.mas_right);
        make.height.equalTo(imageW + 16);
        make.top.equalTo(content.mas_bottom).offset(8);
    }];
    
    [self addChildImage];
}

- (void)addChildImage{
    [self.photosView removeAllSubviews];
    
    for (NSInteger i = 0; i < self.images.count; i++) {
        UIImageView *image = [[UIImageView alloc] init];
        image.userInteractionEnabled = YES;
        CGFloat imageX = (imageW + margin) * i +margin;
        // 取消按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(imageW - 20, 0, 20, 20);
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.alpha = 0.7;
        [btn setTitle:@"×" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:30];
        if (i < 3) {
            image.frame = CGRectMake(imageX, 8, imageW, imageW);
            [self.photosView addSubview:image];
            image.image = self.images[i];
            image.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
            [image addGestureRecognizer:tap];
            btn.tag = i;
            [image addSubview:btn];
        }
    }
}

- (void)bigImage:(UIGestureRecognizer *)tap {
    UIImageView *tapView = (UIImageView *)tap.view;
    int i= 0;
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
    
    [browser show];
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
    
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:ESMainColor] forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.barTintColor = ESMainColor;
    // 5. 显示控制器，由当前视图控制器负责展现照片选择控制器
    [self presentViewController:imagePicker animated:YES completion:nil];
    // 判断相机权限
    if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self alertForNoCameraAuthorization];
    }
}

- (void)addImage:(UIButton *)sender {
    // 结束编辑
    [self.view endEditing:YES];
    // 最简单的常见TXBYActionSheet方式
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"选择图片"];
    
    TXBYActionSheetItem *item1 = [TXBYActionSheetItem itemWithTitle:@"从相册选择" operation:^{
        [self showPhoto:0];
    }];
    TXBYActionSheetItem *item2 = [TXBYActionSheetItem itemWithTitle:@"拍照" operation:^{
        [self showPhoto:1];
    }];
    actionSheet.otherButtonItems = @[item1, item2];
    [actionSheet show];
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
        //[MBProgressHUD showInfo:@"图片过大, 请重新选取" toView:self.view];
        //// 4. 让当前控制器关闭照片选择控制器
        //[self dismissViewControllerAnimated:YES completion:nil];
        //return;
    }
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.5);
    UIImage *imageToUpload = [UIImage imageWithData:dataObj];
    [self.images addObject:[UIImage fixOrientation:imageToUpload]];
    if (self.images.count == 3) {
        self.photoBtn.hidden = YES;
    }
    
    [self addChildImage];
    
    // 4. 让当前控制器关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelImageBtn:(UIButton *)btn {
    if (self.images.count) {
        [self.images removeObjectAtIndex:btn.tag];
        if (self.images.count < 3) {
            self.photoBtn.hidden = NO;
        }
        [self addChildImage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.groups.count > 1) {
        if (indexPath.row == 2) {
            return 150 + imageW;
        }
        return 50;
    } else {
        if (indexPath.row == 1) {
            return 150 + imageW;
        }
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && self.groups.count > 1) {
        [self.view endEditing:YES];
        self.tableView.scrollEnabled = NO;
        self.content.userInteractionEnabled = NO;
        self.titleField.userInteractionEnabled = NO;
        self.photoBtn.enabled = NO;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
        CommunitySelectView *pickerView = [[CommunitySelectView alloc] init];
        pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView = pickerView;
        pickerView.defaultGroup = self.selGroup;
        pickerView.frame = CGRectMake(0, TXBYApplicationH, TXBYApplicationW , 260);
        [self.view addSubview:pickerView];
        pickerView.groups = self.groups;
        pickerView.commitBlock = ^(CommunityGroup *group) {
            if (group.name.length) {
                self.classifyLabel.text = group.name;
                self.selGroup = group;
            }
            [self removePickerView];
            self.photoBtn.enabled = YES;
            cell.userInteractionEnabled = YES;
            self.tableView.scrollEnabled = YES;
            self.content.userInteractionEnabled = YES;
            self.titleField.userInteractionEnabled = YES;
        };
        pickerView.cancelBlock = ^(){
            [self removePickerView];
            self.photoBtn.enabled = YES;
            cell.userInteractionEnabled = YES;
            self.tableView.scrollEnabled = YES;
            self.content.userInteractionEnabled = YES;
            self.titleField.userInteractionEnabled = YES;
        };
        
        [UIView animateWithDuration:0.3 animations:^{
            pickerView.txby_y = TXBYApplicationH - 260;
        }];
    }
}

- (void)removePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.txby_y = TXBYApplicationH;
    } completion:^(BOOL finished) {
        [self.pickerView removeFromSuperview];
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placehold.hidden = YES;
    } else {
        self.placehold.hidden = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.content resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
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
    return @"提问";
}

@end
