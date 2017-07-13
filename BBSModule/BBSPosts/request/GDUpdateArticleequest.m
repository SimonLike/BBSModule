//
//  GDUpdateArticleequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDUpdateArticleequest.h"

@implementation GDUpdateArticleequest
- (instancetype) initWithArticleId:(NSInteger)articleId
                          Title:(NSString *)title
                        Content:(NSString *)content
                          Image:(NSString *)image
                          Video:(NSString *)video
                          Audio:(NSString *)audio
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:title forKey:@"title"];
        [requestDict setObject:content forKey:@"content"];
        [requestDict setObject:image forKey:@"image"];
        [requestDict setObject:video forKey:@"video"];
        [requestDict setObject:audio forKey:@"audio"];

        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//编辑帖子
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
