//
//  XZAccountTool.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZAccountTool.h"
#define CBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation XZAccountTool
+(void)saveAccount:(XZAccount *)account
{
    //将返回的账号字典数据存存进沙盒
    [NSKeyedArchiver archiveRootObject:account toFile:CBAccountPath];
    
    
}

+ (XZAccount *)account
{
    XZAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:CBAccountPath];
    
    //验证账号是否过期
    
    //过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    
    //获得过期时间
    NSDate *expiresTime = [account.create_time dateByAddingTimeInterval:expires_in];
    
    //获得当前时间
    NSDate *now = [NSDate date];
    
    //如果 now >= expiresTime 过期
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) {
        return nil;
    }
    return account;
}

@end
