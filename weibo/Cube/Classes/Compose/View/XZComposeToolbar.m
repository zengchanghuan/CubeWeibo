//
//  XZComposeToolbar.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/7.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZComposeToolbar.h"

@implementation XZComposeToolbar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:XZComposeToolbarButtonTypeCamera];
        
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:XZComposeToolbarButtonTypePicture];
        
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:XZComposeToolbarButtonTypeMention];
        
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:XZComposeToolbarButtonTypeTrend];
        
        [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:XZComposeToolbarButtonTypeEmotion];

    }
    return self;
}


/**
 * 创建一个按钮
 */
- (void)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(XZComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
    [self addSubview:btn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.composeToolDelegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        //        NSUInteger index = (NSUInteger)(btn.x / btn.width);
        [self.composeToolDelegate composeToolbar:self didClickButton:(int)btn.tag];
    }
}
@end
