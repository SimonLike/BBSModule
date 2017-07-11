//
//  GD_MyselfCell.h
//  BBSModule
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDCallMeObj.h"

@interface GD_MyselfCell : UITableViewCell

-(void)initWithCallMeObj:(GDCallMeObj *)obj;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
