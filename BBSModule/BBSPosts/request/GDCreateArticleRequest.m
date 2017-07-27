
//
//  GDCreateArticleRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/19.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDCreateArticleRequest.h"

@implementation GDCreateArticleRequest
- (instancetype) initWithTitle:(NSString *)title
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

        [requestDict setObject:content forKey:@"content"];
        [requestDict setObject:image forKey:@"image"];
        [requestDict setObject:video forKey:@"video"];
        [requestDict setObject:audio forKey:@"audio"];
        [requestDict setObject:call forKey:@"call"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 发布帖子
-(NSString *)jkurl{
    return @"/appservice/articleController/createArticle";
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
