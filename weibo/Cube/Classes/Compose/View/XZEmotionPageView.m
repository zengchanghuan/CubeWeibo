//
//  XZEmotionPageView.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionPageView.h"
#import "XZEmotion.h"
#import "XZEmotionTabBarButton.h"
#import "XZEmotionPopView.h"
#import "XZEmotionButton.h"
#import "XZEmotionTool.h"

@interface XZEmotionPageView()
@property (nonatomic, strong) XZEmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end
@implementation XZEmotionPageView

- (XZEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [XZEmotionPopView popView];
        
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 2.添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
/**
 *  根据手指位置所在的表情按钮
 */
- (XZEmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i<count; i++) {
        XZEmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            
            // 已经找到手指所在的表情按钮了，就没必要再往下遍历
            return btn;
        }
    }
    return nil;
}
/**
 *  在这个方法中处理长按手势
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手指所在的位置\所在的表情按钮
    XZEmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: // 手指已经不再触摸pageView
            // 移除popView
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
            
        case UIGestureRecognizerStateBegan: // 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged: { // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
            
        default:
            break;
    }
}
/**
 *  监听删除按钮点击
 */
- (void)deleteClick
{
    [XZNotificationCenter postNotificationName:XZEmotionDidDeleteNotification object:nil];
}
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        XZEmotionButton *btn = [[XZEmotionButton alloc] init];
        [self addSubview:btn];

        btn.emotion = emotions[i];
        
        //监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

// CUICatalog: Invalid asset name supplied: (null), or invalid scale factor: 2.000000
// 警告原因：尝试去加载的图片不存在

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距(四周)
    CGFloat inset = 20;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / XZEmotionMaxCols;
    CGFloat btnH = (self.height - inset) / XZEmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%XZEmotionMaxCols) * btnW;
        btn.y = inset + (i/XZEmotionMaxCols) * btnH;
    }
    
    // 删除按钮
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;

}

- (void)btnClick:(XZEmotionButton *)btn
{
    self.popView.emotion = btn.emotion;
    
    //取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
    
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.popView.y = CGRectGetMidY(btnFrame) - self.popView.height;
    self.popView.centerX = CGRectGetMidX(btnFrame);
    
    //等会让popview自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    //发出通知
    [self selectEmotion:btn.emotion];
    
    
}

- (void)selectEmotion:(XZEmotion *)emotion
{
    [XZEmotionTool addRecentEmotion:emotion];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[XZSelectEmotionKey] = emotion;
    
    [XZNotificationCenter postNotificationName:XZEmotionDidSelectNotification object:nil userInfo:userInfo];
}
@end
