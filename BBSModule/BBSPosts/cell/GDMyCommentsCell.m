//
//  GDMyCommentsCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyCommentsCell.h"

@implementation GDMyCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.bgView.layer.borderWidth = 1;
    self.pl_view.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.pl_view.layer.borderWidth = 1;

}

-(void)initWithMyCommentObj:(GDMyCommentObj *)obj{
    [_peoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.head]] placeholderImage:nil];
    _nameLabel.text = obj.name;
    _timeLabel.text = obj.create_time;
    _contLabel.text = obj.title;

#pragma error
    
    _pltime_label.text = @"缺少评论时间字段";
    _plcont_label.text =obj.content;

    CGFloat selfW = [UIScreen mainScreen].bounds.size.width - 38*2;
    CGSize labelsize = [GDUtils textHeightSize:_plcont_label.text maxSize:CGSizeMake(selfW, 100) textFont:[UIFont systemFontOfSize:12]];
    _heights = labelsize.height + 192;
}
- (IBAction)del_click:(UIButton *)sender {
    if (_deleteBlock) {
        _deleteBlock(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
