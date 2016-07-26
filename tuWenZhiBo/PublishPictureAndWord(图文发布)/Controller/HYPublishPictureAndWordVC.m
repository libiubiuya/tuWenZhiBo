//
//  HYPublishPictureAndWordVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYPublishPictureAndWordVC.h"
#import "HYUserController.h"
#import "HYPickerView.h"
#import "HYPublishPicAndWordItem.h"

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface HYPublishPictureAndWordVC () <UIPickerViewDelegate, UIPickerViewDataSource>
/** 项目选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *projectSelectBtn;
/** 底部pickerview */
@property (nonatomic ,strong) UIPickerView *pickerView;
/** 遮罩 */
@property (nonatomic ,strong) UIView *BGView;

/** 图文发布item */
@property (nonatomic, strong) NSMutableArray *projectItem;



@property (nonatomic,strong)NSArray * letter;//保存字母



@end

@implementation HYPublishPictureAndWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    
    [self loadData];
}

/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"图文发布";
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
 *  项目选择按钮点击
 */
- (IBAction)projectSelectBtnClick
{
    HYPickerView *pv = [[HYPickerView alloc] init];
    [pv pickerViewAppearWithURL:[NSURL URLWithString:@"faf"]];
    [self.view addSubview:pv];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, HYScreenW, HYScreenW)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pv.bottomView addSubview:pickerView];
    self.pickerView = pickerView;
}

#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
-(void)loadData
{
    
    // http://ued.ijntv.cn/manage/huodonglist.php
    // 项目列表url
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = self.projectItems.projectID;
    parameters[@"title"] = self.projectItems.projectTitle;
    parameters[@"datetime"] = self.projectItems.projectDateTime;
    parameters[@"jpg"] = self.projectItems.projectJPG;
    
    [manager GET:@"http://ued.ijntv.cn/manage/huodonglist.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _projectItem = [HYPublishPicAndWordItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        NSLog(@"%@", _projectItem);
        
        NSLog(@"%ld", _projectItem.count);
        
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
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _projectItem.count;
}
#pragma mark UIPickerView Delegate Method
//指定每行如何展示数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
#warning 如何赋值
    HYPublishPicAndWordItem *item = _projectItem[row];
    _projectItems = item;
    
    return item;
}


@end
