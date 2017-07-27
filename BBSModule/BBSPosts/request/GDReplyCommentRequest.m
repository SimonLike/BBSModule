
//
//  GDReplyCommentRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyCommentRequest.h"

@implementation GDReplyCommentRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
                         CommentId:(NSInteger)commentId
                             Title:(NSString *)title
                            Attach:(NSString *)attach
                           Content:(NSString *)content
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        [requestDict setObject:@(articleId) forKey:@"articleId"];
        [requestDict setObject:@(commentId) forKey:@"commentId"];
        [requestDict setObject:title forKey:@"title"];
        [requestDict setObject:attach forKey:@"attach"];
        [requestDict setObject:content forKey:@"content"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 帖子详情-回复评论
-(NSString *)jkurl{
    return @"/appservice/articleController/ReplyComment";
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
