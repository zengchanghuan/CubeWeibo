//
//  XZEmotion.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotion.h"
#import "MJExtension.h"

@interface XZEmotion () <NSCoding>

@end

@implementation XZEmotion
MJCodingImplementation
/**
 *  从文件中解析对象时调用
 */
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.chs = [decoder decodeObjectForKey:@"chs"];
//        self.png = [decoder decodeObjectForKey:@"png"];
//        self.code = [decoder decodeObjectForKey:@"code"];
//    }
//    return self;
//}

/**
 *  将对象写入文件的时候调用
 */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.chs forKey:@"chs"];
//    [encoder encodeObject:self.png forKey:@"png"];
//    [encoder encodeObject:self.code forKey:@"code"];
//}

/**
 *  用来比较两个对象是否一样,比较的内在地址,isEqualToString比较的是内容
 */

-(BOOL)isEqual:(XZEmotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}
@end
