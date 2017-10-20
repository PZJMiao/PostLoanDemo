//
//  AFHTTPClient.h
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UploadParam;
//请求方式
typedef NS_ENUM(NSUInteger, RequestMethod) {
    POST = 0,
    GET,
    PUT,
    PATCH,
    DELETE
};

typedef NS_ENUM (NSInteger, AFNetworkErrorType) {
    AFNetworkErrorType_Cancelled = NSURLErrorCancelled, //-999操作取消
    AFNetworkErrorType_TimedOut  = NSURLErrorTimedOut,  //-1001 请求超时
    AFNetworkErrorType_UnURL     = NSURLErrorUnsupportedURL, //-1002 不支持的url
    AFNetworkErrorType_NoNetwork = NSURLErrorNotConnectedToInternet, //-1009 断网
    AFNetworkErrorType_404Failed = NSURLErrorBadServerResponse, //-1011 404错误
    AFNetworkErrorType_ConnectToHost = NSURLErrorCannotConnectToHost,
    AFNetworkErrorType_3840Failed = 3840, //请求或返回不是纯Json格式
};


@interface YMHTTPRequestTool : NSObject

//声明单例方法
+ (instancetype)shareInstance;

-(NSURLSessionTask *)POST:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

+(void)requestFailed:(NSError *)error;
-(void)cancelLastRequest;
@end
