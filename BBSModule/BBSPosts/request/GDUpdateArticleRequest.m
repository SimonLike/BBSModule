

//
//  GDUpdateArticleRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/22.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDUpdateArticleRequest.h"

@implementation GDUpdateArticleRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
                             Title:(NSString *)title
                           Content:(NSString *)content
                             Image:(NSString *)image
                             Video:(NSString *)video
                             Audio:(NSString *)audio
                              Call:(NSString *)call

{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:title forKey:@"title"];
        [requestDict setObject:content forKey:@"content"];
        [requestDict setObject:image forKey:@"image"];
        [requestDict setObject:video forKey:@"video"];
        [requestDict setObject:audio forKey:@"audio"];
        [requestDict setObject:call forKey:@"call"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//编辑帖子
-(NSString *)jkurl{
    return @"/appservice/articleController/updateArticle";
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
