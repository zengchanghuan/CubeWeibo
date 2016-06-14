//
//  XZStatusTool.h
//  Cube
//
//  Created by ZengChanghuan on 16/6/14.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//  处理微博数据的缓存

#import <Foundation/Foundation.h>

@interface XZStatusTool : NSObject

/**
 *  根据请求参数去沙盒中加载缓存的微博数据
 *
 *  @param params 请求参数
 */
+ (NSArray *)statusesWithParams:(NSDictionary *)params;

/**
 *  存储微博数据到沙盒中
 *
 *  @param statuses 需要存储的微博数据
 */
+ (void)savaStatuses:(NSArray *)statuses;


@end
