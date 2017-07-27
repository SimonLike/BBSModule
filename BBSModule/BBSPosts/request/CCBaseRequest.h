//
//  CCBaseRequest.h
//  LRVideo
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 S. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "NSString+Extend.h"

@interface CCBaseRequest : NSObject

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST
};

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeOrdinary,
    RequestTypeImage
};

-(NSString *)jkurl; //请求的地址

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) NSDictionary * params;    //请求参数

@property (nonatomic, strong) NSMutableDictionary * baseParams;    //请求的公共参数

- (void)initWithArgumentDictionary:(NSDictionary *)dict;


//请求
- (NSURLSessionDataTask *)requestDataWithsuccess:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;
@end
