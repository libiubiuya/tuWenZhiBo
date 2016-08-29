//
//  HYGlobeConst.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/15.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYGlobeConst.h"

/** 活动列表URL */
NSString *const activityURL = @"http://ued.ijntv.cn/manage/huodonglist.php";

/** 登录URL */
NSString *const loginURL = @"http://ued.ijntv.cn/manage/login.php?username=%@&password=%@";

/** 项目创建模块 项目管理模块 图片上传URL */
NSString *const createProjectUploadImageURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/upload1.php";

/** 项目创建模块 发布URL */
NSString *const createProjectPublishURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/twcj.php?title=%@&jpg=%@";

/** 图文发布模块 图片上传URL */
NSString *const publishPicAndWordUploadImageURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/upload.php";

/** 图文发布模块 图片和文字发布URL */
NSString *const publishPicAndWordPublishPicAndWordURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/twfb.php?userid=%@&huodongid=%@&content=%@&jpg=%@";

/** 图文发布模块 视频上传URL */
NSString *const publishPicAndWordUploadVideoURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/uploadvideo.php";

/** 图文发布模块 视频发布URL */
NSString *const publishPicAndWordPublishVideoURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/twfb.php?userid=%@&huodongid=%@&content=%@&jpg=%@";

/** 项目预览模块 加载网页数据URL 低权限 */
NSString *const previewProjectLoadWebViewLowPressionURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/manage/mobileview/programview.php?huodongid=%@";

/** 项目预览模块 加载网页数据URL 高权限 */
NSString *const previewProjectLoadWebViewHighPressionURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/manage/mobileview/programview1.php?huodongid=%@";

/** 评论管理模块 加载网页URL */
NSString *const manageCommentLoadWebViewURL = @"http://bbs.ijntv.cn/mobilejinan/graphic/manage/resource/saomiaom.php?id=%@";

/** 项目管理模块 浮窗的图片和文字发布URL */
NSString *const manageProjectPublishPicAndWordURL = @"http://ued.ijntv.cn/manage/set.php?huodongid=%@&set=f&jpg=%@&url=%@";

/** 项目管理模块 项目标题图片修改URL */
NSString *const manageProjectRevisePicAndWordURL = @"http://ued.ijntv.cn/manage/edit.php?huodongid=%@&title=%@&titlejpg=%@";




