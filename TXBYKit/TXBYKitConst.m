//
//  TXBYKit.h
//  TXBYKit
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 医院ID
NSString *TXBYHospital;
// app_type
NSString *TXBYApp_type;
// 医院分支
NSString *TXBYBranch;

// 导航栏高度
CGFloat const TXBYNavH = 44;
// tabbar高度
CGFloat const TXBYTabbarH = 49;
// cell之间的间距
CGFloat const TXBYCellMargin = 10;
// 接口调用成功
NSString *const TXBYSuccessCode = @"0";

// 刷新token网络标识
NSString *const TXBYRefreshTokenNetIdentifier = @"TXBYRefreshTokenNetIdentifier";
// 注销token网络标识
NSString *const TXBYRevokeTokenNetIdentifier = @"TXBYRevokeTokenNetIdentifier";
// 变更DeviceToken网络标识
NSString *const TXBYDeviceTokenNetIdentifier = @"TXBYDeviceTokenNetIdentifier";

#pragma mark - 智能分诊接口
// 智能分诊症状列表
NSString *const TXBYTriageSymptomListAPI = @"/v2/smart_triage/symptom";
// 智能分诊疾病列表
NSString *const TXBYTriageIllListAPI = @"/v2/smart_triage/disease";

#pragma mark - 问答接口
// 问题列表
NSString *const TXBYQuestListAPI = @"/v2/quest/quests";
// 问题详情
NSString *const TXBYQuestDetailAPI = @"/v2/quest/show";
// 提问
NSString *const TXBYQuestAddAPI = @"/v2/quest/create";
// 回复问题
NSString *const TXBYQuestReplyAPI = @"/v2/quest/reply";
// 我的问题
NSString *const TXBYMyQuestAPI = @"/v2/quest/my";

#pragma mark - 药师服务
// 问题列表查询
NSString *const TXBYQuestionListAPI = @"/v3/quest/query";
// 问题详情
NSString *const TXBYQuestionDetailAPI = @"/v3/quest/show";
// 发布问题
NSString *const TXBYQuestionCreateAPI = @"/v3/quest/create";
// 回复问题
NSString *const TXBYQuestionReplyAPI = @"/v3/quest/reply";
// 查询置顶问题
NSString *const TXBYTopQuestionAPI = @"/v3/quest/top";
// 搜索问题
NSString *const TXBYQuestionSearchAPI = @"/v3/quest/search";
// 我的问题
NSString *const TXBYMyQuestionAPI = @"/v3/quest/my";
// 点赞
NSString *const TXBYQuestionLikeAPI = @"/v3/operate/create";
// 取消点赞
NSString *const TXBYQuestioDislikeAPI = @"/v3/operate/cancel";

#pragma mark - 步数接口
// 步数列表
NSString *const TXBYStepListAPI = @"/v3/step/rank";
// 上传步数
NSString *const TXBYSaveStepAPI = @"/v3/step/create";
// 设置步数个人主页背景
NSString *const TXBYUploadStepBackImgeAPI = @"/v3/step/background";
// 获取一周的数据
NSString *const TXBYWeekStepListStepAPI = @"/v3/step/recent";
// 赞步数
NSString *const TXBYStepLoveAPI = @"/v3/operate/create";
// 取消赞步数
NSString *const TXBYStepCancelLoveAPI = @"/v3/operate/cancel";
// 赞我的人
NSString *const TXBYStepLovePersonAPI = @"/v3/step/love";

#pragma mark - 科室接口
// 科室介绍列表
NSString *const TXBYDeptIntroduceListAPI = @"/v2/dept/depts";
// 科室介绍详情
NSString *const TXBYDeptIntroduceDetailAPI = @"/v2/dept/show";

#pragma mark - 交流区接口
// 交流区分类
NSString *const TXBYCommunityGroupAPI = @"/v2/quest/group";
// 交流区列表
NSString *const TXBYCommunityListAPI = @"/v2/quest/quests";
// 交流区thumb图片
NSString *const TXBYCommunityThumbAPI = @"http://cloud.eeesys.com/pu/thumb.php";
// 交流区点赞和踩
NSString *const TXBYCommunityLoveAPI = @"/v2/operate/create";
// 交流区取消点赞和踩
NSString *const TXBYCommunityCancelLoveAPI = @"/v2/operate/cancel";
// 交流区点赞和点踩人数
NSString *const TXBYCommunityPersonAPI = @"/v2/quest/love";
// 交流区上传请求
NSString *const TXBYCommunityUploadImageAPI = @"http://cloud.eeesys.com/pu/upload.php";
// 已回答API
NSString *const TXBYReadQuestAPI = @"/v2/quest/answered";
// 未回答API
NSString *const TXBYUnReadQuestAPI = @"/v2/quest/to_answer";

#pragma mark - 交流区接口(模块二)
// 修改昵称
NSString *const TXBYUserNicknameModAPI = @"/v3/user/nickname";
// 圈子列表
NSString *const TXBYCircleQueryAPI = @"/v3/quest/query";
// 圈子详情
NSString *const TXBYCircleDetailAPI = @"/v3/quest/show";
// 圈子收藏
NSString *const TXBYCircleCollectAPI = @"/v3/quest/attention";
// 取消圈子收藏
NSString *const TXBYCancelCircleCollectAPI = @"/v3/quest/inattention";
// 点赞详情
NSString *const TXBYLoveDetailAPI = @"/v3/quest/love";
// 点赞
NSString *const TXBYCircleLoveAPI = @"/v3/operate/create";
// 取消赞
NSString *const TXBYCircleCancelLoveAPI = @"/v3/operate/cancel";
// 我收藏的圈子
NSString *const TXBYMyCollectCircleAPI = @"/v3/quest/my_attention";
// 我评论的圈子
NSString *const TXBYMyCommentCircleAPI = @"/v3/quest/my_reply";
// 我发布的圈子
NSString *const TXBYMyPublishCircleAPI = @"/v3/quest/my";

#pragma mark - 其他接口
// 服务条款
NSString *const TXBYAgreementAPI = @"/v2/agree/agreement";
// 药价公示
NSString *const TXBYDrugListAPI = @"http://www.szyyjg.com/androidapi/medic_prices.jsp";
// 服务价格
NSString *const TXBYServiceAPI = @"http://www.szyyjg.com/androidapi/jqm/ServiceTypeQuery.jsp";
