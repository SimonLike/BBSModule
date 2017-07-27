//
//  GDCommentListObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDCommentListObj : NSObject
/*
 "call": "",    //@用户英文逗号分隔。1001,1002,100
 "id": 5,                       //评论的ID
 "content": "我看过挺好看的",   //评论内容
 "num": 1,                      //回复该评论的数量
 "attach": "",                  //回复PC端可带附件
 "name": "小明",                //评论人昵称
 "create_time": "2017-06-23 10:44:40",//评论时间
 "userId": 2,                    //评论人id
 "http://file.youyanknow.com/yyzbUploadFile/2017/06/11/114626/5.png",
 "topicId": 5                   //帖子ID
 */

@property (nonatomic, copy) NSString *call;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *attach;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger topicId;

@end
