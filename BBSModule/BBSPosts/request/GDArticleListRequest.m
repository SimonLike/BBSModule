
//
//  GDArticleListRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDArticleListRequest.h"

@implementation GDArticleListRequest
- (instancetype) initWithUserId:(NSInteger)userId
                           Rows:(NSInteger)rows
                           Page:(NSInteger)page

{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@(userId) forKey:@"userId"];
        [requestDict setObject:@(rows) forKey:@"rows"];
        [requestDict setObject:@(page) forKey:@"page"];
   
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//获取首页帖子列表、未读消息提醒
-(NSString *)jkurl{
    return @"/appservice/articleController/getArticleList";
}

#pragma mark - 基本设置
- (RequestMethod)getRequestMethod
{
    return RequestMethodPOST;
}

- (RequestType)getRequestType
{
    return RequestTypeOrdinary;
}
@end
