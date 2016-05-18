//
//  XZEmotionTabBar.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XZEmotionTabBarButtonTypeRecent, // 最近
    XZEmotionTabBarButtonTypeDefault, // 默认
    XZEmotionTabBarButtonTypeEmoji, // emoji
    XZEmotionTabBarButtonTypeLxh, // 浪小花
} XZEmotionTabBarButtonType;

@class XZEmotionTabBar;

@protocol XZEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(XZEmotionTabBar *)tabBar didSelectButton:(XZEmotionTabBarButtonType)buttonType;
@end

@interface XZEmotionTabBar : UIView
@property (nonatomic, weak) id<XZEmotionTabBarDelegate> delegate;
@end