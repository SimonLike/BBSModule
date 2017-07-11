//
//  GDPeratingPostView.h
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PeratingPostBlock)(NSInteger tag);
typedef void(^SpeakBlock)(NSString *spkType);

@interface GDPeratingPostView : UIView
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet UIView *speakView;
@property (weak, nonatomic) IBOutlet UIView *speakbtn;

@property (nonatomic,copy) PeratingPostBlock ppBlock;
@property (nonatomic,copy) SpeakBlock speakBlock;
+(instancetype) initPeratingPostView;
@end
