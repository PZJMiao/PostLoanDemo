//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/13.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
