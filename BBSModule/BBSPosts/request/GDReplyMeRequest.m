
//
//  GDReplyMeRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyMeRequest.h"

@implementation GDReplyMeRequest
- (instancetype) initWithPage:(NSInteger)page
                         Rows:(NSInteger)rows
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        [requestDict setObject:@(page) forKey:@"page"];
        [requestDict setObject:@(rows) forKey:@"rows"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 获取回复我的，包括评论和回复
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/getReplyMe";
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
