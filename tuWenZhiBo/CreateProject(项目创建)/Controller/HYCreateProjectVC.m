//
//  HYCreateProjectVC.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/12.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYCreateProjectVC.h"
#import "HYUserController.h"
#import "MBProgressHUD+HYHUD.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <AFNetworking/AFNetworking.h>

@interface HYCreateProjectVC ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ------------发布------------

- (IBAction)publishBtnClick
{
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传ing..."];
    
    // 用时间来命名图片名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paremeters1 = @{@"jpg":fileName};
    
    /**
     *  http://bbs.ijntv.cn/mobilejinan/graphic/images/你的文件名
     *  这是图片上传完成后在浏览器查看是否存在的路径
     */
    
    // http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/upload1.php
    // http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/twcj.php
    [manager POST:@"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/upload1.php" parameters:paremeters1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 把图片转换成NSData类型的数据
        NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
        
        /*
         //拼接二进制文件数据
         第一个参数：要上传的文件的二进制数据
         第二个参数：服务器接口规定的名称
         第三个参数：这个参数上传到服务器之后用什么名字来进行保存
         第四个参数：上传文件的MIMEType类型
         */

        [formData appendPartWithFileData:data name:@"upfile" fileName:fileName mimeType:@"application/octet-stream"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [manager GET:[NSString stringWithFormat:@"http://bbs.ijntv.cn/mobilejinan/graphic/datainterface/twcj.php?title=%@&jpg=%@",  [self.projectTitle.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], fileName] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:@"上传成功"];
        [MBProgressHUD hideHUD];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:@"上传失败"];
        [MBProgressHUD hideHUD];
    }];
    
}

#pragma mark - ----------重置-------------
/**
 *  重置
 */
- (IBAction)resetBtnClick
{
    [_uploadHeadPicBtn setBackgroundImage:[UIImage imageNamed:@"02-a-项目创建-7"] forState:UIControlStateNormal];
    [_uploadHeadPicBtn setImage:[UIImage imageNamed:@"02-a-项目创建-2"] forState:UIControlStateNormal];
    
    _image = nil;
    
    _projectTitle.text = nil;
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
