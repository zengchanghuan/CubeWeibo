//
//  XZLoadMoreFooter.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZLoadMoreFooter.h"

@implementation XZLoadMoreFooter
+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XZLoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
