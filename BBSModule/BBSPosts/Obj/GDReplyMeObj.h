//
//  GDReplyMeObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDReplyMeObj : NSObject
/*
 "content": "再评论你一次",       //内容
 "to_user_id": 2,                //回复发起人id
 "id": 7,                        //主键
 "title": "有哪些让你感叹[写出这种句子的人,我十辈子都追不上.....]",
 "article_id": 1,                 //帖子ID
 "status": 0,
 "attach": "",                    //附件
 "name": "东城嘻嘻",              //回复人
 "create_time": "2017-07-02 15:42:24",
 "user_id": 1,              //我的ID，被回复人
 "head":                    //头像
 "http://file.youyanknow.com/yyzbUploadFile/2017/06/11/114631/6.png",
 "type": 0
*/

@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger to_user_id;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSInteger article_id;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString *attach;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,copy) NSString *head;
@property (nonatomic,assign) NSInteger type;

@end
