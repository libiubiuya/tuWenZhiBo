//
//  HYManageCommentVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYManageCommentVC.h"
#import "HYUserController.h"

#import <WebKit/WebKit.h>

@interface HYManageCommentVC ()

/** 网页 */
@property (weak, nonatomic) WKWebView *webView;
/** 内容view */
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation HYManageCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 加载网页
    [self setUpLoadHtml];
}

/**
 *  重新布局
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"评论管理";
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

/**
 *  加载网页
 */
- (void)setUpLoadHtml
{
    WKWebView *webView = [[WKWebView alloc] init];
    webView.scrollView.contentInset = UIEdgeInsetsMake(HYStatesBarH + HYNavH + HYProjectSelectH + HYMargin, 0, HYTabBarH, 0);
    [self.contentView addSubview:webView];
    _webView = webView;
    
    NSURL *url = [NSURL URLWithString:@"http://bbs.ijntv.cn/mobilejinan/graphic/manage/mobileview/programview.php?huodongid=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
