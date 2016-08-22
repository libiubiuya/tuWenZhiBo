//
//  HYPreviewProjectVC.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPublishPicAndWordItem, HYUserInfo;
@interface HYPreviewProjectVC : UIViewController

/** 图文发布item */
@property (strong, nonatomic) HYPublishPicAndWordItem *projectItems;

/** 用户信息 */
@property (strong, nonatomic) HYUserInfo *userInfo;

@end
