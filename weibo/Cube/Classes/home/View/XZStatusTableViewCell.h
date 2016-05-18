//
//  XZStatusTableViewCell.h
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZStatusFrame;

@interface XZStatusTableViewCell : UITableViewCell

@property (nonatomic, strong) XZStatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
