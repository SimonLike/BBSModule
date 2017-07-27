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
    
    _picView.userInteractionEnabled = NO;
    
}
- (IBAction)btnClick:(UIButton *)sender {
}


#pragma mark -- 标题 语音 图片 视频操作
//标题
-(float)showBiaoTiStr:(NSString *)str{
    float hit = 0.0;
    CGSize tltsize ;
    if ([str isEqualToString:@""]) {
        self.tltLabel.text = @"";
        self.tltTopCont.constant = 0;
        self.tltBtmCont.constant = 0;
        self.tltBtmImage.hidden = YES;
    }else{
        self.tltLabel.text = str;
        tltsize = [GDUtils textHeightSize:str maxSize:CGSizeMake(SCREEN_WIDTH - 46, 100) textFont:[UIFont systemFontOfSize:12]];
        self.tltTopCont.constant = 20;
        self.tltBtmCont.constant = 20;
        self.tltBtmImage.hidden = NO;
       
        hit = tltsize.height + 40;
    }
    
    return hit;
}

//内容
-(float)showContentStr:(NSString *)str{
    float hit = 0.0;
    if ([str isEqualToString:@""]) {
        self.contLabel.text = @"";
        self.contTopCont.constant = 0;
    }else{
        self.contLabel.text = str;
//        CGSize contsize = [GDUtils textHeightSize:str maxSize:CGSizeMake(SCREEN_WIDTH - 46, 100) textFont:[UIFont systemFontOfSize:12]];
        CGSize contsize = [GDUtils getTextMultilineContent:str withFont:[UIFont systemFontOfSize:12] withSize:CGSizeMake(SCREEN_WIDTH - 46, 75)];

        self.contTopCont.constant = 10;
        hit = contsize.height + 5;
    }
    
    return hit;
}

//语音
-(float)showYuyinStr:(NSString *)str{
    float hit = 0.0;

    UIImage *imge = [UIImage imageNamed:@"mudule_yuyin2"];
    if([str isEqualToString:@""]){
        self.yunyinTopCont.constant = 15 - imge.size.height;
        self.yuyinImage.hidden = YES;
        hit = 15;
    }else{
        self.yunyinTopCont.constant = 15;
        self.yuyinImage.hidden = NO;
        hit = imge.size.height + 20;
    }
    return hit;
}

//图片
-(float)showPictureStr:(NSString *)str{
    
    if([str isEqualToString:@""]){
        self.picViewHit.constant = 0;
        self.picView.hidden = YES;
    }else{
        NSArray *array = [str componentsSeparatedByString:@";"];
        self.picView.picTypeTnt = 1;//显示
        self.picView.picspathArr = array;
        if (array.count%3 == 0) {
            self.picViewHit.constant = array.count/3 *  ((self.picView.frame.size.width - 30)/3 + 10);
        }else{
            self.picViewHit.constant = (array.count/3 + 1) * ((self.picView.width - 30)/3 + 10);
        }
        self.picView.hidden = NO;
        CGRect frame = self.picView.pic_collection.frame;
        frame.size.height = self.picViewHit.constant;
        self.picView.pic_collection.frame = frame;
        [self.picView.pic_collection reloadData];

    }
    
    return self.picViewHit.constant;
}
//视频
-(float)showVideoStr:(NSString *)str{
    float hit = 15.0;

    UIImage *imge = [UIImage imageNamed:@"module_videobg"];
    if([str isEqualToString:@""]){
        self.videoView.hidden = YES;
    }else{
        self.videoView.hidden = NO;
        hit = imge.size.height + 20;
    }
    return hit;
}


- (void) initWithArticleListObj:(GDArticleListObj *)obj{
    
//    [self.peoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.head]] placeholderImage:nil];
    [self.peoImage sd_setImageWithURL:[NSURL URLWithString:PEO_HEAD_PIC(obj.username)] placeholderImage:nil];
//    DLog(@"adphoto-->%@",PEO_HEAD_PIC(obj.username));
    self.nameLabel.text = obj.name;
    self.timeLabel.text = obj.create_time;

    //标题
    float tltHit =  [self showBiaoTiStr:obj.title];
    
    //发帖内容
    float contHit = [self showContentStr:obj.content];
    
//    int conts = [self countChar:obj.content cchar:@"\n"];
//    DLog(@"content-->%@",obj.content);
//    DLog(@"contHit-->%f",contHit);
    //语音
    float yuyinHit = [self showYuyinStr:obj.audio];
    //图片
    float picHit = [self showPictureStr:obj.image];
    //视频
    float videoHit = [self showVideoStr:obj.video];
    
    [self.pl_btn setTitle:[NSString stringWithFormat:@"%ld",(long)obj.num] forState:UIControlStateNormal];
   
    if(obj.userId == [GDUtils readUser].userId){
        self.edit_btn.hidden = NO;
        self.del_btn.hidden = NO;
    }else{
        self.edit_btn.hidden = YES;
        self.del_btn.hidden = YES;
    }

   _heights = tltHit + contHit + picHit + yuyinHit + videoHit + 100;
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
