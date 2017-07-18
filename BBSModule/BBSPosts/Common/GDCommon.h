

//  Created by Simon on 2017/1/19.
//  Copyright © 2017年 S. All rights reserved.
//

#define HTTP_HOME @"http://139.196.41.31:8080/GDLT"
//上传图片前缀
#define PIC_UPDATE @"http://139.196.41.31:8080/GDLT"
//图片Url前缀
#define PIC_HOST  @"139.196.41.31:8080/GDLT"

#ifdef DEBUG
#define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define DLog(...)
#endif

#define USERINFO @"USERINFO"


typedef NS_ENUM(NSUInteger, ResposeStyle) {
    JSON,
    XML,
    Data,
};

typedef NS_ENUM(NSUInteger, RequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault
};


typedef NS_ENUM(NSUInteger, UploadVieoStyle) {
    VideoRecord = 0,
    VideoLocation,
};


//MJRefresh HIHT TEXT
#define     MJREFRESH_DOWN_Title1                   @"下拉刷新"
#define     MJREFRESH_DOWN_Title2                   @"释放刷新"
#define     MJREFRESH_DOWN_Title3                   @"正在刷新"

#define     MJREFRESH_UP_Title1                     @"上滑加载更多"
#define     MJREFRESH_UP_Title2                     @"释放刷新"
#define     MJREFRESH_UP_Title3                     @"正在加载"
#define     MJREFRESH_UP_Title4                     @"没有更多了"

#define RGBCOLOR16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

