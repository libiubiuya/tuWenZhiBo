//
//  HYCreateProjectVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYCreateProjectVC.h"
#import "HYUserController.h"
#import "LMJImageChooseControl.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import <AFNetworking/AFNetworking.h>

#define SettingCenterUrl @"prefs:root=com.ArtPollo.Artpollo"

@interface HYCreateProjectVC ()<LMJImageChooseControlDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 图片选择view */
@property (weak, nonatomic) IBOutlet LMJImageChooseControl *imageChooseView;
/** 上传头图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *uploadHeadPicBtn;
/** 显示的图片 */
@property (nonatomic, strong, readonly) UIImage *image;
/** 项目标题 */
@property (weak, nonatomic) IBOutlet UITextField *projectTitle;
/** 发布按钮 */
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
/** 重置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation HYCreateProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavigationContent];
}

#pragma mark - -------设置导航条--------
/**
 *  设置导航条
 */
- (void)setUpNavigationContent
{
    self.navigationItem.title = @"项目创建";
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

#pragma mark - -------设置照片--------

/**
 *  点击上传头图按钮
 */
- (IBAction)uploadHeadPic
{
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
    
    [self.uploadHeadPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.uploadHeadPicBtn setImage:nil forState:UIControlStateNormal];
    
    _image = image;
    
    if ([self.imageChooseView.delegate respondsToSelector:@selector(imageChooseControl:didChooseFinished:)]) {
        [self.imageChooseView.delegate imageChooseControl:self.imageChooseView didChooseFinished:image];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ------------发布------------

- (IBAction)publishBtnClick
{
    
    //用post上传文件
    
    // 用时间来命名图片名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    // 图片上传
    NSURL *headPicURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.ijntv.cn/mobilejinan/graphic/images/%@", fileName]];
    
    NSLog(@"filename:%@",fileName);
    NSLog(@"title:%@", self.projectTitle.text);
    
    //url
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://bbs.ijntv.cn/mobilejinan/graphic/dateinterface/upload1.php"]];
    
    //post请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url andFileName:fileName andTitle:self.projectTitle.text];
    
    //连接(NSURLSession)
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", response);
        
    }];
    [dataTask resume];
}



#pragma mark - -----------other------------
/**
 *  取消第一响应者
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
