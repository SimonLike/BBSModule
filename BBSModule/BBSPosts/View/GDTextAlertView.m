//
//  GDTextAlertView.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDTextAlertView.h"

@implementation GDTextAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
    self.textView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.textView.layer.borderWidth = 1;
}
+(instancetype) initTextAlertView
{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"GDTextAlertView" owner:nil options:nil];
    return [objs firstObject];
}
- (IBAction)click:(UIButton *)sender {
    if (_block) {
        _block(sender.tag);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        //        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
@end
