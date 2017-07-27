//
//  GDReplyDetailsVC.h
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDCommentListObj.h"

@interface GDReplyDetailsVC : BaseViewController
@property (nonatomic, strong)GDCommentListObj *commentObj;
@property (nonatomic, strong)NSDictionary  *postDict;
@end
