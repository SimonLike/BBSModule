//
//  GDPostDetailsCell.m
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDPostDetailsCell.h"

@implementation GDPostDetailsCell

- (void)awakeFromNib {
 
    [super awakeFromNib];
    self.moreBgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.moreBgView.layer.borderWidth = 1;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_block) {
        _block(sender.tag - 10);
    }
}

-(void)initWithCommentListObj:(GDCommentListObj *)obj{

    [_peoImage sd_setImageWithURL:[NSURL URLWithString:PEO_HEAD_PIC(obj.username)] placeholderImage:nil];
    _nameLabel.text = obj.name;
    _timeLabel.text = obj.create_time;
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)obj.num];
    _contLabel.text = obj.content;
  
    if (obj.userId == [GDUtils readUser].userId) {//判断是自己评论的
        [_cz_btn setImage:[UIImage imageNamed:@"module-ljx"] forState:UIControlStateNormal];
        [_cz_btn setTitle:@"删除评论" forState:UIControlStateNormal];
    }else{
        [_cz_btn setImage:[UIImage imageNamed:@"module-hf"] forState:UIControlStateNormal];
        [_cz_btn setTitle:@"回复评论" forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
