
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
-(void)initWithReplyMeObj:(GDReplyMeObj *)obj{
    [_peoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.head]] placeholderImage:nil];
    _nameLabel.text = obj.name;
    _timeLabel.text = obj.create_time;
//    _contLabel.text = [NSString stringWithFormat:@"评论了我的帖子 %@",obj.title];
    _pl_label.text = obj.content;
    
    [AttributeUILabel setLableText:_contLabel attribute:obj.title instr:[NSString stringWithFormat:@"评论了我的帖子 %@",obj.title] withColor:RGBCOLOR16(0x1a98e1)];
  
    CGFloat t_selfW = [UIScreen mainScreen].bounds.size.width - 46;
  
    CGSize t_labelsize = [GDUtils textHeightSize:[NSString stringWithFormat:@"评论了我的帖子 %@",obj.title] maxSize:CGSizeMake(t_selfW, 100) textFont:[UIFont systemFontOfSize:12]];
    
    CGFloat selfW = [UIScreen mainScreen].bounds.size.width - 38*2;
    CGSize labelsize = [GDUtils textHeightSize:_pl_label.text maxSize:CGSizeMake(selfW, 100) textFont:[UIFont systemFontOfSize:12]];
    _heights = t_labelsize.height + labelsize.height + 160;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
