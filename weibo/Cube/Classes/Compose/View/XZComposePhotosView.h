//
//  XZComposePhotosView.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZComposePhotosView : UIView

@property (nonatomic, strong, readonly) NSMutableArray *photos;

- (void)addPhoto:(UIImage *)photo;

@end
