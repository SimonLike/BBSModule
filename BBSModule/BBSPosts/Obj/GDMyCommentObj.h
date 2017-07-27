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
 status	int	0—成 1—失败 2--token
 id	int	回复或者评论的ID
 userId	int	发帖人ID
 topicId	Int	帖子ID
 title	string	我评论的帖子title
 attach	string	附件URL
 createTime	String	评论发表时间
 publicTime	String	帖子发布时间
 content	string	评论内容
 name	string	发帖人昵称
 commId	Int	评论为空，回复有值
 username	String	拼接头像
 recordsTotal	int	评论总数用于分页

 */


@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *attach;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *publicTime;
@property (nonatomic, assign) NSInteger comm_parent_id;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger commId;

@end
