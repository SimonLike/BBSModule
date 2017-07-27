//
//  GDReplyToReplyRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDReplyToReplyRequest : CCBaseRequest
- (instancetype) initWithCommentId:(NSInteger)commentId
                         ArticleId:(NSInteger)articleId
                          TargetId:(NSInteger)targetId
                        TargetName:(NSString *)targetName
                             Title:(NSString *)title
                            Attach:(NSString *)attach
                           Content:(NSString *)content;
@end
