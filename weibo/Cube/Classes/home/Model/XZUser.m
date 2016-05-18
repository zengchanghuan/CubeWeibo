//
//  XZUser.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZUser.h"

@implementation XZUser

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
