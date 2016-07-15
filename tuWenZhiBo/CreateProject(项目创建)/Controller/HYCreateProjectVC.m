//
//  HYCreateProjectVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYCreateProjectVC.h"
#import "HYUserController.h"

@interface HYCreateProjectVC ()

@end

@implementation HYCreateProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 设置界面内容
    [self setUpInterfaceContent];
}

#pragma mark - -------设置导航条--------
/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"项目创建";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"02-a-项目创建-1"] style:UIBarButtonItemStyleDone target:self action:@selector(user)];
    
    self.navigationItem.rightBarButtonItems = @[item];
}

/**
 *  用户信息
 */
- (void)user
{
    HYUserController *user = [[HYUserController alloc] init];
    // 隐藏tabBar
    user.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:user animated:YES];
}

#pragma mark - -------设置界面内容--------
/**
 *  设置界面内容
 */
- (void)setUpInterfaceContent
{
    // 项目创建view
//    UIView *creProView = [[UIView alloc] init];
//    creProView.frame = CGRectMake(0, HYStatesBarH + HYNavH, HYScreenW, HYScreenH - HYTabBarH - HYStatesBarH - HYNavH);
//    creProView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:creProView];
    
    
}

@end
