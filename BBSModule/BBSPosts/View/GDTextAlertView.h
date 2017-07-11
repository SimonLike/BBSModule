//
//  GDTextAlertView.h
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextAlertBlock)(NSInteger tag);

@interface GDTextAlertView : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bt_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bt_topCont;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) TextAlertBlock block;

+(instancetype) initTextAlertView;
@end
