//
//  XZEmotionTool.h
//  Cube
//
//  Created by ZengChanghuan on 16/5/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZEmotion.h"

@interface XZEmotionTool : NSObject

+ (void) addRecentEmotion:(XZEmotion *)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;

/**
 *  通过表情描述找到对应的表情
 *
 *  @param chs 表情描述
 */
+ (XZEmotion *)emotionWithChs:(NSString *)chs;
@end
