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
#import "MBProgressHUD+HYHUD.h"
#import "HYUserManager.h"
#import "HYUserInfo.h"

#import <WebKit/WebKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SDAutoLayout.h>

@interface HYManageProjectVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
/** scrollContentView */
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *allView;

/** 项目选择label */
@property (weak, nonatomic) IBOutlet UILabel *projectSelectLabel;
/** 项目选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *projectSelectBtn;
/** 项目预览item */
@property (nonatomic, strong) NSMutableArray *projectPreviewItem;

/** 项目头图button */
@property (weak, nonatomic) IBOutlet UIButton *projectHeadPicBtn;
/** 显示的图片 */
@property (nonatomic, strong, readonly) UIImage *projectHeadPicImage;
/** 项目标题textField */
@property (weak, nonatomic) IBOutlet UITextField *projectTitleTextField;
/** 修改头图和标题button */
@property (weak, nonatomic) IBOutlet UIButton *projectHeadPicAndTitleReviseBtn;

/** 图文直播状态开关 */
@property (weak, nonatomic) IBOutlet UISwitch *livingStateSwitch;

/** 用户评论框开关 */
@property (weak, nonatomic) IBOutlet UISwitch *userCommentSwitch;

/** 浮窗图片button */
@property (weak, nonatomic) IBOutlet UIButton *floatViewPicUploadBtn;
/** 显示的图片 */
@property (nonatomic, strong, readonly) UIImage *floatViewPicImage;
/** 浮窗链接textField */
@property (weak, nonatomic) IBOutlet UITextField *floatViewURLTextField;
/** 发布浮窗按钮 */
@property (weak, nonatomic) IBOutlet UIButton *publishFloatViewBtn;
/** 重置浮窗按钮 */
@property (weak, nonatomic) IBOutlet UIButton *resetFloatViewBtn;

/** 底部pickerview */
@property (nonatomic ,strong) UIPickerView *pickerView;
/** 上传头图或者上传浮窗图片的按钮 */
@property (weak, nonatomic) UIButton *clickBtn;

@end

@implementation HYManageProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 设置修改按钮
    [self setUpReviseBtn];
    
    // 设置取消键盘
    [self setUpDismissKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // 加载下拉列表
    [self loadData];
    
    // 设置项目选择label
    self.projectSelectLabel.text = [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectTitle;
    
    // 改变直播状态开关和用户评论框开关状态
    [self changeLivingStateSwitchAndUserCommentSwitch];
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

/**
 *  设置修改按钮根据权限显示是否可用
 */
- (void)setUpReviseBtn
{
    HYUserInfo *userInfoItem = [HYUserManager sharedUserInfoManager].userInfo;
    if ([userInfoItem.userperssion isEqualToString:@"1"]) {
        
        self.projectHeadPicAndTitleReviseBtn.enabled = NO;
        
    } else if ([userInfoItem.userperssion isEqualToString:@"2"]){
        
        self.projectHeadPicAndTitleReviseBtn.enabled = YES;
        
    }
}

/**
 *  设置取消键盘
 */
- (void)setUpDismissKeyboard
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer];
}

- (void)touchScrollView
{
    [self.projectTitleTextField resignFirstResponder];
    [self.floatViewURLTextField resignFirstResponder];
}

#pragma mark - ----------click----------------
/**
 *  下拉列表
 */
- (IBAction)projectSelectBtnClick
{
    // 取消第一响应者
    [self.floatViewURLTextField endEditing:YES];
    
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
        [self livingStateSwitchClickOFF];
        [self userCommentSwitchClickOFF];
    } else {
        [self.userCommentSwitch setOn:YES animated:YES];
        [self livingStateSwitchClickON];
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:[NSString stringWithFormat:@"http://ued.ijntv.cn/manage/set.php?huodongid=%@&set=state1", [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [self userCommentSwitchClickON];
}

/**
 *  图文直播状态关
 */
- (void)livingStateSwitchClickOFF
{
    [self.userCommentSwitch setOn:NO animated:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:[NSString stringWithFormat:@"http://ued.ijntv.cn/manage/set.php?huodongid=%@&set=state0", [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 *  改变直播状态开关和用户评论框开关状态
 */
- (void)changeLivingStateSwitchAndUserCommentSwitch
{
    // 图文直播状态
    if ([[HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectState isEqualToString:@"0"]) {
        [self.livingStateSwitch setOn:NO animated:YES];
    } else {
        [self.livingStateSwitch setOn:YES animated:YES];
    }
    
    // 用户评论框状态
    if ([[HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectAnswer isEqualToString:@"0"]) {
        [self.userCommentSwitch setOn:NO animated:YES];
    } else {
        [self.userCommentSwitch setOn:YES animated:YES];
    }
}

/**
 *  选择图片按钮点击
 */
- (IBAction)uploadFloatViewPicBtnClickWithBtn:(UIButton *)btn
{
    _clickBtn = btn;
    
    // 取消第一响应者
    [self touchScrollView];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    [sheet showInView:self.view];
}

/**
 *  点击发布浮窗图片按钮
 */
- (IBAction)publishBtnClick
{
    // 判断上传内容是否为空
    [self judgefloatViewContentValue];
}

/**
 *  点击修改按钮
 */
- (IBAction)reviseBtnClick
{
    // 判断上传内容是否为空
    [self judgeHeadViewContentValue];
}

/**
 *  判断浮窗是否有值
 */
- (void)judgefloatViewContentValue
{
    if (self.projectSelectLabel.text.length == 0) {
        [MBProgressHUD showError:@"未选择项目"];
    } else if (_floatViewURLTextField.text.length == 0 && _floatViewPicImage == nil) {
        [MBProgressHUD showError:@"浮窗图片和链接均为空"];
    } else if (_floatViewURLTextField.text.length != 0 || _floatViewPicImage != nil) {
        [self uploadDataWithImage:self.floatViewPicImage URL:manageProjectPublishPicAndWordURL textField:self.floatViewURLTextField];
    }
}

/**
 *  判断项目头图是否有值
 */
- (void)judgeHeadViewContentValue
{
    if (self.projectSelectLabel.text.length == 0) {
        [MBProgressHUD showError:@"未选择项目"];
    } else if (_projectTitleTextField.text.length == 0 && _projectHeadPicImage == nil) {
        [MBProgressHUD showError:@"头图和标题均为空"];
    } else if (_projectTitleTextField.text.length != 0 || _projectHeadPicImage != nil) {
        [self uploadDataWithImage:self.projectHeadPicImage URL:manageProjectRevisePicAndWordURL textField:self.projectTitleTextField];
    }
}

/**
 *  上传方法
 *
 *  @param jpgRepresentationImage 需要转码的图片
 *  @param showWebViewURL         展示界面的URL
 *  @param textField              输入内容的文本框
 */
- (void)uploadDataWithImage:(UIImage *)jpgRepresentationImage URL:(NSString *)showWebViewURL textField:(UITextField *)textField
{
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传"];
    
    // 用时间来命名图片名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paremeters1 = @{@"jpg":fileName};
    
    [manager POST:createProjectUploadImageURL parameters:paremeters1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 把图片转换成NSData类型的数据
        NSData *data = UIImageJPEGRepresentation(jpgRepresentationImage, 1);
        
        [formData appendPartWithFileData:data name:@"upfile" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [manager GET:[NSString stringWithFormat:showWebViewURL, [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID, [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], fileName] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD showSuccess:@"上传成功"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showError:@"上传失败"];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"解析失败"];
    }];
    
    [MBProgressHUD hideHUD];
}

/**
 *  重置按钮点击
 */
- (IBAction)resetBtnClick
{
    _floatViewURLTextField.text = nil;
    self.clickBtn.imageView.image = nil;
    
    [self.clickBtn setImage:[UIImage imageNamed:@"02-e-项目管理-1"] forState:UIControlStateNormal];
    [self.clickBtn setBackgroundImage:[UIImage imageNamed:@"02-a-项目创建-7"] forState:UIControlStateNormal];
}
#pragma mark - ActionSheet Delegate

/**
 *  sheet的各个按钮
 *
 *  @param actionSheet sheet
 *  @param buttonIndex 按钮顺序
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = NO;
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_clickBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_clickBtn setImage:nil forState:UIControlStateNormal];
    
    if (_clickBtn == self.projectHeadPicBtn) {
        _projectHeadPicImage = image;
    } else if (_clickBtn == self.floatViewPicUploadBtn) {
        _floatViewPicImage = image;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
- (void)loadData
{
    // 项目列表url
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:activityURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _projectPreviewItem = [HYPublishPicAndWordItem mj_objectArrayWithKeyValuesArray:responseObject];
        
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
    return _projectPreviewItem.count;
}
#pragma mark UIPickerView Delegate Method
//指定每行如何展示数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HYPublishPicAndWordItem *item = _projectPreviewItem[row];
    
    return item.projectTitle;
}
// 选中pickerview
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    HYPublishPicAndWordItem *item = _projectPreviewItem[row];
    self.projectSelectLabel.text = item.projectTitle;
    
    [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo = item;
    
    // 改变直播状态开关和用户评论框开关状态
    [self changeLivingStateSwitchAndUserCommentSwitch];
}

@end
