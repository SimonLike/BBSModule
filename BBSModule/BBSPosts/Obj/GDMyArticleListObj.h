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
 "content": "不会的不会的",       //内容
 "id": 9,                         //帖子ID
 "num": "",                       //帖子评论数
 "title": "明天的飞机，希望别误机", //帖子标题
 "audio": "",                       //音频
 "create_time": "2017-06-24 17:25:50",
 "image": "",                       //图片
 "user_id": 1,                      //发帖人ID
 "video": ""                        //视频URL

*/
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,assign) NSInteger user_id;
@property (nonatomic,copy) NSString *video;

@end
