//
//  HYPickerViewInfoManager.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/28.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYPublishPicAndWordItem, HYManageProjectItem;
@interface HYPickerViewInfoManager : NSObject

+ (instancetype)sharedPickerViewInfoManager;

+ (instancetype)sharedPickerViewLivingSignalInfoManager;

/** pickerView信息 */
/** 项目选择item */
@property (strong, nonatomic) HYPublishPicAndWordItem *pickerViewInfo;
/** 直播信号item */
@property (strong, nonatomic) HYManageProjectItem *pickerViewLivingSignalInfo;

@end
