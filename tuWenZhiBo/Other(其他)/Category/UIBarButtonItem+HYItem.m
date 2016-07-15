//
//  UIBarButtonItem+HYItem.m
//  tuWenZhiBo
//
//  Created by jntv on 16/7/13.
//  Copyright © 2016年 jntv. All rights reserved.
//

#import "UIBarButtonItem+HYItem.h"

@implementation UIBarButtonItem (HYItem)

/**
 *  选中图片
 *
 *  @param image    正常图片
 *  @param selImage 选中图片
 *  @param target   作用对象
 *  @param action   执行方法
 *
 *  @return 返回的内容
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(nullable id)target action:(nonnull SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


/**
 *  高亮图片
 *
 *  @param image     正常图片
 *  @param highImage 高亮图片
 *  @param target    作用对象
 *  @param action    执行方法
 *
 *  @return 返回的内容
 */
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nonnull SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
