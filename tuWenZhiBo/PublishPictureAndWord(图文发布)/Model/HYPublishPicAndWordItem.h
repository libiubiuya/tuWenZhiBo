//
//  HYPublishPicAndWordItem.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/26.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPublishPicAndWordItem : NSObject

/** id */
@property (nonatomic, strong) NSString *projectID;

/** 标题 */
@property (nonatomic, strong) NSString *projectTitle;

/** 时间 */
@property (nonatomic, strong) NSString *projectDateTime;

/** 图片 */
@property (nonatomic, strong) NSString *projectJPG;

/** 用户评论框 */
@property (strong, nonatomic) NSString *projectAnswer;

/** 图文直播状态 */
@property (strong, nonatomic) NSString *projectState;

/** 浮窗图片URL */
@property (strong, nonatomic) NSString *projectFloatURL;

/** 浮窗图片 */
@property (strong, nonatomic) NSString *projectFloatJPG;

@end
