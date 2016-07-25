//
//  HYPickerView.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/25.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "HYPickerView.h"



@implementation HYPickerView

#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)

- (void)pickerViewAppearWithURL:(NSURL *)url
{
    [self appearClick];
}


#pragma mark - ----------pickerView-----------
#pragma mark 加载数据
-(void)loadData{
    //需要展示的数据以数组的形式保存
    self.letter = @[@"aaa",@"bbb",@"ccc",@"ddd"];
    //    self.number = @[@"111",@"222",@"333",@"444"];
}

#pragma mrak - ---------UIPickerViewDelegate---------

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 40;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self exitClick];
}
// 显示每行每列的数据
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.letter[row];
            break;
        default:
            break;
    }
    return title;
}


#pragma mrak - ----------UIPickerViewDataSource---------
// 几列数据
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.letter.count;//根据数组的元素个数返回几行数据
            break;

        default:
            break;
    }
    return result;
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
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
//    NSLog(@"%@", self.BGView.gestureRecognizers);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    
    // ------底部弹出的View
    self.pickerView                 = [[UIPickerView alloc] init];
    self.pickerView.frame           = CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_WIDTH);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [appWindow addSubview:self.pickerView];
    
    // ------View出现动画
    self.pickerView.transform = CGAffineTransformMakeTranslation(0.01, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.pickerView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];
}

/**
 * 功能： View退出
 */
- (void)exitClick
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.pickerView.transform = CGAffineTransformMakeTranslation(0.01, SCREEN_HEIGHT);
        self.pickerView.alpha = 0.2;
        self.BGView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.BGView removeFromSuperview];
        [self.pickerView removeFromSuperview];
    }];
    
}

@end
