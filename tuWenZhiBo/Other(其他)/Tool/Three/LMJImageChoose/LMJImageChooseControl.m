//
//  LMJImageChooseControl.m
//  LMJImageChoose
//
//  Created by Major on 16/3/9.
//  Copyright © 2016年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//


#import "LMJImageChooseControl.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@implementation LMJImageChooseControl
{
    UILabel  * _markLabel;
    UIButton * _imgBtn;
}

- (id)init{
    self = [super init];
    if (self) {
        [self initData];
        [self buildViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self buildViews];
        [self setFrames];
    }
    return self;
}

//- (void)setFrame:(CGRect)frame{
//    [super setFrame:frame];
//    
//    [self setFrames];
//}

- (void)initData{
    _pickerTitle = @"选择";
    _image       = nil;
}


- (void)buildViews{
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    // 图片按钮
    _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imgBtn.backgroundColor = [UIColor blueColor];
    [_imgBtn setImage:nil forState:UIControlStateNormal];
    [_imgBtn addTarget:self action:@selector(clickImgBtnAddImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imgBtn];
    
}

- (void)setFrames{
//    [_imgBtn setFrame:CGRectMake(10, 104, HYScreenW - 2 * HYMargin, 170)];
}

#pragma mark - ClickBtn Methods

- (void)clickImgBtnAddImage:(UIButton *)button{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:_pickerTitle
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"从相册选取", @"拍照", nil];
    [sheet showInView:self];
}

- (void)clickClearBtn{
    [_imgBtn setImage:nil forState:UIControlStateNormal];

    _image = nil;
    
    
    if ([self.delegate respondsToSelector:@selector(imageChooseControl:didClearImage:)]) {
        [self.delegate imageChooseControl:self didClearImage:nil];
    }
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
    [self.superViewController presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    [_imgBtn setImage:image forState:UIControlStateNormal];

    _image = image;
    
    if ([self.delegate respondsToSelector:@selector(imageChooseControl:didChooseFinished:)]) {
        [self.delegate imageChooseControl:self didChooseFinished:image];
    }

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SettingCenterUrl]];
    }
}


@end
