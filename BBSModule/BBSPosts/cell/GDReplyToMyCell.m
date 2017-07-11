
//
//  GDReplyToMyCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyToMyCell.h"

@implementation GDReplyToMyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.bgView.layer.borderWidth = 1;
    self.pl_view.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.pl_view.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
