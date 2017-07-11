//
//  GD_MyselfCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GD_MyselfCell.h"

@implementation GD_MyselfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initWithCallMeObj:(GDCallMeObj *)obj{
    self.contLabel.text = obj.content;
    self.timeLabel.text = obj.create_time;;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
