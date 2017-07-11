//
//  GDUtils.h
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDUtils : NSObject
+ (void)setupRefresh:(UIScrollView*)scrollView WithDelegate:(id)delegate HeaderSelector:(SEL)headSelector FooterSelector:(SEL)footSelector;
+ (CGSize)textHeightSize:(NSString *)text maxSize:(CGSize)maxSize textFont:(UIFont *)font;
@end
