//
//  CCSessionManager.h
//  LRVideo
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 S. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CCSessionManager : AFHTTPSessionManager
+ (CCSessionManager *)shareInstance;

@end
