//
//  HYUserController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/13.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYUserController.h"

@interface HYUserController ()

@end

@implementation HYUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavigationContent];
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"用户中心";
}

@end
