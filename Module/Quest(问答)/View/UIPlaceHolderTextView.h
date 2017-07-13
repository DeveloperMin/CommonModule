//
//  UIPlaceHolderTextView.h
//  njglyyBoneSurgeryPatient
//
//  Created by hj on 16/10/13.
//  Copyright © 2016年 eeesys. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
