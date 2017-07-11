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
 content": "开元十八年（730年），李白三十岁。春在安陆。前此曾多次谒见本州裴长史，因遭人谗谤，于近日上书自白，终为所拒。初夏，往长安，谒宰相张说，并结识其子张垍。寓居终南山玉真公主（玄宗御妹）别馆。又曾谒见其它王公大臣，均无结果。暮秋游邢州（在长安之西）。冬游坊州（在长安之北）。是年杜甫十九岁，游于晋（今山西省）。",                                         //帖子文字内容
 "id": 1,                   //帖子ID
 "num": 2,                  //帖子评论数量
 "title": "                  //帖子标题
 "audio": "",               //帖子音频
 "name": "东城嘻嘻",        //发帖人昵称
 "create_time": "2017-06-22 14:35:57",  //时间
 "image": "",               //帖子图片
 "head":                    //发帖人头像
 "http://file.youyanknow.com/yyzbUploadFile/2017/06/11/114631/6.png",
 "video": ""                //帖子视频

 */

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *video;

@end
