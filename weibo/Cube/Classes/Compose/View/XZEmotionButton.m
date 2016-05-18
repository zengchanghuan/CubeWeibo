//
//  XZEmotionButton.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/25.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionButton.h"
#import "XZEmotion.h"
@implementation XZEmotionButton

/**
 *  当控件是从xib、storyboard中创建时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    //按钮高亮的时候不要去调整图片，不会让图片变灰色
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;

}

/**
 *  这个方法在initWithCoder:方法后调用
 */
- (void)awakeFromNib
{
    
}
/**
 *  重写这个方法不要高亮
 *
 */
//-(void)setHighlighted:(BOOL)highlighted
//{
//    
//}
-(void)setEmotion:(XZEmotion *)emotion
{
    _emotion = emotion;
    if (emotion.png) {
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code){
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
@end
