//
//  HYManageProjectItem.m
//  tuWenZhiBo
//
//  Created by jntv on 16/9/19.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYManageProjectItem.h"

@implementation HYManageProjectItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"livingSignalID":@"id",
             @"livingSignalVideoID":@"videoid",
             @"livingSignalName":@"name"
             };
}

@end
