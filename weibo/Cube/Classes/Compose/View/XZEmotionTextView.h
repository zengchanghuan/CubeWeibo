//
//  XZEmotionTextView.h
//  Cube
//
//  Created by ZengChanghuan on 16/5/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZTextView.h"
#import "XZEmotion.h"
@interface XZEmotionTextView : XZTextView

- (void)insertEmotion:(XZEmotion *)emotion;

- (NSString *)fullText;
@end
