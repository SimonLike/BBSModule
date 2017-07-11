//
//  CCBaseRequest.m
//  LRVideo
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 S. All rights reserved.
//

#import "CCBaseRequest.h"
#import "CCSessionManager.h"

#define BaseUrl @""

@implementation CCBaseRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        //用来设置请求需要的公共的参数 例如：version devtoken session_id udid ...
        self.baseParams = [[NSMutableDictionary alloc] init];
                
    }
    return self;
}

- (void)initWithArgumentDictionary:(NSDictionary *)dict
{
    _params = dict;
}

#pragma mark - 拼接完整的url
- (NSString *)getcCompleteUrl
{
    //获取一个HTTP_HOME 拼接之后成一个完整的返回 我随便宏定义一个url
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP_HOME,self.jkurl];
    return url;
}
-(NSString *)jkurl{

    return @"";//默认
}

#pragma mark - 基本设置
//继承之后，这两个方法需要覆写
//请求的方式
- (RequestMethod)getRequestMethod
{
    return RequestMethodPOST;
}

//是否包含图片上传
- (RequestType)getRequestType
{
    return RequestTypeOrdinary;
}


#pragma mark - 组合参数
- (NSDictionary *)CombinationParams:(NSDictionary *)params
{
//    NSArray *pathArr = [self.jkurl componentsSeparatedByString:@"/"];
//    
//    NSString *secret = [NSString stringToMD5:[NSString stringWithFormat:@"%@%@",[pathArr lastObject],@"cc_@^$#_vzb_2017"]];
//    
//    if (self.baseParams  == nil) {
//        
//        self.baseParams = [[NSMutableDictionary alloc] init];
//    }
//    [self.baseParams setNonNilObject:secret  forKey:@"secret"];

//    [self.baseParams setNonNilObject:[CCCommon readLocalUserInfo].token forKey:@"token"];
    [self.baseParams addEntriesFromDictionary:params];

    return self.baseParams;
}

#pragma mark - 发起请求
- (NSURLSessionDataTask *)requestDataWithsuccess:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    CCBaseRequest * baseRequest = [self init];
    if (baseRequest)
    {
        NSDictionary * allParams = [baseRequest CombinationParams:_params];
        DLog(@"url -->%@",[self getcCompleteUrl]);
        DLog(@"_params -->%@",allParams);

        if ([baseRequest getRequestType] == RequestTypeOrdinary)
        {
            return [baseRequest RequestParams:allParams success:success failure:failure];
        }
        else
        {
            return [baseRequest RequestImageParams:allParams success:success failure:failure];
        }
    }
    return nil;
}


#pragma mark - Request no Image
- (NSURLSessionDataTask *)RequestParams:(NSDictionary *)params
                                success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                                failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    CCSessionManager * manager = [CCSessionManager shareInstance];
    
    if (_timeoutInterval) {
        manager.requestSerializer.timeoutInterval = _timeoutInterval;
    }

    if ([self getRequestMethod] == RequestMethodGET)
    {
        NSURLSessionDataTask * task = [manager GET:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            failure(task,error);
        }];
        return task;
    }
    else
    {
        NSURLSessionDataTask * task = [manager POST:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                int result = [[dict objectForKey:@"status"] intValue];
                if (result < 4 ) {
                    
//                    if (result == 0) {
//                        success(task,nil);
//                    }else
                        if(result == 2){
                        
//                        [MBHud showMessag:@"登录失效，请重新登录" toView:nil toBool: YES];
//                        
//                        SET_NSUSERDEFAULTS(USER_LOGIN_STATUE, LOGINOUT);
//                        [(AppDelegate*)MyAppDelegate reloadApp];
                        
                    }else if(result == 3 ){
                        
                        success(task,nil);
                        
                    }else{
                        
                        success(task,dict);
                    }
                }else{
//                    [MBHud showMessag:[NSString stringWithFormat:@"请求失败 status:%@",[dict objectForKey:@"status"]] toView:nil toBool:YES];
                    success(task,dict);
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
//            [MBHud showMessag:@"网络异常" toView:nil toBool:YES];
            DLog(@"fail == %@", error);
            failure(task,error);
        }];
        
        return task;
    }
}


#pragma mark - Request Image
- (NSURLSessionDataTask *)RequestImageParams:(NSDictionary *)params
                                     success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                                     failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure
{
    CCSessionManager * manager = [CCSessionManager shareInstance];
    NSURLSessionDataTask * task = [manager POST:[self getcCompleteUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 构造body,告诉AF是什么类型文件
        for (NSString *key in params)
        {
            id value = params[key];
            if ([value isKindOfClass:[NSData class]])
            {
                [formData appendPartWithFileData:value name:key fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //在这里可以对请求出错做统一的处理
        failure(task,error);
    }];
    return task;
}

@end
