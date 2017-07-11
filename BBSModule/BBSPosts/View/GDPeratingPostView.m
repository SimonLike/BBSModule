
//
//  GDPeratingPostView.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDPeratingPostView.h"

@implementation GDPeratingPostView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.speakbtn.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.speakbtn.layer.borderWidth = 1;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
    //设定最小的长按时间 按不够这个时间不响应手势
    longPressGR.minimumPressDuration = 0;
    [self.speakbtn addGestureRecognizer:longPressGR];
}
//实现手势对应的功能

-(void)lpGR:(UILongPressGestureRecognizer *)lpGR
{
    if (lpGR.state == UIGestureRecognizerStateBegan) {//手势开始
        self.speakbtn.backgroundColor = RGBCOLOR16(0xeeeeee);
        if (_speakBlock) {
            _speakBlock(@"start");
        }
        
        NSLog(@"start");
    }
    
    if (lpGR.state == UIGestureRecognizerStateEnded)//手势结束
    {
        self.speakbtn.backgroundColor = RGBCOLOR16(0xffffff);

        if (_speakBlock) {
            _speakBlock(@"end");
        }
        NSLog(@"end");

    }
    
}
+(instancetype) initPeratingPostView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"GDPeratingPostView" owner:nil options:nil];
    return [objs firstObject];
}

- (IBAction)spk_click:(UIButton *)sender {
    _speakView.hidden = YES;
    _btnsView.hidden = NO;
  
    
}

- (IBAction)cz_click:(UIButton *)sender {
    
    if (_ppBlock) {
        _ppBlock(sender.tag);
    }
}


@end
