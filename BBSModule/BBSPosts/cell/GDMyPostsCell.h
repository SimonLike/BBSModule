//
//  GDMyPostsCell.h
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDMyArticleListObj.h"
@interface GDMyPostsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tltLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hfnumLabel;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *del_btn;

-(void)initWithMyArticleListObj:(GDMyArticleListObj *)obj;
@end
