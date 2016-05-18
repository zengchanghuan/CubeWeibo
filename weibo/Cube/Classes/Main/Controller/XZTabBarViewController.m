//
//  XZTabBarViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZTabBarViewController.h"
#import "XZHomeViewController.h"
#import "XZMessageCenterViewController.h"
#import "XZDiscoverViewController.h"
#import "XZProfileViewController.h"
#import "XZComposeViewController.h"
#import "XZNavigationController.h"
#import "XZUITabBar.h"
@interface XZTabBarViewController ()<XZTabBarDelegate>

@end

@implementation XZTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    XZHomeViewController *home = [[XZHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    XZMessageCenterViewController *message = [[XZMessageCenterViewController alloc] init];
    [self addChildVc:message title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    
    XZDiscoverViewController *discover = [[XZDiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    
    XZProfileViewController *profile = [[XZProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    XZUITabBar *tabBar = [[XZUITabBar alloc] init];
    
    //下面这两个顺序不可调换，也可不要这行代码
    tabBar.XZTabBardelegate = self;
    
    [self setValue:tabBar forKey:@"tabBar"];
}



/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    if (iOS7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    // 设置子控制器的图片
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = XZColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = XZRandomColor;
    // 先给外面传进来的小控制器 包装 一个导航控制器
    XZNavigationController *nav = [[XZNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

-(void)tabBarDidClickPlusButton:(XZUITabBar *)tabBar
{
    XZComposeViewController *compose = [[XZComposeViewController alloc] init];
    XZNavigationController *nav = [[XZNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
