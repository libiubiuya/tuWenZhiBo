//
//  NSMutableURLRequest+HYPostFile.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/21.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "NSMutableURLRequest+HYPostFile.h"

@implementation NSMutableURLRequest (HYPostFile)

static NSString *boundary = @"HYPostRequest";

+ (instancetype)requestWithURL:(NSURL *)url andFileName:(NSString *)fileName
{
    // post请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:2.0f];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 15.0;
    
    // 拼接请求体数据
    NSMutableData *sendData = [NSMutableData data];
    
    NSMutableString *hyString = [NSMutableString stringWithFormat:@"--%@\r\n",boundary];
    // 存图片名
    [hyString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n\r\n", fileName]];
    [hyString appendString:@"Content-Transfer-Ending: binary\r\n\r\n"];
    [sendData appendData:[hyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [sendData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置请求体
    request.HTTPBody = sendData;
    
    // 设置请求头
    NSString *requestHeadStr = [NSString stringWithFormat:@"Content-Type multipart/form-data; boundary = %@", boundary];
    [request setValue:requestHeadStr forHTTPHeaderField:@"Content-Type : application/octet-stream"];
    
    return request;
}

@end
