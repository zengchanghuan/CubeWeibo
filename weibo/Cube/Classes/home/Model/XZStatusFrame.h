//
//  XZStatusFrame.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <Foundation/Foundation.h>
// 昵称字体
#define XZStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define XZStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define XZStatusCellSourceFont XZStatusCellTimeFont
// 正文字体
#define XZStatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博的正文字体
#define XZStatusCellRetweetContentFont [UIFont systemFontOfSize:13]
// cell之间的间距
#define XZStatusCellMargin 15

// cell的边框宽度
#define XZStatusCellBorderW 10

@class XZStatus;

@interface XZStatusFrame : NSObject

@property (nonatomic, strong) XZStatus *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;

@property (nonatomic, assign) CGRect toolbarF;


/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


@end
