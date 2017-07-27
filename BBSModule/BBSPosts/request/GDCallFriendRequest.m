
//
//  GDCallFriendRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/19.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDCallFriendRequest.h"

@implementation GDCallFriendRequest
- (instancetype) init
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];
        [requestDict setObject:@([GDUtils readUser].projectId) forKey:@"projectId"];

        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 获取可以@的好友列表
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/getCallFriend";
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
