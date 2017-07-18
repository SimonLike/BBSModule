//
//  AFUploadFile.h
//  BBSModule
//
//  Created by Simon on 2017/7/18.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AFUploadFile : NSObject

+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType response:(ResposeStyle)style progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
