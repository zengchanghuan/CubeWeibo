//
//  XZSpecial.m
//  Cube
//
//  Created by ZengChanghuan on 16/6/1.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZSpecial.h"

@implementation XZSpecial
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@",self.text,NSStringFromRange(self.range)];
}
@end
