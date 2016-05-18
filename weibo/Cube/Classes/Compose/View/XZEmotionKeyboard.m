//
//  XZEmotionKeyboard.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionKeyboard.h"
#import "XZEmotionListView.h"
#import "XZEmotionTabBar.h"
#import "XZEmotion.h"
#import "MJExtension.h"
#import "XZEmotionTool.h"
@interface XZEmotionKeyboard ()<XZEmotionTabBarDelegate>

/** 容纳表情内容的控件 */
@property (nonatomic, weak) XZEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) XZEmotionListView *recentListView;
@property (nonatomic, strong) XZEmotionListView *defaultListView;
@property (nonatomic, strong) XZEmotionListView *emojiListView;
@property (nonatomic, strong) XZEmotionListView *lxhListView;
@property (nonatomic, weak) XZEmotionTabBar *tabBar;

@end


@implementation XZEmotionKeyboard
#pragma mark - 懒加载
- (XZEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[XZEmotionListView alloc] init];
        self.recentListView.emotions = [XZEmotionTool recentEmotions];
    }
    return _recentListView;
}

- (XZEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[XZEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        self.defaultListView.emotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}

- (XZEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[XZEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}

- (XZEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[XZEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        self.lxhListView.emotions = [XZEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 2.tabbar
        XZEmotionTabBar *tabBar = [[XZEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
    
        //监听表情选中的通知
        [XZNotificationCenter addObserver:self selector:@selector(emotionDidSelect) name:XZEmotionDidSelectNotification object:nil];
    }
    return self;
}
- (void)emotionDidSelect
{
    self.recentListView.emotions = [XZEmotionTool recentEmotions];
}
-(void)dealloc
{
    [XZNotificationCenter removeObserver:self];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 44;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    

}

#pragma mark -XZEmotionTabBarDelegate
-(void)emotionTabBar:(XZEmotionTabBar *)tabBar didSelectButton:(XZEmotionTabBarButtonType)buttonType
{

    [self.showingListView removeFromSuperview];

    switch (buttonType) {
        case XZEmotionTabBarButtonTypeRecent:
            //加载沙盒中的数据
//            self.recentListView.emotions = [XZEmotionTool recentEmotions];
            [self addSubview:self.recentListView];
            break;
        case XZEmotionTabBarButtonTypeDefault:
            [self addSubview:self.defaultListView];
            break;
        case XZEmotionTabBarButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
        case XZEmotionTabBarButtonTypeLxh:
            [self addSubview:self.lxhListView];
            break;
    }
    
    // 重新计算子控件的frame(setNeedsLayout内部会在恰当的时刻，重新调用layoutSubviews，重新布局子控件)
    self.showingListView = [self.subviews lastObject];
    [self setNeedsLayout];

}
@end
