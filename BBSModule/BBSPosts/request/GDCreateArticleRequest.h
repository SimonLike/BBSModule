//
//  GDCreateArticleRequest.h
//  BBSModule
//
//  Created by Simon on 2017/7/19.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "CCBaseRequest.h"

@interface GDCreateArticleRequest : CCBaseRequest
- (instancetype) initWithTitle:(NSString *)title
                       Content:(NSString *)content
                         Image:(NSString *)image
                         Video:(NSString *)video
                         Audio:(NSString *)audio
                          Call:(NSString *)call;
@end
