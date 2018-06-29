//
//  HCRequestAllPage.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/26.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCRequestAllPage.h"
#import "UIImage+RTTint.h"
#import "UIAlertView+ITTAdditions.h"
#import "User.h"
@implementation HCRequestAllPage

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [self dataTitlt];
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _isShowing = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _isShowing = NO;
}

- (void)dataTitlt
{
    _strNetwork = @"请连接网络";
    _mExchangeTitle = @"请输入兑换码";
    _strNetworkTitle = @"网络不给力";
}

#pragma mark - PrivateVariable
- (void)setupRefresh:(UITableView*)tableView
{
    [tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerReleaseToRefreshText = @"松开马上刷新";
    tableView.headerRefreshingText = @"刷新中,请稍候";
    
    tableView.footerPullToRefreshText = @"上拉加载更多数据";
    tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    tableView.footerRefreshingText = @"更新中....";
}

- (UIView *)defaultFooterView
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//2.6添加的
- (BOOL)nav:(BOOL)hidden{
    [super.navigationController setNavigationBarHidden:hidden animated:TRUE];
    return hidden;
}


- (void)removeEmptyView
{
    UIView *view = [self baseView];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tv = (UITableView *)view;
        tv.tableFooterView = [self defaultFooterView];
    } else {
        [self.emptyView removeFromSuperview];
    }
    self.emptyView = nil;
}

- (void)reloadEmptyView
{
    UIView *view = [self baseView];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tv = (UITableView *)view;
        tv.tableFooterView = self.emptyView;
    } else {
        [view addSubview:self.emptyView];
    }
}

- (NSString*)emptyImageName
{
    return @"networkAnomaly";
}

- (UIView *)baseView
{
    UIScrollView *view = [self matchedScrollView];
    if (view) {
        return view;
    }
    return self.view;
}

- (EmptyDefaultView*)emptyView
{
    if (_emptyView == nil) {
        UIView *view = [self baseView];
        _emptyView = [self emptyViewFromRelateView:view];
    }
    _emptyView.lblDescription.text = _strName;
    return _emptyView;
}

- (UIScrollView *)matchedScrollView
{
    int n = (int)[self.view subviews].count;
    for (int i = 0; i< n; i++){
    UIScrollView *view = [[self.view subviews] HCObjectAtIndex:i];
    if ([view isKindOfClass:[UIScrollView class]] && view.frame.size.height > (self.view.frame.size.height/2))
    {return view;}}
    return nil;
}

- (CGSize)emptyViewSize
{
    return CGSizeMake(HCSCREEN_WIDTH, (HCSCREEN_HEIGHT-64)/1.35);
}

- (EmptyDefaultView *)emptyViewFromRelateView:(UIView *)view
{
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    if ([view isKindOfClass:[UITableView class]]) {
        width = [self emptyViewSize].width;
        height = [self emptyViewSize].height;
    } else {
    }
    EmptyDefaultView *resultView = [[EmptyDefaultView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    resultView.backgroundColor = [UIColor clearColor];
    return resultView;
}

- (void)headerRefreshing
{
    NSLog(@"header refreshing begin");
}

- (void)footerRefreshing
 {
    NSLog(@"footer refreshing begin");
}

- (void)UIviewcontroller:(UIViewController*)controller
{
    controller = [[UIViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}





@end
