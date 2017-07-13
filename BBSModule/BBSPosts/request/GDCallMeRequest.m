
//
//  GDCallMeRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDCallMeRequest.h"

@implementation GDCallMeRequest
- (instancetype) initWithRows:(NSInteger)rows
                           page:(NSInteger)page
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(rows) forKey:@"rows"];
        [requestDict setObject:@(page) forKey:@"page"];
       
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// @我的列表
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/getCallMe";
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
