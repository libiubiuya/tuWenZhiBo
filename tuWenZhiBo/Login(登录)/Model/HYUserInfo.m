//
//  HYUserInfo.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/14.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYUserInfo.h"

@implementation HYUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"state":@"state",
             @"reason":@"reason",
             @"userID":@"userinfo.id",
             @"username":@"userinfo.username",
             @"userjpg":@"userinfo.userjpg"
             };
}

@end
