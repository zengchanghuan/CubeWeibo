//
//  XZUITabBar.h
//  Cube
//
//  Created by ZengChanghuan on 16/3/23.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZUITabBar;
@protocol XZTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(XZUITabBar *)tabBar;

@end

@interface XZUITabBar : UITabBar
@property (nonatomic, weak) id<XZTabBarDelegate> XZTabBardelegate;

@end




