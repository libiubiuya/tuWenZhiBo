//
//  NSMutableURLRequest+HYPostFile.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/21.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (HYPostFile)

+ (instancetype)requestWithURL:(NSURL *)url andFileName:(NSString *)fileName andTitle:(NSString *)title;

@end
