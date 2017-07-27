//
//  GDReplyDetailsCell.h
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDReplyListObj.h"

@interface GDReplyDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)initWithReplyListObj:(GDReplyListObj *)obj;
@end
