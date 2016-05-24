//
//  XZTextPart.m
//  Cube
//
//  Created by ZengChanghuan on 16/5/23.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZTextPart.h"

@implementation XZTextPart
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@",self.text, NSStringFromRange(self.range)];
}
@end
