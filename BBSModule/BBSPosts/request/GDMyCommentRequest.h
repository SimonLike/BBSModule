//
//  GDMyCommentRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDMyCommentRequest : CCBaseRequest
- (instancetype) initWithPage:(NSInteger)page
                           Rows:(NSInteger)rows;
@end
