//
//  GDChooseFriendVC.h
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallFriendBlock)(NSArray *array);

@interface GDChooseFriendVC : BaseViewController
@property (nonatomic, copy)CallFriendBlock callblock;

@end
