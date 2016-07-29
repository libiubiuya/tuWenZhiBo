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
#import "HYPickerViewInfoManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <HMImagePickerController.h>

@interface HYPublishPictureAndWordVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HMImagePickerControllerDelegate>
/** 项目文字功能view */
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** 添加图片按钮左边约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeftConstraint;
/** 项目选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *projectSelectBtn;
/** 底部pickerview */
@property (nonatomic ,strong) UIPickerView *pickerView;
/** 图文发布item */
@property (nonatomic, strong) NSMutableArray *projectItem;
/** 添加图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;
/** 项目选择label */
@property (weak, nonatomic) IBOutlet UILabel *projectSelectLabel;

@property (nonatomic, strong) NSMutableArray *selectedImageArray;
@property (nonatomic, assign) NSInteger selectedBtnTag;
@property (nonatomic, assign) NSInteger currentMaxBtnTag;

@end

@implementation HYPublishPictureAndWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 加载列表数据
    [self loadData];
    
    _currentMaxBtnTag = 99;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.projectSelectLabel.text = [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectTitle;
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

#pragma mark - -------------click------------
/**
 *  项目选择按钮点击
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

- (IBAction)addPicBtnClick:(UIButton *)button
{
    _selectedBtnTag = button.tag;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    [sheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate

/**
 *  sheet的各个按钮
 *
 *  @param actionSheet sheet
 *  @param buttonIndex 按钮顺序
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    if (buttonIndex == 0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权访问相册" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            [alertView show];
            return;
        } else {
            HMImagePickerController *pickerVc = [[HMImagePickerController alloc] initWithSelectedAssets:nil];
            pickerVc.maxPickerCount = _selectedBtnTag == 0 ? 3 - _selectedImageArray.count : 1;
            pickerVc.pickerDelegate = self;
            pickerVc.targetSize = CGSizeMake(120, 120);
            [self presentViewController:pickerVc animated:YES completion:^{
                
            }];
        }
    }else if (buttonIndex == 1) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            [alertView show];
            return;
        }
    }
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

#pragma mark - HMPickerDelegate
/**
 *  给三张图片布局
 */
- (void)imagePickerController:(HMImagePickerController *)picker didFinishSelectedImages:(NSArray<UIImage *> *)images selectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    if (_selectedBtnTag != 0) {
        UIButton *selectedBtn = [_bgView viewWithTag:_selectedBtnTag];
        PHAsset *asset = [selectedAssets firstObject];
        [self imageWithAsset:asset button:selectedBtn];
        [self dismissViewControllerAnimated:YES completion:^{}];
        return;
    }
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    [_selectedImageArray addObjectsFromArray:selectedAssets];
    CGRect startFrame = _addPicBtn.frame;
    UIButton *btn = nil;
    for (int i = 0; i < selectedAssets.count; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = ++_currentMaxBtnTag;
        [btn addTarget:self action:@selector(addPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
        btn.frame = CGRectMake(startFrame.origin.x + i * startFrame.size.width + i * 10, startFrame.origin.y, startFrame.size.width, startFrame.size.height);
        [self imageWithAsset:selectedAssets[i] button:btn];
    }
    _btnLeftConstraint.constant = CGRectGetMaxX(btn.frame) + 10;
    [_bgView layoutIfNeeded];
    _addPicBtn.hidden = _selectedImageArray.count == 3;
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imageWithAsset:(PHAsset *)asset button:(UIButton *)btn {
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [btn setImage:result forState:UIControlStateNormal];
    }];
}

@end
