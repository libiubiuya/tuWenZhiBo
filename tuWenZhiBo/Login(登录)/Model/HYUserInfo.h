//
//  HYUserInfo.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/14.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYUserInfo : NSObject

/** 状态 */
@property (nonatomic, strong) NSString *state;

/** 原因 */
@property (nonatomic, strong) NSString *reason;

/** 用户id */
@property (nonatomic, strong) NSString *userID;

/** 用户名 */
@property (nonatomic, strong) NSString *username;

/** 图片 */
@property (nonatomic, strong) NSString *userjpg;

@end
