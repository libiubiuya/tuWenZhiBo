//
//  HYManageProjectVC.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPublishPicAndWordItem, HYManageProjectItem, HYUserInfo;
@interface HYManageProjectVC : UIViewController

/** 图文发布item */
@property (strong, nonatomic) HYPublishPicAndWordItem *projectItems;

/** 直播信号item */
@property (strong, nonatomic) HYManageProjectItem *livingSignalItems;

/** 用户信息 */
@property (strong, nonatomic) HYUserInfo *userInfoItem;

@end
