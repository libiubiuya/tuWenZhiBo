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

#import <WebKit/WebKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface HYManageProjectVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
/** 上传浮窗图片按钮 */
@property (weak, nonatomic) IBOutlet UIButton *uploadFloatViewPicBtn;
/** 显示的图片 */
@property (nonatomic, strong, readonly) UIImage *image;
/** 浮窗链接 */
@property (weak, nonatomic) IBOutlet UITextField *floatViewURLTextField;
/** 发布按钮 */
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

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

/**
 *  上传浮窗图片按钮点击
 */
- (IBAction)uploadFloatViewPicBtnClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    [sheet showInView:self.view];
}

/**
 *  点击发布按钮
 */
- (IBAction)publishBtnClick
{
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传ing..."];
    
    // 用时间来命名图片名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    NSLog(@"filename:%@",fileName);
    
    // 判断URL中是否包含http://
    if ([self.floatViewURLTextField.text hasPrefix:@"http://"]) {
        return;
    } else {
        self.floatViewURLTextField.text = [NSString stringWithFormat:@"http://%@", self.floatViewURLTextField.text];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *paremeters = @{@"huodongid":self.projectItems.projectID, @"set":@"f", @"jpg":fileName, @"url":self.floatViewURLTextField.text};
    
    /**
     *  http://bbs.ijntv.cn/mobilejinan/graphic/images/你的文件名
     *  这是图片上传完成后在浏览器查看是否存在的路径
     */
    
    [manager POST:@"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/upload1.php" parameters:paremeters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 把图片转换成NSData类型的数据
        NSData *data = UIImageJPEGRepresentation(self.image, 1);
        
        /*
         //拼接二进制文件数据
         第一个参数：要上传的文件的二进制数据
         第二个参数：服务器接口规定的名称
         第三个参数：这个参数上传到服务器之后用什么名字来进行保存
         第四个参数：上传文件的MIMEType类型
         */
        
        [formData appendPartWithFileData:data name:@"upfile" fileName:fileName mimeType:@"application/octet-stream"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@",responseObject);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:@"上传成功"];
        [MBProgressHUD hideHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:@"上传失败"];
        [MBProgressHUD hideHUD];
    }];
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
    
    [self.uploadFloatViewPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.uploadFloatViewPicBtn setImage:nil forState:UIControlStateNormal];
    
    _image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

@end
