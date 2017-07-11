//
//  GDGetEditArticleRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/10.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDGetEditArticleRequest : CCBaseRequest
- (instancetype) initWithUserId:(NSInteger)userId articleId:(NSInteger)articleId;
@end
