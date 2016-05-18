//
//  XZTitleButton.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZTitleButton.h"
#define XZMARGING 10

@implementation XZTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }

    return self;
}
/**
 *  想在系统计算和设置完按钮的尺寸后，再修改尺寸
 *  重写setFrame：方法的目的：拦截设置按钮尺寸的过程.如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame中设置
 */
- (void)setFrame:(CGRect)frame
{
    frame.size.width += XZMARGING;
    [super setFrame:frame];
}
/**
 *  自已的尺寸被的改情况下调用
 */
- (void)layoutSubviews
{

    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + XZMARGING;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

@end
