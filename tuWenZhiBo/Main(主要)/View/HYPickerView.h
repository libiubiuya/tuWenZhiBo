//
//  HYPickerView.h
//  tuWenZhiBo
//
//  Created by jntv on 16/7/25.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPublishPicAndWordItem;
@interface HYPickerView : UIView

@property (nonatomic ,strong) UIView *bottomView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩

/** 图文发布item */
@property (strong, nonatomic) HYPublishPicAndWordItem *projectItems;

- (void)pickerViewAppearWithURL:(NSURL *)url;

- (void)pickerViewExitClick;

@end
