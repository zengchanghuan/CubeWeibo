//
//  XZEmotionPopView.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/25.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZEmotionButton.h"
@class XZEmotion;
@interface XZEmotionPopView :  UIView
@property (nonatomic, strong) XZEmotion *emotion;

+ (instancetype)popView;

- (void)showFrom:(XZEmotionButton *)button;

@end
