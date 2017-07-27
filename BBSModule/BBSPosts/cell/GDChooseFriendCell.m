//
//  GDChooseFriendCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDChooseFriendCell.h"

@implementation GDChooseFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectImage.image = [UIImage imageNamed:@"module-selecteddxk"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"module-dxk"];
    }
    // Configure the view for the selected state
}

@end
