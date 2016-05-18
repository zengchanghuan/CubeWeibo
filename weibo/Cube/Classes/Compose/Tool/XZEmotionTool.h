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
@end
