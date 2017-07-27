
//
//  GDUtils.m
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDUtils.h"
@implementation GDUtils

+ (long long)getLongNumFromDate:(NSDate *)date{
    NSTimeInterval time = [date timeIntervalSince1970];
    // NSTimeInterval返回的是double类型，输出会显示为10位整数加小数点加一些其他值
    // 如果想转成int型，必须转成long long型才够大。
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue] ; // 将double转为long long型
    return dTime;
}
+(NSString *)ret32bitString{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
//存储、读取个人数据
+ (GDUserObj *)readUser{
    NSData *oldData = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    if (!oldData) {
        return nil;
    }
    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:oldData];
    GDUserObj *obj = [myKeyedUnarchiver decodeObject];
    [myKeyedUnarchiver finishDecoding];
    return obj;
}

+ (void)archiveUser:(GDUserObj *)obj{
    
    NSMutableData *newData = [[NSMutableData alloc] init];
    NSKeyedArchiver *newKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newData];
    [newKeyedArchiver encodeObject:obj];
    [newKeyedArchiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)setupRefresh:(UIScrollView*)scrollView WithDelegate:(id)delegate HeaderSelector:(SEL)headSelector FooterSelector:(SEL)footSelector
{
    if(headSelector)
    {
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:delegate refreshingAction:headSelector];
        [header setTitle:MJREFRESH_DOWN_Title1 forState:MJRefreshStateIdle];
        [header setTitle:MJREFRESH_DOWN_Title2 forState:MJRefreshStatePulling];
        [header setTitle:MJREFRESH_DOWN_Title3 forState:MJRefreshStateRefreshing];
        scrollView.mj_header = header;
        
    }
    if(footSelector)
    {
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:delegate refreshingAction:footSelector];
        [footer setTitle:MJREFRESH_UP_Title1 forState:MJRefreshStateIdle];
        [footer setTitle:MJREFRESH_UP_Title2 forState:MJRefreshStatePulling];
        [footer setTitle:MJREFRESH_UP_Title3 forState:MJRefreshStateRefreshing];
        [footer setTitle:MJREFRESH_UP_Title4 forState:MJRefreshStateNoMoreData];
        scrollView.mj_footer = footer;
    }
}
/**
 *  获取字体的大小范围
 *  多行显示
 */
+ (CGSize)getTextMultilineContent:(NSString*)text withFont:(UIFont*)font withSize:(CGSize)size
{
    CGSize mSize;
    if ([NSString isBlankString:text]) {
        
        return CGSizeMake(0, 0);
    }
    if (IOS7) {
        mSize = [text boundingRectWithSize:size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:font}
                                   context:nil].size;
    } else {
        mSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return mSize;
}

+ (CGSize)textHeightSize:(NSString *)text maxSize:(CGSize)maxSize textFont:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize labelSize = [text boundingRectWithSize:maxSize
                                          options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                                       attributes:dic context:nil].size;
    return labelSize;
   
}
@end
