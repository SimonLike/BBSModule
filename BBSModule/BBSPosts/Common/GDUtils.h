//
//  GDUtils.h
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDUserObj.h"

@interface GDUtils : NSObject
+ (long long)getLongNumFromDate:(NSDate *)date;
+(NSString *)ret32bitString;
//存储、读取个人数据
+ (GDUserObj *)readUser;
+ (void)archiveUser:(GDUserObj *)obj;
+ (void)setupRefresh:(UIScrollView*)scrollView WithDelegate:(id)delegate HeaderSelector:(SEL)headSelector FooterSelector:(SEL)footSelector;
+ (CGSize)textHeightSize:(NSString *)text maxSize:(CGSize)maxSize textFont:(UIFont *)font;
@end
