//
//  GDMyCommentObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDMyCommentObj : NSObject
/*
 "call": "",              //@用户用户，字符串
 "status": 0,             //0显示，1已删除
 "comm_id": 7,            //评论为Null,回复有值
 "type": 1,              //0评论 1回复
 "id": 8,                //主键，用户删除回复
 "content": "我也觉得不好看",      //内容
 "title": "微微一笑很倾城好看吗？",   //帖子标题
 "attach": "",                        //附件，字符串
 "name": "薇薇",                      //发帖人昵称
 "create_time": "2017-06-23 11:01:25",
 "comm_parent_id": 7,      //评论的父ID
 "user_id": 1,              //我的ID，评论人ID
 "head":                     //头像URL
 "http://file.youyanknow.com/yyzbUploadFile/2017/06/11/114626/5.png",
 "topic_id": 5              //帖子ID
 */


@property (nonatomic, copy) NSString *call;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger comm_id;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *attach;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger comm_parent_id;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *head;
@end
