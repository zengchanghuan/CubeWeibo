//
//  XZSearchBar.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/23.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZSearchBar.h"

@implementation XZSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;

    }
    return self;
}
+ (instancetype)searchBar
{
    return [[self alloc] init];
}
@end
