//
//  WebUserViewController.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/1.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "WebUserViewController.h"
#import "HCNodataView.h"
@interface WebUserViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *userInfo;
@property (nonatomic,strong)UIView *mNoView;
@end

@implementation WebUserViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatBackButton];
    self.userInfo = [[UIWebView alloc]init];
    self.userInfo.delegate = self;
    self.userInfo.frame = CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64);
     [self.view addSubview:self.userInfo];
    
    self.mNoView = [HCNodataView getWebNetWorkErrorView:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    self.mNoView.backgroundColor = [UIColor whiteColor];
    self.mNoView.hidden = YES;
    [self.view addSubview:self.mNoView];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mNoView addGestureRecognizer:bgTap];

    if (_type == 1) {
        self.title = @"我的优惠券";
    }else{
        self.title = @"页面加载中...";
    }
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.requestURL]];
        [self.userInfo loadRequest:request];
}

- (void)bgTappedAction:(UIGestureRecognizer *)gest
{
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.requestURL]];
    [self.userInfo loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"couponDetailPage"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"couponDetailPage"];
    self.userInfo = nil;
    self.title = nil;

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_type == 2) {
        NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = title;
    }
    
}

#pragma mark -error
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.mNoView.hidden = NO;
}

- (void)back:(UIButton*)sender{
    
    if (_type == 1) {
         [self.navigationController popViewControllerAnimated:YES];
    }else{
         [self.navigationController popToViewController:[self.navigationController.viewControllers HCObjectAtIndex:([self.navigationController.viewControllers count]-3)] animated:YES];
    }
}


@end
