//
//  XZComposeToolbar.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/7.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XZComposeToolbarButtonTypeCamera, // 拍照
    XZComposeToolbarButtonTypePicture, // 相册
    XZComposeToolbarButtonTypeMention, // @
    XZComposeToolbarButtonTypeTrend, // #
    XZComposeToolbarButtonTypeEmotion // 表情
} XZComposeToolbarButtonType;

@class XZComposeToolbar;

@protocol XZComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(XZComposeToolbar *)toolbar didClickButton:(XZComposeToolbarButtonType)buttonType;
@end


@interface XZComposeToolbar : UIView

@property (nonatomic, weak) id<XZComposeToolbarDelegate>composeToolDelegate;

@end
