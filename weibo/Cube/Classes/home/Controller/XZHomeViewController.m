//
//  XZHomeViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/3/22.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZHomeViewController.h"
#import "XZDropdownMenu.h"
#import "XZTitleMenuViewController.h"
#import "XZTitleButton.h"
#import "XZAccountTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "XZUser.h"
#import "XZStatus.h"
#import "MJExtension.h"
#import "XZLoadMoreFooter.h"
#import "XZStatusFrame.h"
#import "XZStatusTableViewCell.h"
#import "XZHttpTool.h"
#import "MJRefresh.h"
#import "XZStatusTool.h"
@interface XZHomeViewController ()<XZDropdownMenuDelegate>
/**
 *  微博数组（里面放的都是XZStatusFrames模型，一个XZStatusFrames就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation XZHomeViewController

-(NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [[NSMutableArray alloc] init];
    }
    return _statusFrames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = XZColor(211, 211, 211);

    [self setUpNav];
    
    [self setUpUserInfo];
    
    [self setupDownRefresh];
    
    [self setupRefresh];

//    // 获得未读数
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
//    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

/**
 *  获得未读数
 */
- (void)setupUnreadCount
{
    
    // 2.拼接请求参数
    XZAccount *account = [XZAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    
    [XZHttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 设置提醒数字(微博的未读数)
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSError *error) {
        XZLog(@"%@",error);
    }];
}
/**
 *  集成上拉刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

/**
 *  集成下拉刷新控件
 */
- (void)setupDownRefresh
{
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    [self.tableView headerBeginRefreshing];

}
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *framesArray = [NSMutableArray array];
    for (XZStatus *status in statuses) {
        XZStatusFrame *f = [[XZStatusFrame alloc] init];
        f.status = status;
        [framesArray addObject:f];
    }
    return framesArray;
}

/**
 *  显示最新微博的数量
 *
 *  @param count 最新微博的数量
 */
- (void)showNewStatusCount:(NSInteger)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%ld条新的微博数据", (long)count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}
/**
 *  加载最新的微博数据
 */
- (void)loadNewStatus
{
    XZAccount *account = [XZAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    //取出最前面的微博（ID最大的微博）
    XZStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
        
    }
    
    //定义一个block处理返回的字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses){
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XZStatus objectArrayWithKeyValuesArray:statuses];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 显示最新微博的数量
        [self showNewStatusCount:newStatuses.count];
    };
    
    
    //先尝试从数据库中加载微博数据
    NSArray *statuses = [XZStatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
    } else {
        [XZHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
            [XZStatusTool savaStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
        } failure:^(NSError *error) {
            XZLog(@"请求失败-%@",error);
            [self.tableView headerEndRefreshing];
        }];
    }
    
    
    
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    
    // 2.拼接请求参数
    XZAccount *account = [XZAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    XZStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 处理字典数据
    void (^dealingResult)(NSArray *) = ^(NSArray *statuses) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XZStatus objectArrayWithKeyValuesArray:statuses];
        
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    };

    
    //加载沙盒中的数据
    NSArray *statuses = [XZStatusTool statusesWithParams:params];
    if (statuses.count) {
        dealingResult(statuses);
    } else {
        //发送请求
        [XZHttpTool get:@"" params:params success:^(id json) {
            //缓存新浪返回的字典数组
            [XZStatusTool savaStatuses:json[@"statuses"]];
            dealingResult(json[@"statuses"]);
        } failure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
        }];
    }

}
//设置导航用户栏

- (void)setUpNav
{
    /* 设置导航栏上面的内容 */
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    
    XZTitleButton *titleButton = [[XZTitleButton alloc] init];
    NSString *name = [XZAccountTool account].name;
    [titleButton setTitle:name?name: @"首页" forState:UIControlStateNormal];
    
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;

}

//获得用户信息

- (void)setUpUserInfo
{
    //https://api.weibo.com/2/users/show.json
    //access_token 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    //uid int64 需要查询的用户ID
    
    XZAccount *account = [XZAccountTool account];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [XZHttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        XZUser *user = [XZUser objectWithKeyValues:json];
        [titleButton setTitle:user.name forState:0];
        account.name = user.name;
        [XZAccountTool saveAccount:account];
        
    } failure:^(NSError *error) {
        XZLog(@"请求失败-%@", error);

    }];
    
}
/**
 *  标题点击
 */
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    XZDropdownMenu *menu = [XZDropdownMenu menu];
    menu.menuDelegate = self;
    
    // 2.设置内容
    XZTitleMenuViewController *vc = [[XZTitleMenuViewController alloc] init];
    vc.view.height = 150;
    vc.view.width = 150;
    menu.contentController = vc;
    
    // 3.显示
    [menu showFrom:titleButton];
}
- (void)friendSearch
{
}

- (void)pop
{
}

#pragma mark - XZDropdownMenuDelegate
- (void)dropdownMenuDidDismiss:(XZDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}
- (void)dropdownMenuDidShow:(XZDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZStatusTableViewCell *cell = [XZStatusTableViewCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;

}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XZStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}
@end
