//
//  QuestionCreateController.m
//  publicCommon
//
//  Created by hj on 17/2/20.
//  Copyright © 2017年 txby. All rights reserved.
//

#import "QuestionCreateController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "QuestionTool.h"
#import "QuestionListController.h"
#import "QuestionDetailController.h"
#import "Question.h"
#import "QuestionReply.h"
#import "QuestionTipsView.h"
#import "AccountTool.h"
#import "MeTool.h"

#define margin 8
#define imageW (TXBYApplicationW - margin * 4)/3
#define maxImageCount 3

@interface QuestionCreateController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate,QuestionTipsViewDelegate>

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
@property (nonatomic, strong) UIButton *photoBtn;
/**
 *  imgStr
 */
@property (nonatomic, copy) NSString *imgStr;
/**
 *  content
 */
@property (nonatomic, strong) UITextView *content;

@property (nonatomic, strong) MBProgressHUD *hud;
/**
 *  tipsView
 */
@property (nonatomic, weak) QuestionTipsView *tipsView;

@end

@implementation QuestionCreateController

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setImage:[UIImage imageNamed:@"Question.bundle/question_addImage_icon"] forState:UIControlStateNormal];
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

    if (![AccountTool account].nick_name.length) {
        [self setUpTipsView];
    }
}

- (void)setUpTipsView {
    QuestionTipsView *tipsView = [QuestionTipsView new];
    tipsView.delegate = self;
    self.tipsView = tipsView;
    tipsView.frame = CGRectMake(0, 0, TXBYApplicationW, TXBYApplicationH);
    [TXBYWindow.rootViewController.view addSubview:tipsView];
}

- (void)modifyNickName:(NSString *)nickname {
    MeParam *param = [MeParam param];
    param.nick_name = nickname;
    WeakSelf;
    [MBProgressHUD showMessage:@"请稍候..." toView:selfWeak.view];
    
    [MeTool updateNicknameWithParam:param netIdentifier:TXBYClassName success:^(MeResult *result) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        if ([result.errcode isEqualToString:TXBYSuccessCode]) {
            // 提示修改结果
            [MBProgressHUD showSuccess:@"昵称添加成功" toView:selfWeak.view completion:^(BOOL finished) {
            } animated:YES];
            // 修改帐号
            Account *account = [AccountTool account];
            account.nick_name = nickname;
            [AccountTool saveAccountExceptTime:account];
        } else {
            // 提示修改结果
            [MBProgressHUD showInfo:result.errmsg toView:selfWeak.view];
        }
    } failure:^(NSError *error) {
        // 隐藏加载提示
        [MBProgressHUD hideHUDForView:selfWeak.view];
        // 网络加载失败
        [selfWeak requestFailure:error];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = TXBYColor(245, 245, 245);
    
    UIButton *btn = self.navigationItem.leftBarButtonItem.customView;
    [btn removeTarget:self.navigationController action:NULL forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initialView {
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        if (self.images.count == maxImageCount) {
            return 1;
        }
        return 2;
    }
    return 1;
}

#pragma mark - private
/**
 *  添加导航栏按钮
 */
- (void)setupNavBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
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
    // 移除pickerview
    [self removePickerView];
    // 取出文字
    NSString *content = self.content.text.trim;
    // 输入校验
    if (content.length < 3) {
        [MBProgressHUD showInfo:@"内容不少于3个字符" toView:self.view];
        return;
    }
    
    // 关闭确定按钮交互
    self.hud = [MBProgressHUD showMessage:@"发送中，请稍候" toView:self.view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.images.count) {
        [self uploadImage];
        return;
    } else {
        if (self.question || self.questionReply) {
            [self replyQuestion];
        } else {
            [self createQuestion];
        }
    }
}

- (void)uploadImage {
    WeakSelf;
    // 请求参数
    QuestionParam *param = [QuestionParam param];
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
            if (self.question || self.questionReply) {
                [self replyQuestion];
            } else {
                [self createQuestion];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏加载提示
        [selfWeak.hud hide:YES];
        // 网络加载失败
        [selfWeak requestFailure:error];
        selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

/**
 *  发表按钮点击事件
 */
- (void)createQuestion {
    // 取出文字
    NSString *content = self.content.text.trim;
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        QuestionParam *param = [QuestionParam param];
        param.title = @"药师服务";
        param.content = content;
        param.imgs = self.imgStr;
        param.group = @"2";
        WeakSelf;
        [QuestionTool createQuestionWithParam:param netIdentifier:TXBYClassName success:^(QuestionResult *result) {
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [selfWeak.hud hide:YES];
            if ([result.errcode isEqualToString:TXBYSuccessCode]) {
                if (selfWeak.createSuccessBlock) {
                    selfWeak.createSuccessBlock();
                }
                // 更新列表数据
                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[QuestionListController class]]) {
                        QuestionListController *questionListController = (QuestionListController *)vc;
                        [questionListController updateList];
                    }
                    if ([vc isKindOfClass:[QuestionDetailController class]]) {
                        QuestionDetailController *questionDetailController = (QuestionDetailController *)vc;
                        [questionDetailController updateList];
                    }
                }
                [MBProgressHUD showSuccess:@"提问成功" toView:self.view animated:YES];
                [selfWeak performSelector:@selector(pop) withObject:nil afterDelay:1.5];
            } else { // 注册失败
                TXBYAlert(result.errmsg);
            }
        } failure:^(NSError *error) {
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [selfWeak.hud hide:YES];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

/**
 *  发表按钮点击事件
 */
- (void)replyQuestion {
    // 取出文字
    NSString *content = self.content.text.trim;
    // 检查账号
    [self accountUnExpired:^{
        // 请求参数
        QuestionParam *param = [QuestionParam param];
        if (self.questionReply) {
            // 如果 questionReply 存在，说明是回复评论，即现在是二级评论
            
            // 需要传问题 ID
            param.ID = self.question.ID;
            
            // 要回复的评论的ID
            param.parent_id = self.questionReply.ID;
            
            // 一级评论的ID
            if (self.questionReply.parent_id.length) {
                // 如果评论的父ID存在，说明要评论的评论时也是二级评论，则是@某人
                
                // @那人的ID
                param.at_uid = self.questionReply.uid;
                // 要回复的评论的ID，这里需要传一级评论的 ID
                param.parent_id = self.questionReply.parent_id;
            }
        } else if (self.question) {
            // 回复问题
            param.ID = self.question.ID;
        }
        param.imgs = self.imgStr;
        param.content = content;
        WeakSelf;
        [QuestionTool replyQuestionWithParam:param netIdentifier:TXBYClassName success:^(QuestionResult *result) {
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [selfWeak.hud hide:YES];
            if ([result.errcode isEqualToString:TXBYSuccessCode]) {
                if (selfWeak.replySuccessBlock) {
                    selfWeak.replySuccessBlock();
                }
                // 更新列表数据
                for (UIViewController *vc in selfWeak.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[QuestionListController class]]) {
                        QuestionListController *questionListController = (QuestionListController *)vc;
                        [questionListController updateList];
                    } else if ([vc isKindOfClass:[QuestionDetailController class]]) {
                        QuestionDetailController *questionDetailController = (QuestionDetailController *)vc;
                        [questionDetailController updateList];
                    }
                }
                [MBProgressHUD showSuccess:@"回复成功" toView:self.view animated:YES];
                [selfWeak performSelector:@selector(pop) withObject:nil afterDelay:1.5];
            } else { // 注册失败
                TXBYAlert(result.errmsg);
            }
        } failure:^(NSError *error) {
            // 开启确定按钮交互
            selfWeak.navigationItem.rightBarButtonItem.enabled = YES;
            // 隐藏加载提示
            [selfWeak.hud hide:YES];
            // 网络加载失败
            [selfWeak requestFailure:error];
        }];
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        if (indexPath.row == 1) {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            cell.imageView.image = [UIImage imageNamed:@"Question.bundle/question_addImage_icon"];
            cell.textLabel.text = [NSString stringWithFormat:@"如有病历、检验/化验单、疾病部位等都可以拍照上传，最多可上传%d张",maxImageCount];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = TXBYColor(125, 125, 125);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            return cell;
        }
    }
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.contentCell) {
        self.contentCell = cell;
        [self setUpContentCellContent];
    }
    return cell;
}

- (void)setUpContentCellContent {
    UILabel *line = [UILabel new];
    line.backgroundColor = TXBYGlobalBgColor;
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
    placehold.textColor = TXBYColor(199, 199, 199);
    placehold.font = [UIFont systemFontOfSize:16];
    
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        placehold.text = @"请输入提问的具体内容";
    } else {
        placehold.text = @"输入内容";
    }
    
    [placehold makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content.mas_left).offset(5);
        make.top.equalTo(content.mas_top).offset(8);
    }];
    
    CGFloat photosViewHeight = imageW + 16;
    [self.contentCell addSubview:self.photoBtn];
    [self.photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentCell.mas_right).offset(-8);
        make.top.equalTo(content.mas_bottom).offset(8 + photosViewHeight - 30);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        self.photoBtn.hidden = YES;
    }
    
    self.photosView = [UIView new];
    [self.contentCell.contentView addSubview:self.photosView];
    self.photosView.frame = CGRectMake(0, 128, TXBYApplicationW,imageW + 16);
    [self.photosView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentCell.mas_left);
        make.right.equalTo(self.contentCell.mas_right);
        make.height.equalTo(photosViewHeight);
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
        if (i < maxImageCount) {
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
    
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:TXBYMainColor] forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.barTintColor = TXBYMainColor;
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
    if (self.images.count == maxImageCount) {
        self.photoBtn.hidden = YES;
    }
    [self.tableView reloadData];
    [self addChildImage];
    
    // 4. 让当前控制器关闭照片选择控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelImageBtn:(UIButton *)btn {
    if (self.images.count) {
        [self.images removeObjectAtIndex:btn.tag];
        if (self.images.count < maxImageCount) {
            if (self.questionCreateStyle == QuestionCreateStyleReply) {
                self.photoBtn.hidden = NO;
            }

        }
        [self addChildImage];
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        if (indexPath.row == 0) {
            return 150 + imageW;
        } else {
            return 50;
        }
    }
    return 150 + imageW;
}

// 设置UITableViewCell分割线从最左端开始
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.questionCreateStyle == QuestionCreateStyleQuestion) {
        if (indexPath.row == 1) {
            [self addImage:nil];
        }
    }
}

- (void)removePickerView {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.pickerView.txby_y = TXBYApplicationH;
//    } completion:^(BOOL finished) {
//        [self.pickerView removeFromSuperview];
//    }];
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
        [self.view endEditing:YES];
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


#pragma mark - QuestionTipsViewDelegate
- (void)clickQuestionTipsViewWithBtn:(UIButton *)btn nickName:(NSString *)nickName {
    nickName = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (btn.tag == 0) {
        [self.tipsView removeFromSuperview];
        [self pop];
    } else {
        if (!nickName.length) {
            [MBProgressHUD showInfo:@"请您输入有效昵称" toView:self.tipsView];
            return;
        } else if(nickName.length < 1 || nickName.length > 10) {
            [MBProgressHUD showInfo:@"昵称长度为1-10位" toView:self.tipsView];
            return;
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self.tipsView removeFromSuperview];
            }];
            [self accountUnExpired:^{
                [self modifyNickName:nickName];
            }];
        }
    }
}

- (NSString *)title {
    if (self.question || self.questionReply) {
        return @"回复";
    } else {
        return @"提问";
    }
}


@end
