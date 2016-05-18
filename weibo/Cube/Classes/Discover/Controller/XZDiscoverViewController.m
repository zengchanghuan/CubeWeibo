//
//  XZDiscoverViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZDiscoverViewController.h"
#import "XZSearchBar.h"

@interface XZDiscoverViewController ()

@end

@implementation XZDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //创建搜索框
    XZSearchBar *searchBar = [XZSearchBar searchBar];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
}


@end
