//
//  XZOAuthViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZOAuthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XZAccount.h"
#import "XZAccountTool.h"

@interface XZOAuthViewController ()<UIWebViewDelegate>
@end
@implementation XZOAuthViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //webView加载登录页面
    //请求地址：https://api.weibo.com/oauth2/authorize
    //请求参数：client_id redirect_uri 必选
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", XZAppKey, XZRedirectURI];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
}

#pragma mark -UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中……"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获得URL
    NSString *url = request.URL.absoluteString;
    
    //判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        NSLog(@"url = %@\n,code = %@\n",url,code);
        //利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        //禁止回调
        return NO;
    }
    return YES;
}

/**
 http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html
 *  OAuth在"客户端"与"服务提供商"之间，设置了一个授权层（authorization layer）。"客户端"不能直接登录"服务提供商"，只能登录授权层，以此将用户与客户端区分开来。"客户端"登录授权层所用的令牌（token），与用户的密码不同。用户可以在登录的时候，指定授权层令牌的权限范围和有效期。
 "客户端"登录授权层以后，"服务提供商"根据令牌的权限范围和有效期，向"客户端"开放用户储存的资料。
 （A）用户打开客户端以后，客户端要求用户给予授权。
 （B）用户同意给予客户端授权。
 （C）客户端使用上一步获得的授权，向认证服务器申请令牌。
 （D）认证服务器对客户端进行认证以后，确认无误，同意发放令牌。
 （E）客户端使用令牌，向资源服务器申请获取资源。
 （F）资源服务器确认令牌无误，同意向客户端开放资源。
 不难看出来，上面六个步骤之中，B是关键，即用户怎样才能给于客户端授权。有了这个授权以后，客户端就可以获取令牌，进而凭令牌获取资源。

 客户端必须得到用户的授权（authorization grant），才能获得令牌（access token）。OAuth 2.0定义了四种授权方式。
 授权码模式（authorization code）
 简化模式（implicit）
 密码模式（resource owner password credentials）
 客户端模式（client credentials）

 授权码模式（authorization code）是功能最完整、流程最严密的授权模式。它的特点就是通过客户端的后台服务器，与"服务提供商"的认证服务器进行互动。步骤如下：
 （A）用户访问客户端，后者将前者导向认证服务器。
 （B）用户选择是否给予客户端授权。
 （C）假设用户给予授权，认证服务器将用户导向客户端事先指定的"重定向URI"（redirection URI），同时附上一个授权码。
 （D）客户端收到授权码，附上早先的"重定向URI"，向认证服务器申请令牌。这一步是在客户端的后台的服务器上完成的，对用户不可见。
 （E）认证服务器核对了授权码和重定向URI，确认无误后，向客户端发送访问令牌（access token）和更新令牌（refresh token）。

 下面是上面这些步骤所需要的参数。
 A步骤中，客户端申请认证的URI，包含以下参数：
 response_type：表示授权类型，必选项，此处的值固定为"code"
 client_id：表示客户端的ID，必选项
 redirect_uri：表示重定向URI，可选项
 scope：表示申请的权限范围，可选项
 state：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。


 *
 *  @param code 表示授权码，必选项。该码的有效期应该很短，通常设为10分钟，客户端只能使用该码一次，否则会被授权服务器拒绝。该码与客户端ID和重定向URI，是一一对应关系。
 */
- (void)accessTokenWithCode:(NSString *)code
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    /*
     response_type：表示授权类型，必选项，此处的值固定为"code"
     client_id：表示客户端的ID，必选项
     redirect_uri：表示重定向URI，可选项
     scope：表示申请的权限范围，可选项
     state：表示客户端的当前状态，可以指定任意值，认证服务器会原封不动地返回这个值。

     */
    
    params[@"client_id"] = @"4135991501";
    params[@"client_secret"] = @"6e47fbc1dc1031648b5cc00c6988e8ca";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.baidu.com";
    
    //code：表示授权码，必选项。该码的有效期应该很短，通常设为10分钟，客户端只能使用该码一次，否则会被授权服务器拒绝。该码与客户端ID和重定向URI，是一一对应关系。
    params[@"code"] = code;
    
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        XZLog(@"请求成功%@",responseObject);
        [MBProgressHUD hideHUD];
        
        XZAccount *account = [XZAccount accountWithDict:responseObject];
        
        //存储账号信息
        [XZAccountTool saveAccount:account];
        
        //切换窗口的要根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        XZLog(@"请求失败-%@",error);
    }];
}



@end
