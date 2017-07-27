//
//  GDReplyDetailsCell.m
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyDetailsCell.h"

@implementation GDReplyDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initWithReplyListObj:(GDReplyListObj *)obj{
    _nameLabel.text = obj.name;
    _timeLabel.text = obj.createTime;
    if (obj.targetId) {
        _replyLabel.text = [NSString stringWithFormat:@"回复%@：%@",obj.targetName,obj.content];
    }else{
        _replyLabel.text = obj.content;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
