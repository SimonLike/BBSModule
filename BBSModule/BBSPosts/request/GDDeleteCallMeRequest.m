

//
//  GDDeleteCallMeRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDDeleteCallMeRequest.h"

@implementation GDDeleteCallMeRequest
- (instancetype) init

{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
//清空@我的列表
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/deleteCallMe";
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
