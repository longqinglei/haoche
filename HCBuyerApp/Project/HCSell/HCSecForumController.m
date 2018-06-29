//
//  HCSecForumController.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/4/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCSecForumController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "NavView.h"
#import "HCNodataView.h"
#import "SensorsAnalyticsSDK.h"
#import <WebKit/WebKit.h>

@interface HCSecForumController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIView *mNoView;
@property (nonatomic, strong) NJKWebViewProgress     * _progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView * _progressView;
@property (nonatomic, strong) UIWebView *forumWebView;
@property (nonatomic, strong) NavView *mNavView;
@property (nonatomic, strong) WKWebView *forumWkwebview;
@property (nonatomic, strong) NSURL *telUrl;
@property (nonatomic)NSTimeInterval starttime;

@end

@implementation HCSecForumController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  creatBackButton];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (self.titleType==0) {
    self.title = @"社区";
    }
    //_weak HCSecForumController *bSelf = self;

    if (IOS_VERSION_8_OR_ABOVE) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        
        self.forumWkwebview = [[WKWebView alloc]initWithFrame: CGRectMake(0,64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64) configuration:config];
        self.forumWkwebview.UIDelegate = self;
        self.forumWkwebview.navigationDelegate = self;
        [self.view addSubview:self.forumWkwebview];
        [self.forumWkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        if (self.titleType==2) {
            [self.forumWkwebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }
           // dispatch_async(DefaultQueue, ^{
                [self.forumWkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
           // });
    }else{
        self.forumWebView = [[UIWebView alloc]init];
        self.forumWebView.delegate = self;
        self.forumWebView.frame = CGRectMake(0,64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64);
        [self.view addSubview:self.forumWebView];
        //dispatch_async(DefaultQueue, ^{
            [self.forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
      // });
    }
    _mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    _mNavView.labelText.text = self.title;
    _mNavView.hidden = YES;
    [self.view addSubview:self.mNavView];
    
    [self initProcessBar];
    if (self.isHaveRight==YES) {
       [self creatRightBtn];
    }
   
    self.mNoView = [HCNodataView getWebNetWorkErrorView:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    self.mNoView.backgroundColor = [UIColor whiteColor];
    self.mNoView.hidden = YES;
    [self.view addSubview:self.mNoView];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mNoView addGestureRecognizer:bgTap];
    

    // Do any additional setup after loading the view.
}
- (void)bgTappedAction:(UIGestureRecognizer*)gesture{
    if (IOS_VERSION_8_OR_ABOVE) {
        [self.forumWkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    }else{
        
        [self.forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    }
    
    
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
        
    }  else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.forumWkwebview) {
            self.title = self.forumWkwebview.title;
            _mNavView.labelText.text = self.forumWkwebview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatRightBtn{
    
    [self addItemWithImageName:nil frame:CGRectMake(0, 0, 35, 30) title:@"关闭" selector:@selector(backForumHomePage) location:NO];
}

- (void)backForumHomePage{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self._progressView setProgress:progress animated:YES];
    if (self.titleType==2) {
        self.title = [self.forumWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        _mNavView.labelText.text = self.title;
    }
    // NSLog(@"进度条加载更新");
}
/**
 *  tabBarControllerDelegate
 *
 *  @param tabBarController 当前界面对应的tabbar
 *  @param viewController   选择的viewcontroller
 */
//-(void)bgTappedAction:(UITapGestureRecognizer *)tap
//{
//    [self requestVehicleInfoBy:self.source_id];
//
//    [self.dlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0]];
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     _mNavView.hidden = NO;
    [HCAnalysis controllerEnd:@"SecForumController"];
    [self._progressView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"SecForumController"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar addSubview:self._progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //  NSLog(@"加载完成的 url %@",url);
    // self.tabBarController.tabBar .hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
   // NSDate *dateNow =[NSDate date];
   // DLog(@"webview持续时间%f",[dateNow timeIntervalSince1970]-_starttime);
    
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDate *dateNow =[NSDate date];
    _starttime = [dateNow timeIntervalSince1970];
   // NSLog(@"开始加载");
}
//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 //   NSDate *dateNow =[NSDate date];
    //DLog(@"wkwebview持续时间%f",[dateNow timeIntervalSince1970]-_starttime);
    //NSLog(@"didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // NSLog(@"error%@",error);
    self.mNoView.hidden = NO;
   // NSLog(@"页面加载失败");
}
//这个代理方法表示客户端接收到服务器的响应头。根据respones相关信息，可以决定这次跳转是否可以继续执行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    //NSLog(@"客户端接收到服务器的响应头");
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    //接受到服务器跳转请求之后调用
  //  NSLog(@"接受到服务器跳转请求");
}
//wkwebview加载网页之后解决里面的连接无法点击
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //发送请求之前决定是否跳转
  // NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     self.mNoView.hidden = YES;
    NSURL *url = navigationAction.request.URL;
    decisionHandler(WKNavigationActionPolicyAllow);
    UIApplication *app = [UIApplication sharedApplication];
    //打开打电话功能
    if ([url.scheme isEqualToString:@"tel"])
    {
        self.telUrl = url;
        if ([app canOpenURL:url])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:url.resourceSpecifier message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
            [alert show];
           
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    //打开跳转appstore
    if ([url.absoluteString containsString:@"ituns.apple.com"])
    {
        if ([app canOpenURL:url])
        {
            [app openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
         UIApplication *app = [UIApplication sharedApplication];
        [app openURL:self.telUrl];
    }
}
- (void)dealloc{
    if (IOS_VERSION_8_OR_ABOVE) {
        [self.forumWkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
        if (self.titleType==2) {
             [self.forumWkwebview removeObserver:self forKeyPath:@"title"];
        }
    }
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
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.mNoView.hidden = YES;
    //NSString *url = [NSString stringWithFormat:@"%@",self.forumWebView.request.URL];
    //NSLog(@"开始加载 url %@",url);
    NSDate *dateNow =[NSDate date];
    _starttime = [dateNow timeIntervalSince1970];
}
-(void)back:(id)sender
{
    if (IOS_VERSION_8_OR_ABOVE) {
        if ([self.forumWkwebview canGoBack]) {
            [self.forumWkwebview goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if ([self.forumWebView canGoBack]) {
            [self.forumWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


@end
