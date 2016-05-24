
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
#import "MJExtension.h"
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

static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions;
+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}
+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;

}
+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

+ (XZEmotion *)emotionWithChs:(NSString *)chs
{
    NSArray *defaults = [self defaultEmotions];
    for (XZEmotion *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    NSArray *lxhs = [self lxhEmotions];
    for (XZEmotion *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}
@end











