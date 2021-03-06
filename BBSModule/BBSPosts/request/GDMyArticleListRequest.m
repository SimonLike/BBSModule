

//
//  GDMyArticleListRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyArticleListRequest.h"

@implementation GDMyArticleListRequest
- (instancetype) initWithRows:(NSInteger)rows
                           page:(NSInteger)page
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:[GDUtils readUser].token forKey:@"token"];

        [requestDict setObject:@(rows) forKey:@"rows"];
        [requestDict setObject:@(page) forKey:@"page"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 我的帖子列表
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/getMyArticleList";
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
