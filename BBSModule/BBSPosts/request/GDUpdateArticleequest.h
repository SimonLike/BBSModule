//
//  GDUpdateArticleequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/7.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDUpdateArticleequest : CCBaseRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
                          Title:(NSString *)title
                        Content:(NSString *)content
                          Image:(NSString *)image
                          Video:(NSString *)video
                          Audio:(NSString *)audio;
@end
