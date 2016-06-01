//
//  XZSpecial.h
//  Cube
//
//  Created by ZengChanghuan on 16/6/1.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZSpecial : NSObject

/**
 *  这段特殊文字的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  特殊文字的范围
 */
@property (nonatomic, assign) NSRange range;

/**
 *  这段特殊文字的矩形框(要求数组里面存放CGRect)
 */
@property (nonatomic, strong) NSArray *rects;
@end
