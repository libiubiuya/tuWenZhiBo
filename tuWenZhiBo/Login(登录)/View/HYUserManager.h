//
//  HYUserManager.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/27.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYUserInfo;
@interface HYUserManager : NSObject

+ (instancetype)sharedUserInfoManager;

/** 用户信息 */
@property (strong, nonatomic) HYUserInfo *userInfo;

@end
