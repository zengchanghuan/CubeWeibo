//
//  XZMessageCenterViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZMessageCenterViewController.h"
#import "AFNetworking.h"
@interface XZMessageCenterViewController ()

@end

@implementation XZMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // style : 这个参数是用来设置背景的，在iOS7之前效果比较明显, iOS7中没有任何效果
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];

    self.navigationItem.rightBarButtonItem.enabled = NO;

}
-(void)urlRequestOperation{
    NSString *URLTmp = @"http://ip.taobao.com/service/getIpInfo.php?ip=myip";
    NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
    //    [URLTmp stringByAddingPercentEncodingWithAllowedCharacters:(nonnull NSCharacterSet *)]
    URLTmp = URLTmp1;
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"Success: %@", operation.responseString);
         NSString *requestTmp = [NSString stringWithString:operation.responseString];
         NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
         //系统自带JSON解析
         NSDictionary *resultDic =
         [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"aaaaaaa=====%@",resultDic);
         UILabel * label1 =
         [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 200, 30)];
         label1.backgroundColor = [UIColor yellowColor];
         label1.text = [[resultDic objectForKey:@"data"] objectForKey:@"ip"];
         [self.view addSubview:label1];
         UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 200, 30)];
         label2.backgroundColor = [UIColor yellowColor];
         label2.text = [[resultDic objectForKey:@"data"] objectForKey:@"city"];
         [self.view addSubview:label2];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Failure: %@", error);
     }];
    [operation start];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)composeMsg
{
    NSLog(@"composeMsg");
}

@end
