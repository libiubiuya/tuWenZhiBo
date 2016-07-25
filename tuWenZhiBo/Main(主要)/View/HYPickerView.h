//
//  HYPickerView.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/25.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPickerView : UIPickerView

@property (nonatomic ,strong) UIPickerView *pickerView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩

@property (nonatomic,strong)NSArray * letter;//保存要展示的字母

- (void)pickerViewAppearWithURL:(NSURL *)url;

@end
