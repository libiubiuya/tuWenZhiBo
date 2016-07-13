//
//  HYNavigationController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYNavigationController.h"

@interface HYNavigationController ()

@end

@implementation HYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - 重写系统方法
/**
 *  设置导航条
 */
+ (void)load
{
    // 获取全局导航条
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:HYNavItemFontColor,NSForegroundColorAttributeName, nil]];
    
}
@end
