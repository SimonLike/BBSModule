//
//  GDArticleDetailRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDArticleDetailRequest : CCBaseRequest
- (instancetype) initWithUserId:(NSInteger)userId
                      ArticleId:(NSInteger)articleId
                           Rows:(NSInteger)rows
                           Page:(NSInteger)page;
@end
