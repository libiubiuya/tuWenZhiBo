//
//  HYTabBarController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYTabBarController.h"
#import "HYNavigationController.h"
#import "HYCreateProjectVC.h"
#import "HYPublishPictureAndWordVC.h"
#import "HYPreviewProjectVC.h"
#import "HYManageCommentVC.h"
#import "HYManageProjectVC.h"

@interface HYTabBarController ()

@end

@implementation HYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加对应的控制器
    [self addChildViewController];
    
    // tabBar的内容
    [self addTabBarButtonContent];
    
}

/**
 *  添加对应的控制器
 */
- (void)addChildViewController
{
    // 项目创建
    HYCreateProjectVC *createProjectVC = [[HYCreateProjectVC alloc] init];
    [self addChildViewController:createProjectVC];
    
    // 图文发布
    HYPublishPictureAndWordVC *publishPictureAndWordVC = [[HYPublishPictureAndWordVC alloc] init];
    [self addChildViewController:publishPictureAndWordVC];
    
    // 项目预览
    HYPreviewProjectVC *previewProjectVC = [[HYPreviewProjectVC alloc] init];
    [self addChildViewController:previewProjectVC];
    
    // 评论管理
    HYManageCommentVC *manageCommentVC = [[HYManageCommentVC alloc] init];
    [self addChildViewController:manageCommentVC];
    
    // 项目管理
    HYManageProjectVC *manageProjectVC = [[HYManageProjectVC alloc] init];
    [self addChildViewController:manageProjectVC];
}

/**
 *  tabBar的内容
 */
- (void)addTabBarButtonContent
{
    // 项目创建
    UIViewController *createProject = self.childViewControllers[0];
    createProject.tabBarItem.image = [UIImage imageNamed:@"tab-01-a"];
    createProject.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-01-b"];
    createProject.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    // 图文发布
    UIViewController *publishPictureAndWord = self.childViewControllers[1];
    publishPictureAndWord.tabBarItem.image = [UIImage imageNamed:@"tab-02-a"];
    publishPictureAndWord.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-02-b"];
    publishPictureAndWord.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    // 项目预览
    UIViewController *previewProject = self.childViewControllers[2];
    previewProject.tabBarItem.image = [UIImage imageNamed:@"tab-03-a"];
    previewProject.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-03-b"];
    previewProject.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    // 评论管理
    UIViewController *manageComment = self.childViewControllers[3];
    manageComment.tabBarItem.image = [UIImage imageNamed:@"tab-04-a"];
    manageComment.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-04-b"];
    manageComment.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    // 项目管理
    UIViewController *manageProject = self.childViewControllers[4];
    manageProject.tabBarItem.image = [UIImage imageNamed:@"tab-05-a"];
    manageProject.tabBarItem.selectedImage = [UIImage imageNamed:@"tab-05-b"];
    manageProject.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
}

- (void)addChildViewController:(UIViewController *)childController
{
    HYNavigationController *navCon = [[HYNavigationController alloc] initWithRootViewController:childController];
    [super addChildViewController:navCon];
}

@end
