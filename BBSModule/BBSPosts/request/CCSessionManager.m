//
//  CCSessionManager.m
//  LRVideo
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 S. All rights reserved.
//

#import "CCSessionManager.h"
//超时时间
static int const DEFAULT_REQUEST_TIME_OUT = 20;

@implementation CCSessionManager

static CCSessionManager * shareInstance = nil;
+ (CCSessionManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    if(shareInstance == nil){
        shareInstance = [super allocWithZone:zone];
    }
    return shareInstance;
}

//拷贝方法
- (id)copyWithZone:(NSZone *)zone{
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化一些必须参数,根据实际情况去设置        
        //设置请求格式
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        //设置请求超时
        self.requestSerializer.timeoutInterval = 10.0f;
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

        //设置返回格式
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.securityPolicy setAllowInvalidCertificates:YES];
        
        //HTTPS
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"tomcat" ofType:@"cer"];
//        
//        DLog(@"cerPath--->%@",cerPath);
//        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//        NSSet *set = [[NSSet alloc] initWithObjects:certData,nil];
//
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        //是否需要验证自建证书
//        securityPolicy.allowInvalidCertificates = YES;
//        //证书的域名与请求的域名是否设置一致
//        securityPolicy.validatesDomainName = NO;
//        securityPolicy.pinnedCertificates = set;
//        self.securityPolicy = securityPolicy;
        
        //配置https

    }
    return self;
}



@end
