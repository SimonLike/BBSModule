
//
//  GDUtils.m
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDUtils.h"

@implementation GDUtils


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