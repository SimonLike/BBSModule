//
//  GDReplyCommentRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDReplyCommentRequest : CCBaseRequest
- (instancetype) initWithArticleId:(NSInteger)articleId
                         CommentId:(NSInteger)commentId
                            Attach:(NSString *)attach
                           Content:(NSString *)content;
@end
