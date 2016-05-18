//
//  XZStatusPhotosView.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSInteger)count;
@end
