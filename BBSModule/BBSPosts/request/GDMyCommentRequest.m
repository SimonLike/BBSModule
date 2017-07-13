
//
//  GDMyCommentRequest.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyCommentRequest.h"

@implementation GDMyCommentRequest
- (instancetype) initWithPage:(NSInteger)page
                         Rows:(NSInteger)rows
{
    if (self = [super init]) {
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
        [requestDict setObject:@([GDUtils readUser].userId) forKey:@"userId"];
        [requestDict setObject:@(page) forKey:@"articleId"];
        [requestDict setObject:@(rows) forKey:@"commentId"];
        
        [super initWithArgumentDictionary:requestDict];
    }
    return self;
}
// 获取我的评论（评论+回复）
-(NSString *)jkurl{
    return @"/appservice/personalCenterController/getMyComment";
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
