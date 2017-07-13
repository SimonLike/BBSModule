//
//  GDReplyToMyCell.h
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDReplyMeObj.h"

@interface GDReplyToMyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UIView *pl_view;
@property (weak, nonatomic) IBOutlet UILabel *pl_label;
@property (nonatomic, assign) CGFloat heights;

-(void)initWithReplyMeObj:(GDReplyMeObj *)obj;
@end
