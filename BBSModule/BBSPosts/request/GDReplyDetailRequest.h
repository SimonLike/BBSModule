//
//  GDReplyDetailRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDReplyDetailRequest : CCBaseRequest
- (instancetype) initWithCommentId:(NSInteger)commentId
                              Page:(NSInteger)page
                              Rows:(NSInteger)rows;
@end
