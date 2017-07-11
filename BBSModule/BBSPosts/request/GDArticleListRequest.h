//
//  GDArticleListRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDArticleListRequest : CCBaseRequest
- (instancetype) initWithUserId:(NSInteger)userId
                           Rows:(NSInteger)rows
                           Page:(NSInteger)page;
@end
