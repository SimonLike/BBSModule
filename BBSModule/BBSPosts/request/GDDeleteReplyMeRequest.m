
//
//  GDDeleteReplyMeRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDDeleteReplyMeRequest.h"

@implementation GDDeleteReplyMeRequest
- (instancetype) init
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 清空回复我的列表
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/deleteReplyMe";
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
