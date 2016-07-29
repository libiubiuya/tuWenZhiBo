//
//  HYManageProjectVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYManageProjectVC.h"
#import "HYUserController.h"
#import "HYPickerView.h"
#import "HYPublishPicAndWordItem.h"
#import "HYPickerViewInfoManager.h"

#import <WebKit/WebKit.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface HYManageProjectVC () <UIPickerViewDelegate, UIPickerViewDataSource>
/** 项目选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *projectSelectBtn;
/** 项目预览item */
@property (nonatomic, strong) NSMutableArray *projectItem;
/** 项目选择label */
@property (weak, nonatomic) IBOutlet UILabel *projectSelectLabel;
/** 底部pickerview */
@property (nonatomic ,strong) UIPickerView *pickerView;
/** 图文直播状态开关 */
@property (weak, nonatomic) IBOutlet UISwitch *livingStateSwitch;
/** 用户评论框开关 */
@property (weak, nonatomic) IBOutlet UISwitch *userCommentSwitch;

@end

@implementation HYManageProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // 加载下拉列表
    [self loadData];
    
    // 设置项目选择label
    self.projectSelectLabel.text = [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectTitle;
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"项目管理";
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

#pragma mark - ----------click----------------
/**
 *  下拉列表
 */
- (IBAction)projectSelectBtnClick
{
    HYPickerView *pv = [[HYPickerView alloc] init];
    [pv pickerViewAppear];
    [self.view addSubview:pv];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(HYMargin, 30 + 2 * HYMargin, HYScreenW - 2 * HYMargin, pv.bottomView.height - 30 + 4 * HYMargin)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pv.bottomView addSubview:pickerView];
    self.pickerView = pickerView;
}

/**
 *  图文直播状态开关点击
 */
- (IBAction)livingStateSwitchClick
{
    if (self.livingStateSwitch.on == NO) {
        [self.userCommentSwitch setOn:NO animated:YES];
        
        [self userCommentSwitchClickOFF];
    } else {
        [self.userCommentSwitch setOn:YES animated:YES];
        
        [self userCommentSwitchClickON];
    }
}

/**
 *  用户评论框开关点击
 */
- (IBAction)userCommentSwitchClick
{
    if (self.userCommentSwitch.on == NO) {
        [self userCommentSwitchClickOFF];
    } else {
        [self userCommentSwitchClickON];
    }
}

/**
 *  图文直播状态开
 */
- (void)livingStateSwitchClickON
{
    [self.userCommentSwitch setOn:YES animated:YES];
    
    [self userCommentSwitchClickON];
}

/**
 *  图文直播状态关
 */
- (void)livingStateSwitchClickOFF
{
    [self.userCommentSwitch setOn:NO animated:YES];
    
    [self userCommentSwitchClickOFF];
}

/**
 *  用户评论框开
 */
- (void)userCommentSwitchClickON
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:[NSString stringWithFormat:@"http://ued.ijntv.cn/manage/set.php?huodongid=%@&set=answer1", [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //            NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"%@", error);
    }];
}

/**
 *  用户评论框关
 */
- (void)userCommentSwitchClickOFF
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:[NSString stringWithFormat:@"http://ued.ijntv.cn/manage/set.php?huodongid=%@&set=answer0", [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //            NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            NSLog(@"%@", error);
    }];
}

#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
-(void)loadData
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
}

#pragma mark -

@end
