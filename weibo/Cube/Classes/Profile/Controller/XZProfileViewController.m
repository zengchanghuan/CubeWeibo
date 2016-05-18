//
//  XZProfileViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZProfileViewController.h"

@interface XZProfileViewController ()

@end

@implementation XZProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    NSLog(@"XZDiscoverViewController");

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:self action:@selector(setting)];

}

- (void)setting
{
    NSLog(@"setting");
}

@end
