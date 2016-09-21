//
//  HYPickerViewInfoManager.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/28.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYPickerViewInfoManager.h"
#import "HYManageProjectItem.h"

@implementation HYPickerViewInfoManager

+ (instancetype)sharedPickerViewInfoManager
{
    static HYPickerViewInfoManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (instancetype)sharedPickerViewLivingSignalInfoManager
{
    static HYPickerViewInfoManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

@end
