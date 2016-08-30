//
//  HYUserController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/13.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYUserController.h"
#import "HYUserInfo.h"
#import "HYUserManager.h"
#import "HYLoginController.h"

#import <UIImageView+WebCache.h>

@interface HYUserController ()
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *twHeadImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 用户信息item */
@property (nonatomic, strong) NSMutableArray *userInfo;

@end

@implementation HYUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 设置数据
    [self setUpUserInfoItem];
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"用户中心";
}

/**
 *  设置数据
 */
- (void)setUpUserInfoItem
{
    HYUserInfo *userInfoItem = [HYUserManager sharedUserInfoManager].userInfo;
    _userInfoItem = userInfoItem;
    
    _userNameLabel.text = userInfoItem.username;
    
    [_twHeadImageView sd_setImageWithURL:[NSURL URLWithString:userInfoItem.userjpg]];
}

/**
 *  退出登录
 */
- (IBAction)loginOutBtnClick
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //移除UserDefaults中存储的用户信息
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
    
    // 进入到登录界面
    HYLoginController *userC = [[HYLoginController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = userC;
}

@end
