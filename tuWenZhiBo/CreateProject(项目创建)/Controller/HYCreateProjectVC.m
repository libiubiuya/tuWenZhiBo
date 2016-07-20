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

#define SettingCenterUrl @"prefs:root=com.ArtPollo.Artpollo"

@interface HYCreateProjectVC ()<LMJImageChooseControlDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 图片选择view */
@property (weak, nonatomic) IBOutlet LMJImageChooseControl *imageChooseView;
/** 上传头图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *uploadHeadPicBtn;
/** 显示的图片 */
@property (nonatomic, strong, readonly) UIImage *image;

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
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"%@", self.imageChooseView.delegate);
    
    [self.uploadHeadPicBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    _image = image;
    
    
    if ([self.imageChooseView.delegate respondsToSelector:@selector(imageChooseControl:didChooseFinished:)]) {
        [self.imageChooseView.delegate imageChooseControl:self.imageChooseView didChooseFinished:image];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)imageChooseControl:(LMJImageChooseControl *)control didChooseFinished:(UIImage *)image{
    
    NSLog(@"Choose Finished!");
    
    [self.uploadHeadPicBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)imageChooseControl:(LMJImageChooseControl *)control didClearImage:(UIImage *)image{
    
    NSLog(@"Clear!");
    
    
    [self.uploadHeadPicBtn setBackgroundImage:[UIImage imageNamed:@"02-a-项目创建-7"] forState:UIControlStateNormal];
}

@end
