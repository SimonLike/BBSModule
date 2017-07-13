//
//  GDMyCommentsCell.h
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDMyCommentObj.h"

typedef void(^DeleteBlock)(NSInteger cellTag);

@interface GDMyCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UIView *pl_view;
@property (weak, nonatomic) IBOutlet UILabel *pltime_label;
@property (weak, nonatomic) IBOutlet UILabel *plcont_label;
@property (copy, nonatomic) DeleteBlock  deleteBlock;

@property (nonatomic, assign) CGFloat heights;


-(void)initWithMyCommentObj:(GDMyCommentObj *)obj;
@end
