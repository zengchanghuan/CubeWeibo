//
//  XZEmotionPopView.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/25.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionPopView.h"
#import "XZEmotion.h"
#import "XZEmotionButton.h"
@interface XZEmotionPopView()


@property (weak,nonatomic) IBOutlet XZEmotionButton *emotionButton;
@end

@implementation XZEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XZEmotionPopView" owner:nil options:nil] lastObject];

}
-(void)showFrom:(XZEmotionButton *)button
{
    if (button == nil) {
        return;
    }
    self.emotionButton.emotion = button.emotion;
    
    //取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    //计算出被点击的的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
}
-(void)setEmotion:(XZEmotion *)emotion
{
    _emotion = emotion;
    self.emotionButton.emotion = emotion;
}
@end
