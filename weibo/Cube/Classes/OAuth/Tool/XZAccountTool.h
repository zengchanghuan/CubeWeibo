//
//  XZAccountTool.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//  处理所有账号相关的操作：存储账号 取出账号 验证账号


#import <Foundation/Foundation.h>
#import "XZAccount.h"
@interface XZAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(XZAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型 （如果账号过期，返回Nil）
 */
+ (XZAccount *)account;
@end
