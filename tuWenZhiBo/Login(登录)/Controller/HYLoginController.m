//
//  HYLoginController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/14.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYLoginController.h"
#import "HYUserInfo.h"
#import "HYTabBarController.h"
#import "HYUserManager.h"

#import "MBProgressHUD+HYHUD.h"
#import <AFNetworking/AFNetworking.h>

@interface HYLoginController () <UITextFieldDelegate>
/** 登录内容view */
@property (weak, nonatomic) IBOutlet UIView *loginContentView;
/** 用户名view */
@property (weak, nonatomic) IBOutlet UIView *userNameView;
/** 密码view */
@property (weak, nonatomic) IBOutlet UIView *passwordView;
/** 用户名logo */
@property (weak, nonatomic) IBOutlet UIButton *userNameLogoBtn;
/** 密码logo */
@property (weak, nonatomic) IBOutlet UIButton *passwordLogoBtn;
/** 用户名输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation HYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调整
    [self adjust];
    
    // 添加监听
    [self addTextFildObserver];
    
    // 设置代理
    [self setUpDelegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 判断用户登录情况
    [self judgeUserLoginCircumstance];
}

#pragma mark - ---------连线方法------------

/**
 *  登录
 */
- (IBAction)loginClick
{
    [MBProgressHUD showMessage:@"正在登录"];
    
    [self uploadData];
}

#pragma mark - ----------action----------
/**
 *  判断用户登录情况
 */
- (void)judgeUserLoginCircumstance
{
    //判断是否登陆，由登陆状态判断启动页面 //获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefault objectForKey:@"username"];
    NSString *password = [userDefault objectForKey:@"password"];
    
    //如果用户未登陆则把根视图控制器改变成登陆视图控制器
    if (username != nil)
    {
        NSLog(@"%@", username);
        NSLog(@"%@", password);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:loginURL, [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            HYUserInfo *userInfo = [[HYUserInfo alloc] init];
            userInfo.state = dict[@"state"];
            userInfo.reason = dict[@"reason"];
            
            if ([userInfo.state isEqualToString:@"success"]) {
                
                userInfo.userID = dict[@"userinfo"][@"id"];
                userInfo.username = dict[@"userinfo"][@"username"];
                userInfo.userjpg = dict[@"userinfo"][@"userjpg"];
                userInfo.userperssion = dict[@"userinfo"][@"perssion"];
                
                // 进入到主界面
                HYTabBarController *tabBarVc = [[HYTabBarController alloc] init];
                
                [HYUserManager sharedUserInfoManager].userInfo = userInfo;
                
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
            }
        }];
    }
}

/**
 *  上传数据
 */
- (void)uploadData
{
    
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:loginURL, [_userNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_passwordTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        HYUserInfo *userInfo = [[HYUserInfo alloc] init];
        userInfo.state = dict[@"state"];
        userInfo.reason = dict[@"reason"];
        
        
        if ([userInfo.state isEqualToString:@"success"]) {
            
            userInfo.userID = dict[@"userinfo"][@"id"];
            userInfo.username = dict[@"userinfo"][@"username"];
            userInfo.userjpg = dict[@"userinfo"][@"userjpg"];
            userInfo.userperssion = dict[@"userinfo"][@"perssion"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:username forKey:@"username"];
            [userDefaults setObject:password forKey:@"password"];
            [userDefaults synchronize];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUD];
                // 登录成功
                [MBProgressHUD showSuccess:@"登录成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    // 进入到主界面
                    HYTabBarController *tabBarVc = [[HYTabBarController alloc] init];
                    
                    [HYUserManager sharedUserInfoManager].userInfo = userInfo;
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
                    
                });
            });
            
        } else {
            
            [MBProgressHUD hideHUD];
            // 登录失败
            [MBProgressHUD showError:@"账户或者密码错误"];
            
        }
        
    }];
}

#pragma mark - ---------调整-----------

/**
 *  调整用户名和密码的细节
 */
- (void)adjust
{
    self.userNameTextField.tintColor = self.userNameTextField.textColor;
    self.passwordTextField.tintColor = self.passwordTextField.textColor;
    self.userNameLogoBtn.userInteractionEnabled = NO;
    self.passwordLogoBtn.userInteractionEnabled = NO;
}

/**
 * 设置状态栏颜色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - -----------监听------------

/**
 * 添加监听
 */
- (void)addTextFildObserver
{
    [self.userNameTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - ---------点击后事件处理------------

/**
 * 登录按钮是否可用
 */
- (void)textChange
{
    self.loginBtn.enabled = self.userNameTextField.text.length && self.passwordTextField.text.length;
}

//取消第一响应者
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - -----------设置代理----------------

- (void)setUpDelegate
{
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

#pragma mark - --------UITextFieldDelegate-------

/**
 * 监听文本框数值改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

/**
 *  文本框成为第一响应者
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
