
//
//  XZEmotionTool.m
//  Cube
//
//  Created by ZengChanghuan on 16/5/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

// 最近表情的存储路径
#define XZRecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "XZEmotionTool.h"
#import "XZEmotion.h"
@implementation XZEmotionTool

static NSMutableArray *_recentEmotions;

+(void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XZRecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+(void)addRecentEmotion:(XZEmotion *)emotion
{
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XZRecentEmotionsPath];
    
}

+(NSArray *)recentEmotions
{
    return _recentEmotions;
}
@end
