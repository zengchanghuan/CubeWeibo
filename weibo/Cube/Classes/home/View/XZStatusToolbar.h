//
//  XZStatusToolbar.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZStatus;
@interface XZStatusToolbar : UIView
@property (nonatomic, strong) XZStatus *status;
+(instancetype)toolbar;
@end
