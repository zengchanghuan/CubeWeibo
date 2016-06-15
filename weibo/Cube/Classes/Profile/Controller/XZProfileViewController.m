//
//  XZProfileViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZProfileViewController.h"
#import "SDWebImageManager.h"

@interface XZProfileViewController ()

@end

@implementation XZProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 字节大小
    int byteSize = [SDImageCache sharedImageCache].getSize;
    // M大小
    double size = byteSize / 1000.0 / 1000.0;
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(%.1fM)", size];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:0 target:self action:@selector(clearCache)];
    
    [self fileOperation];
}

- (void)fileOperation
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 缓存路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [mgr removeItemAtPath:caches error:nil];
    
    XZLog(@"%ld", (long)[@"/Users/apple/Desktop/ios就业指导" fileSize]);
}

/**
 NSString *filepath = [caches stringByAppendingPathComponent:@"cn.heima.----2-/Cache.db-wal"];
 
 // 获得文件\文件夹的属性(注意:文件夹是没有大小属性的,只有文件才有大小属性)
 NSDictionary *attrs = [mgr attributesOfItemAtPath:filepath error:nil];
 HWLog(@"%@ %@", caches, attrs);
 */

- (void)clearCache
{
    // 提醒
    UIActivityIndicatorView *circle = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [circle startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:circle];
    
    // 清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    
    // 显示按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:0 target:self action:@selector(clearCache)];
    self.navigationItem.title = [NSString stringWithFormat:@"缓存大小(0M)"];
}

- (void)setting
{
//    HWTest1ViewController *test1 = [[HWTest1ViewController alloc] init];
//    test1.title = @"test1";
//    [self.navigationController pushViewController:test1 animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

@end
