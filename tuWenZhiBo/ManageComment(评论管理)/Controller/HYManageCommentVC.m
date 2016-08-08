//
//  HYManageCommentVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYManageCommentVC.h"
#import "HYUserController.h"
#import "HYPickerView.h"
#import "HYPublishPicAndWordItem.h"
#import "HYPickerViewInfoManager.h"

#import <WebKit/WebKit.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface HYManageCommentVC () <UIPickerViewDelegate, UIPickerViewDataSource, WKUIDelegate>

/** 网页 */
@property (weak, nonatomic) WKWebView *webView;
/** 进度条 */
//@property (weak, nonatomic) UIProgressView *progressView;
/** 内容view */
@property (weak, nonatomic) IBOutlet UIView *contentHtmlView;
/** 项目选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *projectSelectBtn;
/** 项目预览item */
@property (nonatomic, strong) NSMutableArray *projectItem;
/** 项目选择label */
@property (weak, nonatomic) IBOutlet UILabel *projectSelectLabel;
/** 底部pickerview */
@property (nonatomic ,strong) UIPickerView *pickerView;

@end

@implementation HYManageCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 加载网页
    [self setUpHtml];
    
    // 添加进度条
//    [self setUpProgressView];
    
    // 添加监听
//    [self setUpObserver];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // 加载下拉列表
    [self loadData];
    
    // 设置项目选择label
    self.projectSelectLabel.text = [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectTitle;
    
    [self loadHtml];
}

/**
 *  重新布局
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentHtmlView.bounds;
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

#pragma mark - 进度条相关
///**
// *  添加进度条
// */
//- (void)setUpProgressView
//{
//    UIProgressView *progressView = [[UIProgressView alloc] init];
//    progressView.progress = 0.0;
//    progressView.progressTintColor = [UIColor redColor];
//    progressView.progressViewStyle = UIProgressViewStyleDefault;
//    _progressView = progressView;
//    [self.contentHtmlView addSubview:progressView];
//}
//
///**
// *  添加监听
// */
//- (void)setUpObserver
//{
//    // 进度条
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//}
//
///**
// *  监听
// */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    // 进度条
//    self.progressView.progress = self.webView.estimatedProgress;
//    
//    NSLog(@"%f", self.progressView.progress);
//    
//    if (self.progressView.progress == 1.0) {
//        self.progressView.hidden = YES;
//    }
//}
//
///**
// *  移除监听
// */
//- (void)dealloc
//{
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//}

#pragma mark - 加载网页
// http://bbs.ijntv.cn/mobilejinan/graphic/manage/resource/saomiaom.php?id=%@
/**
 *  加载网页
 */
- (void)setUpHtml
{
    WKWebView *webView = [[WKWebView alloc] init];
    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentHtmlView addSubview:webView];
    _webView = webView;
    [self loadHtml];
    
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
}

/**
 *  加载网页数据
 */
- (void)loadHtml
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.ijntv.cn/mobilejinan/graphic/manage/resource/saomiaom.php?id=%@", [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - iOS给js传数据
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"审核" message:@"审核成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"确定将此记录删除？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

#pragma mark - 点击显示下拉列表
/**
 *  点击显示下拉列表
 */
- (IBAction)projectSelectBtnClick
{
    // 加载下拉列表
    [self loadData];
    
    HYPickerView *pv = [[HYPickerView alloc] init];
    [pv pickerViewAppear];
    [self.view addSubview:pv];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(HYMargin, 30 + 2 * HYMargin, HYScreenW - 2 * HYMargin, pv.bottomView.height - 30 + 4 * HYMargin)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pv.bottomView addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
- (void)loadData
{
    // http://ued.ijntv.cn/manage/huodonglist.php
    // 项目列表url
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:@"http://ued.ijntv.cn/manage/huodonglist.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _projectItem = [HYPublishPicAndWordItem mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark UIPickerView DataSource Method
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _projectItem.count;
}
#pragma mark UIPickerView Delegate Method
//指定每行如何展示数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HYPublishPicAndWordItem *item = _projectItem[row];
    
    return item.projectTitle;
}
// 选中pickerview
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    HYPublishPicAndWordItem *item = _projectItem[row];
    self.projectSelectLabel.text = item.projectTitle;
    
    [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo = item;
    
    [self loadHtml];
}

@end
