

//
//  GDReplyToReplyRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyToReplyRequest.h"

@implementation GDReplyToReplyRequest
- (instancetype) initWithCommentId:(NSInteger)commentId
                         ArticleId:(NSInteger)articleId
                          TargetId:(NSInteger)targetId
                        TargetName:(NSString *)targetName
                             Title:(NSString *)title
                            Attach:(NSString *)attach
                           Content:(NSString *)content
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];
        
        [requestDict setObject:@(commentId) forKey:@"commentId"];
        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:@(targetId) forKey:@"targetId"];
        [requestDict setObject:targetName forKey:@"targetName"];
        [requestDict setObject:title forKey:@"title"];
        [requestDict setObject:attach forKey:@"attach"];
        [requestDict setObject:content forKey:@"content"];

        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//回复别人的回复
-(NSString *)jkurl{
    return @"/appservice/articleController/ReplyToReply";
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
