//
//  GDReplyListObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDReplyListObj : NSObject
/*
 返回字段说明	status	int	0—成 1—失败 2--token
	id	int	回复主键ID
	commId	int	回复对应的评论主键
	userId	int	回复发起人的ID
	attach	String	附件URL
	targetId	int	被回复人的ID
	targetName	String	被回复人昵称
	topicId	int	帖子ID
	createTime	String	回复时间
	uId	int	回复人ID
	name	String	回复人昵称
	content	String	回复内容
	recordsTotal	Int	总条数 分页
 备注	targetId,targetName为空代表回复的是评论，有值代表回复的对象是别人的回复
 没有值：name :   叶伟芬 ：回复333
 有值例子：name 指向 targetName: 李航 回复 袁国华：  天净沙，秋思
 */

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, assign) NSInteger commId;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, copy) NSString * attach;
@property(nonatomic, assign) NSInteger targetId;
@property(nonatomic, copy) NSString * targetName;
@property(nonatomic, assign) NSInteger topicId;
@property(nonatomic, copy) NSString * createTime;
@property(nonatomic, assign) NSInteger uId;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * content;

@end
