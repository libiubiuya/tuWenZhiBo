//
//  HYUserController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/13.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYUserController.h"
#import "HYUserInfo.h"

@interface HYUserController ()
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *twHeadImageView;
/** 用户名 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation HYUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 设置数据
    [self setUpUserInfo];
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"用户中心";
}

- (void)setUpUserInfo
{
    HYUserInfo *userInfo = [[HYUserInfo alloc] init];
    _userInfo = userInfo;
}

- (void)setUserInfo:(HYUserInfo *)userInfo
{
    _userInfo = userInfo;
    
    // 用户名
    _userNameLabel.text = userInfo.username;
//    _userNameLabel.text = @"hello";
    NSLog(@"%@", userInfo.username);
}

@end
