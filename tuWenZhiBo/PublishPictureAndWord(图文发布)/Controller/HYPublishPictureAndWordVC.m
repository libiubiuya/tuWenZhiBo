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
#import "MBProgressHUD+HYHUD.h"
#import "HYUserManager.h"
#import "HYUserInfo.h"

#import "TZImagePickerController.h"
#import "TZImageManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface HYPublishPictureAndWordVC () <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, TZImagePickerControllerDelegate>
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
/** 显示的图片 */
@property (nonatomic, strong) NSArray *images;
/** 显示的图片数组 */
@property (nonatomic, strong, readonly) NSMutableArray *fileNames;
/** 拼接的图片参数 */
@property (nonatomic, strong) NSString *spliceFilename;
/** 项目文字 */
@property (weak, nonatomic) IBOutlet UITextView *projectTitleTextView;
/** 项目文字占位文字label */
@property (weak, nonatomic) IBOutlet UITextField *placeholderLabel;
/** 返回responseObject的数组 */
@property (nonatomic, assign) int responseObjects;
/** 显示的图片 */
@property (nonatomic, strong) NSString *fileName;
/** 视频保存在沙盒的路径 */
@property (nonatomic, strong) NSString *videoPath;
/** 选择视频后放在添加按钮上的图片 */
@property (nonatomic, strong) UIImage *coverImage;
/** 发布按钮 */
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
/** 重置按钮 */
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (nonatomic, strong) NSMutableArray *selectedImageArray;
@property (nonatomic, assign) NSInteger selectedBtnTag;
@property (nonatomic, assign) NSInteger currentMaxBtnTag;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation HYPublishPictureAndWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setUpNavigationContent];
    
    // 加载列表数据
    [self loadData];
    
    // 设置代理
    [self setUpTextViewDelegate];
    
    _currentMaxBtnTag = 99;
    _selectedBtnTag = 10;
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
    // 取消第一响应者
    [self.projectTitleTextView endEditing:YES];
    
    // 加载列表数据
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

- (IBAction)addPicBtnClick:(UIButton *)button
{
    // 取消第一响应者
    [self.projectTitleTextView endEditing:YES];
    
    _selectedBtnTag = button.tag;
    
    if (button.x > _addPicBtn.width) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片或视频"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"照片", nil];
        [sheet showInView:self.view];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片或视频"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"照片", @"视频", nil];
        [sheet showInView:self.view];
    }
    
}

/**
 *  发布按钮点击
 */
- (IBAction)publishBtnClick
{
    if (self.projectSelectLabel.text.length == 0) {
        [MBProgressHUD showError:@"未选择项目"];
    } else if (_projectTitleTextView.text.length == 0 && _images == nil && _coverImage == nil) {
        [MBProgressHUD showError:@"图片和标题均为空"];
    } else if (_projectTitleTextView.text.length != 0 && _images == nil && _coverImage == nil) {
//        [MBProgressHUD showError:@"图片或视频为空"];
        [self uploadWords];
    } else if (_images != nil) {
        [self uploadImages];
    } else if (_coverImage != nil) {
        [self judgeUploadVideoType];
    }
}

/**
 *  重置
 */
- (IBAction)resetBtnClick
{
    self.projectTitleTextView.text = nil;
    
    if (_coverImage == nil) { // 重置图片
        
        [_selectedImageArray removeAllObjects];
        
        [_addPicBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_addPicBtn setImage:[UIImage imageNamed:@"02-b-图文发布-1"] forState:UIControlStateNormal];
        
        _currentMaxBtnTag = 99;
        _btnLeftConstraint.constant = HYMargin;
        
        for (UIButton *btn in _bgView.subviews) {
            _addPicBtn.tag = 0;
            if (btn.tag != 0) {
                [btn removeFromSuperview];
            }
            else {
                btn.hidden = NO;
            }
        }
        
        _addPicBtn.tag = 10;
        
        [_bgView layoutIfNeeded];
        
    } else { // 重置视频
        
        _coverImage = nil;
        
        [_addPicBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_addPicBtn setImage:[UIImage imageNamed:@"02-b-图文发布-1"] forState:UIControlStateNormal];
        
    }
}

#pragma mark 上传图片和视频

/**
 *  判断上传类型
 */
- (void)judgeUploadVideoType
{
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传"];
    
    if ([_fileName hasSuffix:@"mp4"] || [_fileName hasSuffix:@"MP4"]) {
        [self uploadVideoMP4];
    } else if ([_fileName hasSuffix:@"mov"] || [_fileName hasSuffix:@"MOV"]) {
        [self uploadVideoMOV];
    }
}

/**
 *  上传文字
 */
- (void)uploadWords
{
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时时间：默认为60秒。
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:publishPicAndWordPublishWordURL, [HYUserManager sharedUserInfoManager].userInfo.userID, [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID, [self.projectTitleTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"上传成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"上传失败"];
    }];
    
    [MBProgressHUD hideHUD];
}

/**
 *  上传图片
 */
- (void)uploadImages
{
    
    //用post上传文件
    [MBProgressHUD showMessage:@"正在上传"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时时间：默认为60秒。
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *fileName;
    NSMutableArray *fileNames = [[NSMutableArray alloc] init];
    // 把图片都重新命名
    for (int i = 0; i < _images.count; i++) {
        
        // 用时间来命名图片名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
        
        [fileNames addObject:fileName];
        _fileNames = fileNames;
    }
    
    NSString *spliceFilename;
    
    switch (_fileNames.count) {
        case 1:
            spliceFilename = [NSString stringWithFormat:@"%@", _fileNames[0]];
            _spliceFilename = spliceFilename;
            break;
        case 2:
            spliceFilename = [NSString stringWithFormat:@"%@:%@", _fileNames[0], _fileNames[1]];
            _spliceFilename = spliceFilename;
            break;
        case 3:
            spliceFilename = [NSString stringWithFormat:@"%@:%@:%@", _fileNames[0], _fileNames[1], _fileNames[2]];
            _spliceFilename = spliceFilename;
            break;
        default:
            break;
    }
    
    __block int responseObjects = 0;
    for (int i = 0; i < _selectedImageArray.count; i++) {
        
        NSDictionary *paremeters1 = @{@"jpg":_fileNames[i]};
        
        [manager POST:publishPicAndWordUploadImageURL parameters:paremeters1 constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *data = UIImageJPEGRepresentation(_selectedImageArray[i], 1.0);
            
            [formData appendPartWithFileData:data name:@"upfile" fileName:_fileNames[i] mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            responseObjects++;
            
            _responseObjects = responseObjects;
            
            if (_responseObjects == _selectedImageArray.count) {
                
                [manager GET:[NSString stringWithFormat:publishPicAndWordPublishPicAndWordURL, [HYUserManager sharedUserInfoManager].userInfo.userID, [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID, [self.projectTitleTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _spliceFilename] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [MBProgressHUD showSuccess:@"上传成功"];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD showError:@"上传失败"];
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showError:@"上传失败"];
        }];
        
        [MBProgressHUD hideHUD];
    }
}

/**
 *  上传视频MP4
 */
- (void)uploadVideoMP4
{
    [self uploadVideoWithMimeType:@"video/mp4"];
}

/**
 *  上传视频MOV
 */
- (void)uploadVideoMOV
{
    [self uploadVideoWithMimeType:@"video/quicktime"];
    
}

/**
 *  上传视频
 *
 *  @param mimeType 上传视频的格式
 */
- (void)uploadVideoWithMimeType:(NSString *)mimeType
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求超时时间：默认为60秒。
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:publishPicAndWordUploadVideoURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData = [NSData dataWithContentsOfFile:_videoPath];
        
        [formData appendPartWithFileData:fileData name:@"upfile" fileName:_fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [manager GET:[NSString stringWithFormat:publishPicAndWordPublishVideoURL, [HYUserManager sharedUserInfoManager].userInfo.userID, [HYPickerViewInfoManager sharedPickerViewInfoManager].pickerViewInfo.projectID, [self.projectTitleTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _fileName] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD showSuccess:@"上传成功"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD showError:@"上传失败"];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"上传失败"];
    }];
    
    [MBProgressHUD hideHUD];
}

#pragma mark - ------------ActionSheet------------

/**
 *  sheet的各个按钮
 *
 *  @param actionSheet sheet
 *  @param buttonIndex 按钮顺序
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_addPicBtn.x > _addPicBtn.width) {
        if (buttonIndex == 0) { // 选择照片
            [self pushImagePickerController];
        }
    } else {
        if (buttonIndex == 0) { // 选择照片
            [self pushImagePickerController];
        } else if (buttonIndex == 1) {
            [self pushVideoPickerController];
        }
    }
    
}

#pragma mark UIImagePickerController

- (UIImagePickerController *)imagePickerVc
{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark TZPickerController

/**
 *  选择照片
 */
- (void)pushImagePickerController
{
    NSUInteger pickCount = _selectedBtnTag == 10 ? 3 - _selectedImageArray.count : 1;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:pickCount delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        CGRect startFrame = _addPicBtn.frame;
        UIButton *btn = nil;
        
        if (_selectedBtnTag >= 100) {
            UIButton *selectedBtn = [_bgView viewWithTag:_selectedBtnTag];
            PHAsset *asset = [assets firstObject];
            [self imageWithAsset:asset button:selectedBtn];
            [self dismissViewControllerAnimated:YES completion:^{}];
            _selectedImageArray[_currentMaxBtnTag - 100] = asset;
            return;
        }
        if (!_selectedImageArray) {
            _selectedImageArray = [NSMutableArray array];
        }
        [_selectedImageArray addObjectsFromArray:photos];
        
        for (int i = 0; i < photos.count; i++)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = ++_currentMaxBtnTag;
            [btn addTarget:self action:@selector(addPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:btn];
            btn.frame = CGRectMake(startFrame.origin.x + i * startFrame.size.width + i * 10, startFrame.origin.y, startFrame.size.width, startFrame.size.height);
            [self imageWithAsset:assets[i] button:btn];
        }
        _btnLeftConstraint.constant = CGRectGetMaxX(btn.frame) + 10;
        [_bgView layoutIfNeeded];
        _images = photos;
        
        if (_addPicBtn.x >= _addPicBtn.width * 3) {
            _addPicBtn.hidden = YES;
        }
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imageWithAsset:(PHAsset *)asset button:(UIButton *)btn
{
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [btn setImage:result forState:UIControlStateNormal];
        
    }];
}

/**
 *  选择视频
 */
- (void)pushVideoPickerController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage,id asset) {
        
        _coverImage = coverImage;
        [_addPicBtn setBackgroundImage:coverImage forState:UIControlStateNormal];
        [_addPicBtn setImage:[UIImage imageNamed:@"02-b-图文发布-6"] forState:UIControlStateNormal];
        
        TZImageManager *manager = [[TZImageManager alloc] init];
        [manager getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
            
            _videoPath = outputPath;
            
            _fileName = [outputPath lastPathComponent];
            
        }];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
- (void)loadData
{
    // 项目列表url
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [manager GET:activityURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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

#pragma mark - -----------other------------
/**
 *  取消第一响应者
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - --------UITextViewDelegate-------

/**
 * 占位文字label是否隐藏
 */
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setUpTextViewDelegate
{
    self.projectTitleTextView.delegate = self;
}

@end
