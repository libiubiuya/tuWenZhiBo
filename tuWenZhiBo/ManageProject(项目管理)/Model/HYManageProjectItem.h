//
//  HYManageProjectItem.h
//  tuWenZhiBo
//
//  Created by jntv on 16/9/19.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYManageProjectItem : NSObject

/** 直播信号id */
@property (strong, nonatomic) NSString *livingSignalID;

/** 直播信号视频id */
@property (strong, nonatomic) NSString *livingSignalVideoID;

/** 直播信号名称 */
@property (strong, nonatomic) NSString *livingSignalName;

@end
