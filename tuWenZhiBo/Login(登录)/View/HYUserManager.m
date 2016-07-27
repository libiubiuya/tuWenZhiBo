//
//  HYUserManager.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/27.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYUserManager.h"

@implementation HYUserManager

+ (instancetype)sharedManager
{
    static HYUserManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

@end
