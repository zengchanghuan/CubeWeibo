//
//  XZAccount.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZAccount : NSObject<NSCoding>

/**
 *  用于调用access_token，接口获取授权后的access_token
 */
@property (nonatomic, copy) NSString *access_token;

/**
 *  access_token的生命周期，单位是秒数
 */
@property (nonatomic, copy) NSNumber *expires_in;

/**
 *  当前授权用户的UID
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  账号的创建时间
 */
@property (nonatomic, strong) NSDate *create_time;


@property (nonatomic, copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
