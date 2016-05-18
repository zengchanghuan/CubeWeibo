//
//  XZEmotionTabBar.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionTabBar.h"
#import "XZEmotionTabBarButton.h"
@interface XZEmotionTabBar()

@property (nonatomic, weak) XZEmotionTabBarButton *selectedBtn;

@end;
@implementation XZEmotionTabBar

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:XZEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:XZEmotionTabBarButtonTypeDefault];
        //        [self btnClick:[self setupBtn:@"默认" buttonType:XZEmotionTabBarButtonTypeDefault]];
        [self setupBtn:@"Emoji" buttonType:XZEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:XZEmotionTabBarButtonTypeLxh];
    }
    return self;
}

- (XZEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(XZEmotionTabBarButtonType)buttonType
{
    // 创建按钮
    XZEmotionTabBarButton *btn = [[XZEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    // 选中“默认”按钮
    if (buttonType == XZEmotionTabBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        XZEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

-(void)setDelegate:(id<XZEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    [self btnClick:(XZEmotionTabBarButton *)[self viewWithTag:XZEmotionTabBarButtonTypeDefault]];
}
/**
 *  按钮点击
 */
- (void)btnClick:(XZEmotionTabBarButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(int)btn.tag];
    }
}

@end