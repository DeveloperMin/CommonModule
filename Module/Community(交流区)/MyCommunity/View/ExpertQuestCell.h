//
//  ExpertQuestCell.h
//  ydyl
//
//  Created by Limmy on 2016/9/26.
//  Copyright © 2016年 txby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityListItem.h"

@interface ExpertQuestCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *quester;

@property (strong, nonatomic) IBOutlet UILabel *content;

@property (nonatomic, strong) CommunityListItem *item;

@end
