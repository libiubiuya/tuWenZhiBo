//
//  HYLoginController.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/14.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYLoginController.h"

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

#pragma mark - ---------连线方法------------

/**
 *  登录
 */
- (IBAction)loginClick
{
    
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
    [self.userNameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
