
//
//  GDReplyDetailRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyDetailRequest.h"

@implementation GDReplyDetailRequest
- (instancetype) initWithCommentId:(NSInteger)commentId
                              Page:(NSInteger)page
                              Rows:(NSInteger)rows
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];
        
        [requestDict setObject:@(commentId) forKey:@"commentId"];
        [requestDict setObject:@(page) forKey:@"page"];
        [requestDict setObject:@(rows) forKey:@"rows"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//获取回复详情页数据
-(NSString *)jkurl{
    return @"/appservice/articleController/getReplyDetail";
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
