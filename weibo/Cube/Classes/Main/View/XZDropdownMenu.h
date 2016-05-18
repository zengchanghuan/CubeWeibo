//
//  XZDropdownMenu.h
//  Cube
//
//  Created by ZengChanghuan on 16/3/23.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZDropdownMenu;
@protocol XZDropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuDidDismiss:(XZDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(XZDropdownMenu *)menu;


@end
@interface XZDropdownMenu : UIView
@property (nonatomic, weak) id<XZDropdownMenuDelegate>menuDelegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

@end
