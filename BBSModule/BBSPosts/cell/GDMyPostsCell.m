
//
//  GDMyPostsCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyPostsCell.h"

@implementation GDMyPostsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initWithMyArticleListObj:(GDMyArticleListObj *)obj{
    self.tltLabel.text = obj.title;
    self.timeLabel.text = obj.create_time;
    self.hfnumLabel.text = [NSString stringWithFormat:@"有%ld人回复",(long)obj.num];
}
- (IBAction)click:(UIButton *)sender {
    DLog(@"sender-->%@",sender.tag);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
