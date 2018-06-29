//
//  ForumController.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/3/15.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "ForumController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "HCSecForumController.h"
#import "HCNodataView.h"
//#import <WebKit/WKWebView.h>
//#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WebKit.h>
@interface ForumController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,WKUIDelegate,WKNavigationDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NJKWebViewProgress     * _progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView * _progressView;
@property (nonatomic, strong) UIWebView *forumWebView;
@property (nonatomic, strong) WKWebView *forumWkwebview;
@property (nonatomic, strong) UIView *mNoView;
@property (nonatomic, strong) NSURL *telUrl;
@end


@implementation ForumController
- (void)viewDidLoad {
    [super viewDidLoad];
    //__weak ForumController *bSelf = self;
    self.title = @"社区";
  
   
    if (IOS_VERSION_8_OR_ABOVE) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        

        self.forumWkwebview = [[WKWebView alloc]initWithFrame: CGRectMake(0,64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64-49) configuration:config];
        self.forumWkwebview.UIDelegate = self;
        self.forumWkwebview.navigationDelegate = self;
        [self.view addSubview:self.forumWkwebview];
         [self.forumWkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
       // dispatch_async(DefaultQueue, ^{
            [self.forumWkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Forum_URL]]];
        //});
    }else{
        self.forumWebView = [[UIWebView alloc]init];
        self.forumWebView.delegate = self;
        self.forumWebView.frame = CGRectMake(0,64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64-49);
        [self.view addSubview:self.forumWebView];
       // dispatch_async(DefaultQueue, ^{
            [self.forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Forum_URL]]];
       // });
    }
    [self initProcessBar];
    self.mNoView = [HCNodataView getWebNetWorkErrorView:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    self.mNoView.backgroundColor = [UIColor whiteColor];
    self.mNoView.hidden = YES;
    [self.view addSubview:self.mNoView];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mNoView addGestureRecognizer:bgTap];
    // Do any additional setup after loading the view.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.forumWkwebview) {
            [self._progressView setAlpha:1.0f];
            [self._progressView setProgress:self.forumWkwebview.estimatedProgress animated:YES];
            
            if(self.forumWkwebview.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self._progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self._progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)initProcessBar
{
    self._progressProxy = [[NJKWebViewProgress alloc] init];
    
    self.forumWebView.delegate = self._progressProxy;

    
    self._progressProxy.webViewProxyDelegate = self;
    self._progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect  navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect  barFrame = CGRectMake(0 , navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self._progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self._progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 *  NJKWebViewProgressDelegate
 *
 *  @param webViewProgress 进度条
 *  @param progress        进度值
 */
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
    [self._progressView setProgress:progress animated:YES];
  // NSLog(@"进度条加载更新");
}
/**
 *  tabBarControllerDelegate
 *
 *  @param tabBarController 当前界面对应的tabbar
 *  @param viewController   选择的viewcontroller
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [[NSUserDefaults standardUserDefaults]setObject:@3 forKey:@"selctcontroller"];
   // [HCAnalysis HCClick:@"ForumPageClick" WithName:@"论坛界面"];
     [HCAnalysis HCclick:@"TabbarClick"WithProperties:@{@"TabName":@"ForumPage"}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"ForumController"];
    [self._progressView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{  
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"ForumController"];
     [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"firstlaunch"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.navigationController.navigationBar addSubview:self._progressView];
   
    self.tabBarController.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  //  NSLog(@"加载完成的 url %@",url);
   // self.tabBarController.tabBar .hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)bgTappedAction:(UIGestureRecognizer*)gesture{
    if (IOS_VERSION_8_OR_ABOVE) {
        [self.forumWkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Forum_URL]]];
    }else{
        
         [self.forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Forum_URL]]];
    }
    
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSLog(@"开始加载");
}
//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //  [SVProgressHUD dismiss];
    NSLog(@"didFinishNavigation");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.mNoView.hidden = NO;
    // NSLog(@"error%@",error);
    NSLog(@"页面加载失败");
}
//这个代理方法表示客户端接收到服务器的响应头。根据respones相关信息，可以决定这次跳转是否可以继续执行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    NSLog(@"客户端接收到服务器的响应头");
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    //接受到服务器跳转请求之后调用
    NSLog(@"接受到服务器跳转请求");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    
    
    self.mNoView.hidden = YES;
    //发送请求之前决定是否跳转
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *telurl = navigationAction.request.URL;
    if (url.length==0||[url isEqualToString:Forum_URL]) {
         decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        HCSecForumController *secForum = [[HCSecForumController alloc]init];
        secForum.requestUrl = url;
        secForum.isHaveRight=YES;
        secForum.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController  pushViewController:secForum animated:YES];
         decisionHandler(WKNavigationActionPolicyCancel);
    }
    //打开打电话
    UIApplication *app = [UIApplication sharedApplication];
    if ([telurl.scheme isEqualToString:@"tel"])
    {
        self.telUrl = telurl;
        if ([app canOpenURL:telurl])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:telurl.resourceSpecifier message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
            [alert show];
            
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //打开跳转appstore
    if ([telurl.absoluteString containsString:@"ituns.apple.com"])
    {
        if ([app canOpenURL:telurl])
        {
            [app openURL:telurl];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    NSLog(@"发送请求之前url%@",url);
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UIApplication *app = [UIApplication sharedApplication];
        [app openURL:self.telUrl];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    NSString *url = [NSString stringWithFormat:@"%@",request.URL];
    if (url.length==0||[url isEqualToString:Forum_URL]) {

    }else{
        HCSecForumController *secForum = [[HCSecForumController alloc]init];
        secForum.requestUrl = url;
        secForum.isHaveRight=YES;
        secForum.hidesBottomBarWhenPushed = YES;
       
        [self.navigationController  pushViewController:secForum animated:YES];
        return NO;
    }

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"加载失败");
    self.mNoView.hidden =NO;
   // [self.view addSubview:self.hcNetworkErrorView];
    
}
- (void)dealloc{
    if (IOS_VERSION_8_OR_ABOVE) {
         [self.forumWkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.mNoView.hidden = YES;
  //  NSString *url = [NSString stringWithFormat:@"%@",self.forumWebView.request.URL];
  //  NSLog(@"开始加载 url %@",url);
    
}
//-(void)back:(id)sender
//{
//    if (IOS_VERSION_8_OR_ABOVE) {
//        if ([self.forumWkwebview canGoBack]) {
//            [self.forumWkwebview goBack];
//        }
//    }else{
//        if ([self.forumWebView canGoBack]) {
//            [self.forumWebView goBack];
//        }
//    }
//   
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
