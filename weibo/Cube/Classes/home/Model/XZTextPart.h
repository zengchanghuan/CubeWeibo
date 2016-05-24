//
//  XZTextPart.h
//  Cube
//
//  Created by ZengChanghuan on 16/5/23.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZTextPart : NSObject
/**
 *  内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  范围
 */
@property (nonatomic, assign) NSRange range;
/**
 *  是否国特殊文字
 */
@property (nonatomic, assign, getter=isSpecical) BOOL special;

/**
 *  是否为表情
 */
@property (nonatomic, assign, getter=isEmotion) BOOL emotion;
@end
