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
 id	int	@消息的主键
 articleId	Int	帖子ID
 name	String	昵称
 username	String	用来拼接头像
 createTime	String	@的时间

 */

@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger articleId;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *createTime;

@end
