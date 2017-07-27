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
 id	int	消息主键ID
 userId	int	消息发起人ID
 toUserId	Int	我的ID
 articleId	Int	帖子ID
 title	string	帖子主题或者评论内容
 attach	string	附件URL
 type	int	0-评论 2-回复
 status	int	0-未读 1-已读
 publicTime	String	帖子发布时间
 createTime	String	消息回复时间
 content	string	回复的消息内容
 name	string	回复人昵称
 username	String	拼接头像

*/
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger toUserId;
@property (nonatomic,assign) NSInteger articleId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *attach;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString *publicTime;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *username;


@end
