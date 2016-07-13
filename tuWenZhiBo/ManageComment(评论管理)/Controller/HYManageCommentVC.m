//
//  HYManageCommentVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYManageCommentVC.h"

@interface HYManageCommentVC ()

@end

@implementation HYManageCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"评论管理";
}

@end
