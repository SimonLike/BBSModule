//
//  GDMyArticleListRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/9.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDMyArticleListRequest : CCBaseRequest
- (instancetype) initWithRows:(NSInteger)rows
                           page:(NSInteger)page;
@end
