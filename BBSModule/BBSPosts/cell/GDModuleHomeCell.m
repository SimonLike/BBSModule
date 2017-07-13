//
//  GDModuleHomeCell.m
//  BBSModule
//
//  Created by Simon on 2017/6/27.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDModuleHomeCell.h"

@implementation GDModuleHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.bgView.layer.borderWidth = 1;
    
}
- (IBAction)btnClick:(UIButton *)sender {
}

- (void) initWithArticleListObj:(GDArticleListObj *)obj{
    
//    [self.peoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.head]] placeholderImage:nil];
    [self.peoImage sd_setImageWithURL:[NSURL URLWithString:obj.head] placeholderImage:nil];

    self.nameLabel.text = obj.name;
    self.timeLabel.text = obj.create_time;
    self.contLabel.text = obj.title;
    self.cont2Label.text = obj.content;
    [self.pl_btn setTitle:[NSString stringWithFormat:@"%ld",(long)obj.num] forState:UIControlStateNormal];
    CGFloat selfW = [UIScreen mainScreen].bounds.size.width - 46;
    CGSize labelsize = [GDUtils textHeightSize:self.cont2Label.text maxSize:CGSizeMake(selfW, 100) textFont:[UIFont systemFontOfSize:12]];
#pragma mark ---id
    if(obj.id == [GDUtils readUser].userId){
        self.edit_btn.hidden = NO;
        self.del_btn.hidden = NO;
    }else{
        self.edit_btn.hidden = YES;
        self.del_btn.hidden = YES;
    }
    
    if (![obj.video isEqualToString:@""]) {
        self.cont2View.hidden = YES;
        self.yuyinImage.hidden = YES;
        self.videoView.hidden = NO;
    }else if (![obj.audio isEqualToString:@""]) {
        self.cont2View.hidden = YES;
        self.yuyinImage.hidden = NO;
        self.videoView.hidden = YES;
    }else {
        self.cont2View.hidden = NO;
        self.yuyinImage.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    _heights = labelsize.height + 186;
}
- (IBAction)md_click:(UIButton *)sender {
    if (_moduleBlock) {
        _moduleBlock(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
