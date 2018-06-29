//
//  HCTwoClassBaseViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/23.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCTwoClassBaseViewController.h"

@interface HCTwoClassBaseViewController ()


@end

@implementation HCTwoClassBaseViewController

- (void)setupRefresh:(UITableView*)tableView{
    
    [tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerReleaseToRefreshText = @"松开马上刷新";
    tableView.headerRefreshingText = @"刷新中,请稍候";
    
    tableView.footerPullToRefreshText = @"上拉加载更多数据";
    tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    tableView.footerRefreshingText = @"更新中....";
    tableView.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-49);
    
}

- (void)headerRefreshing
{
    NSLog(@"header refreshing begin");
}

- (void)footerRefreshing
{
     NSLog(@"footer refreshing begin");
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
