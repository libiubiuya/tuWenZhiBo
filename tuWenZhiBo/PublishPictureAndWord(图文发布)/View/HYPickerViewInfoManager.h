//
//  HYPickerViewInfoManager.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/28.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYPublishPicAndWordItem;
@interface HYPickerViewInfoManager : NSObject

+ (instancetype)sharedPickerViewInfoManager;

/** pickerView信息 */
@property (strong, nonatomic) HYPublishPicAndWordItem *pickerViewInfo;

@end
