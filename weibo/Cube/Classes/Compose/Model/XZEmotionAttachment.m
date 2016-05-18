//
//  XZEmotionAttachment.m
//  Cube
//
//  Created by ZengChanghuan on 16/5/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionAttachment.h"

@implementation XZEmotionAttachment
-(void)setEmotion:(XZEmotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end
