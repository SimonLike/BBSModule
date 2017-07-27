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
    self.contLabel.text = [NSString stringWithFormat:@"用户 %@ @ 了我一下",obj.name];
    self.timeLabel.text = obj.createTime;;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
