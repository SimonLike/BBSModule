
//
//  GDGetEditArticleRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/10.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDGetEditArticleRequest.h"

@implementation GDGetEditArticleRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(articleId) forKey:@"articleId"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 获取帖子用于编辑
-(NSString *)jkurl{
    return @"/appservice/articleController/getEditArticle";
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
