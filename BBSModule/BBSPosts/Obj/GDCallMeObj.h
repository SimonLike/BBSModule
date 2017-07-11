//
//  GDCallMeObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDCallMeObj : NSObject
/*
 "content": "",                //不展示
 "to_user_id": 2,              //@发起人
 "id": 3,                      //@主键
 "title": "听说勇士获得NBA总决赛的冠军", //标题
 "article_id": 4,                         //帖子id
 "status": 0,                     //0未读，1已读
 "create_time": "2017-06-24 14:32:06",
 "user_id": 3,                   //用户ID
 "type": 1                       //不需要
 */

@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)NSInteger to_user_id;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger article_id;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, assign)NSInteger user_id;
@property (nonatomic, assign)NSInteger type;

@end
