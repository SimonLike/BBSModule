//
//  GDDeleteArticleRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDDeleteArticleRequest : CCBaseRequest
- (instancetype) initWithUserId:(NSInteger)userId ArticleId:(NSInteger)articleId;
@end
