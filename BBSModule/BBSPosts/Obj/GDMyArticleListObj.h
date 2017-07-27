//
//  GDMyArticleListObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDMyArticleListObj : NSObject
/*
 id	int	帖子主键ID
 userId	int	用户ID
 title	string	帖子主题
 image	string	图片链接[“url1”,”url2”…]
 video	String	视频URL
 audio	string	音频url
 createTime	String	帖子发布时间
 content	string	帖子内容
 num	int	帖子回复数


*/
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *video;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger num;

@end
