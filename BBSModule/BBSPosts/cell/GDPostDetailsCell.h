//
//  GDPostDetailsCell.h
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDCommentListObj.h"

typedef void(^PostComBlock)(NSInteger tag);

@interface GDPostDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UIView *moreBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UIButton *cz_btn;
@property (copy, nonatomic) PostComBlock block;

-(void)initWithCommentListObj:(GDCommentListObj *)obj;

@end
