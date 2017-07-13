
//
//  GDDeleteMyCommentRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDDeleteMyCommentRequest.h"

@implementation GDDeleteMyCommentRequest
- (instancetype) initWithTid:(NSInteger)tid
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(tid) forKey:@"id"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 删除我的评论或者回复
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/deleteMyComment";
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
