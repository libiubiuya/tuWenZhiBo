//
//  HYPickerView.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/25.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYPickerView.h"

@interface HYPickerView ()



@end

@implementation HYPickerView

- (void)pickerViewAppearWithURL:(NSURL *)url
{
    [self appearClick];
}

#pragma mark - ----------click---------------

/**
 * 功能： View显示
 */
- (void)appearClick
{
    // ------全屏遮罩
    self.BGView                 = [[UIView alloc] init];
    self.BGView.frame           = [[UIScreen mainScreen] bounds];
    self.BGView.tag             = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    
    self.BGView.userInteractionEnabled = YES;
    
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewExitClick)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    
    // ------底部弹出的View
    self.bottomView                 = [[UIView alloc] init];
    self.bottomView.frame           = CGRectMake(0, HYScreenW, HYScreenW, HYScreenW);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [appWindow addSubview:self.bottomView];
    
    // ------View出现动画
    self.bottomView.transform = CGAffineTransformMakeTranslation(0.01, HYScreenH);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}

/**
 * 功能： View退出
 */
- (void)pickerViewExitClick
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0.01, HYScreenH);
        self.bottomView.alpha = 0.2;
        self.BGView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.BGView removeFromSuperview];
        [self.bottomView removeFromSuperview];
    }];
    
}

@end
