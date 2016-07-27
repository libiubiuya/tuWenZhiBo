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
    HYUserInfo *userInfoItem = [HYUserManager sharedManager].userInfo;
    _userInfoItem = userInfoItem;
    
    _userNameLabel.text = userInfoItem.username;
    
    [_twHeadImageView sd_setImageWithURL:[NSURL URLWithString:userInfoItem.userjpg]];
    
    NSLog(@"%@\n%@\n", userInfoItem.username, userInfoItem.userjpg);
}

@end
