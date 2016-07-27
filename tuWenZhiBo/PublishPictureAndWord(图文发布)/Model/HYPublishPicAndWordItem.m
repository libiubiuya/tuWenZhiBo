//
//  HYPublishPicAndWordItem.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/26.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYPublishPicAndWordItem.h"

@implementation HYPublishPicAndWordItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"projectID":@"id",
             @"projectTitle":@"title",
             @"projectDateTime":@"datetime",
             @"projectJPG":@"jpg"
             };
}

@end
