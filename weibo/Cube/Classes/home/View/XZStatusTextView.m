//
//  XZStatusTextView.m
//  Cube
//
//  Created by ZengChanghuan on 16/6/1.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZStatusTextView.h"
#import "XZSpecial.h"

#define XZStatusTextViewCoverTag 999

@implementation XZStatusTextView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;
    }
    return self;
}
- (void)setupSpecialRects
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (XZSpecial *special in specials) {
        self.selectedRange = special.range;
        // self.selectedRange --影响--> self.selectedTextRange
        // 获得选中范围的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            // 添加rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
}
/**
 找出被触摸的特殊字符串
 */
- (XZSpecial *)touchingSpecialWithPoint:(CGPoint)point
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (XZSpecial *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) { // 点中了某个特殊字符串
                return special;
            }
        }
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 触摸对象
    UITouch *touch = [touches anyObject];
    
    // 触摸点
    CGPoint point = [touch locationInView:self];
    
    // 初始化矩形框
    [self setupSpecialRects];
    
    // 根据触摸点获得被触摸的特殊字符串
    XZSpecial *special = [self touchingSpecialWithPoint:point];
    
    // 在被触摸的特殊字符串后面显示一段高亮的背景
    for (NSValue *rectValue in special.rects) {
        // 在被触摸的特殊字符串后面显示一段高亮的背景
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor greenColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = XZStatusTextViewCoverTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 去掉特殊字符串后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag == XZStatusTextViewCoverTag) [child removeFromSuperview];
    }
}
/**
 告诉系统:触摸点point是否在这个UI控件身上
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 初始化矩形框
    [self setupSpecialRects];
    
    // 根据触摸点获得被触摸的特殊字符串
    XZSpecial *special = [self touchingSpecialWithPoint:point];
    
    if (special) {
        return YES;
    } else {
        return NO;
    }
}

@end
