//
//  XZEmotionPageView.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
// 一页中最多3行
#define XZEmotionMaxRows 3
// 一行中最多7列
#define XZEmotionMaxCols 7
// 每一页的表情个数
#define XZEmotionPageSize ((XZEmotionMaxRows * XZEmotionMaxCols) - 1)

@interface XZEmotionPageView : UIView
/** 这一页显示的表情（里面都是XZEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;

@end
