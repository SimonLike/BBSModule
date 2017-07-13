
//
//  GDQuickReplyArticleRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDQuickReplyArticleRequest.h"

@implementation GDQuickReplyArticleRequest
- (instancetype) initWithArticleId:(NSInteger)articleId content:(NSString *)content
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:content forKey:@"content"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 首页快速回复
-(NSString *)jkurl{
    return @"/appservice/articleController/quickReplyArticle";
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
