
//
//  GDArticleDetailRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDArticleDetailRequest.h"

@implementation GDArticleDetailRequest
- (instancetype) initWithUserId:(NSInteger)userId
                      ArticleId:(NSInteger)articleId
                           Rows:(NSInteger)rows
                           Page:(NSInteger)page

{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@(userId) forKey:@"userId"];
        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:@(rows) forKey:@"rows"];
        [requestDict setObject:@(page) forKey:@"page"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//查看帖子详情
-(NSString *)jkurl{
    return @"/appservice/articleController/getArticle";
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
