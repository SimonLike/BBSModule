//
//  GDDeleteArticleRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDDeleteArticleRequest.h"

@implementation GDDeleteArticleRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        [requestDict setObject:@(articleId) forKey:@"articleId"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//删除帖子
-(NSString *)jkurl{
    return @"/appservice/articleController/deleteArticle";
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
