//
//  GDArticleListObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDArticleListObj : NSObject
/*
 status	int	0—成 1—失败 2--token
 id	int	帖子主键ID
 userId	int	用户ID
 title	string	帖子主题
 image	string	图片链接[“url1”,”url2”…]
 video	String	视频URL
 audio	string	音频url
 createTime	String	帖子发布时间
 content	string	帖子内容
 name	String	发帖人昵称
 username	String	用户名，用于拼接头像
 num	int	帖子回复数
 recordsTotal	int	帖子总数用于分页
 callNum	int	登录用户被@数量
 replyNum	int	登录用户被回复数量


 */

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, assign) NSInteger callNum;
@property (nonatomic, assign) NSInteger replyNum;

@end
