//
//  AFHTTPClient.m
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import "YMHTTPRequestTool.h"
//#import "NSDictionary+Extension.h"
//#import "RSAEncryptor.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
//#import "YMUserInfoTool.h"
//#import <MJExtension.h>
//#import "YMLoginVC.h"
#define WEAKSELF  typeof(self) __weak weakSelf = self;
#define certificate @"jibu_ssl"

@interface YMHTTPRequestTool ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YMHTTPRequestTool

//请求实例的懒加载
-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 30.0f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"multipart/form-data",nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy = securityPolicy;
    }
    return _manager;
}

#pragma mark - 实现声明单例方法 GCD
+ (instancetype)shareInstance
{
    static YMHTTPRequestTool *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[YMHTTPRequestTool alloc] init];
    });
    return singleton;
}

#pragma mark - 请求失败统一回调方法
+(void)requestFailed:(NSError *)error
{
//  switch (error.code) {
//      case AFNetworkErrorType_NoNetwork:
//      case AFNetworkErrorType_ConnectToHost:
//            NSLog(@"网络连接失败，请检查网络");
//          [MBProgressHUD showText:@"网络连接失败，请检查网络"];
//            break;
//        case AFNetworkErrorType_TimedOut :
//            NSLog(@"访问服务器超时，请检查网络。");
//          [MBProgressHUD showText:@"访问服务器超时，请检查网络"];
//            break;
//        case AFNetworkErrorType_3840Failed :
//            NSLog(@"服务器报错了，请稍后再访问。");
//          [MBProgressHUD showText:@"服务器报错了，请稍后再访问"];
//            break;
//        case AFNetworkErrorType_Cancelled:
//          YMLog(@"操作取消");
//          break;
//        case 40:
//        case 41:
//        case 2:
//          [WSYMNSNotification postNotificationName:WSYMUserLogoutNotification object:nil];
//          [MBProgressHUD showText:@"账号可能在别处登录,请重新登录"];
//          break;
//        default:
//          YMLog(@"%ld",(long)error.code);
//          [MBProgressHUD showText:@"操作失败，请稍候再试"];
//            break;
//    }
}

//-(NSDictionary *)dictionaryWithEncryptionDictionary:(NSDictionary *)dict
//{
//    NSString *privateKeyPath = [[NSBundle mainBundle]pathForResource:@"private_key.p12" ofType:nil];
//    NSString *jsonString      = [RSAEncryptor decryptString:dict[@"data"] privateKeyWithContentsOfFile:privateKeyPath password:@"wdx7883629"];
//    if (!jsonString.length) return dict;
//
//    NSDictionary *data           = [NSDictionary dictionaryWithJsonString:jsonString];
//    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
//
//     for (NSString *key in dict) {
//
//        if ([key isEqualToString:@"data"]) {
//
//             [newDict setObject:data forKey:key];
//
//            } else {
//
//             [newDict setObject:dict[key] forKey:key];
//
//            }
//        }
//
//    return newDict;
//
//}

-(NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    securityPolicy.pinnedCertificates = @[certData];
//    [_manager setSecurityPolicy:securityPolicy];
    
    // 加上这行代码，https ssl 验证。
//    [self.manager setSecurityPolicy:[self customSecurityPolicy]];
    
   
    
    
    return [self.manager POST:URLString
                       parameters:parameters
                         progress:^(NSProgress * _Nonnull uploadProgress) {}
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             
                              NSLog(@"responseObject = %@",responseObject);
                              

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error = %@",error);
           
    }];
}

- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@".cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

-(void)cancelLastRequest
{
    NSURLSessionTask *task = [self.manager.tasks lastObject];
    [task cancel];
}

@end
