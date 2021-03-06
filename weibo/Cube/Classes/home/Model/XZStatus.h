//
//  XZStatus.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XZUser;
@interface XZStatus : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**
 *  微博的信息内容，带有属性信息
 */
@property (nonatomic, copy) NSAttributedString *attributedText;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) XZUser *user;

/**	string	微博创建时间*/
@property (nonatomic, copy) NSString *created_at;

/**	string	微博来源*/
@property (nonatomic, copy) NSString *source;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) XZStatus *retweeted_status;

/**
 *  被转发的原微博信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)
 */
@property (nonatomic, copy) NSAttributedString *retweetedAttributedText;
/**	int	转发数*/
@property (nonatomic, assign) int reposts_count;
/**	int	评论数*/
@property (nonatomic, assign) int comments_count;
/**	int	表态数*/
@property (nonatomic, assign) int attitudes_count;

//+ (instancetype)statusWithDict:(NSDictionary *)dict;


@end
