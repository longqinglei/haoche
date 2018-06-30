//
//  VehicleDetailViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/5/11.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehicleDetailViewController.h"
#import "VehicleCompareViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CouponListViewController.h"
#import "CustomURLCache.h"
#import "UIImage+RTTint.h"
#import "HCNodataView.h"
#import "BizMySaleVehicle.h"
//#import "UMSocial.h"
//#import "UMSocialUIManager.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIPlatformItem.h>

#import "Vehicle.h"
#import "Banner.h"
#import "BizRequestCollection.h"
#import "BizRequestCollection.h"
#import "UIView+ITTAdditions.h"
#import "BizTransactionApply.h"
#import "BizCity.h"
#import "LoginViewController.h"
#import "BizUser.h"
#import "NavView.h"
#import "BizCity.h"
#import "NSDate+ITTAdditions.h"
#import "HomePromoteModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
//@import WebKit;
@interface VehicleDetailViewController()<UIWebViewDelegate, UIGestureRecognizerDelegate, NJKWebViewProgressDelegate,UIAlertViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) id sharedObj;

@property (nonatomic, strong) UIView    * hcNetworkErrorView;
@property (nonatomic, strong) UIView * mBalloonView;
@property (nonatomic, strong) UIWebView * dlWebView;
@property (nonatomic, strong) WKWebView * WkWebView;
//@property (nonatomic, strong) NoView* textView ;
@property (nonatomic, strong) NSURL *telUrl;

@property (nonatomic, strong) NJKWebViewProgress     * _progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView * _progressView;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIBarButtonItem *collectionBtn;

@property (nonatomic, strong) UIBarButtonItem *compareItem;
@property (nonatomic, strong) UIBarButtonItem *consultItem;


@property (nonatomic, strong) NSTimer* mTime;
@property (nonatomic, strong) NavView *mNavView;

@property (nonatomic) BOOL isBtnClick;

@property (nonatomic, strong) NSMutableDictionary *miniapp;


@end

@implementation VehicleDetailViewController

- (NSMutableDictionary *)miniapp{
    if (_miniapp == nil) {
        _miniapp = [NSMutableDictionary dictionary];
    }
    return _miniapp;
}

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"VehicleDetailPage"];
    [self.navigationController.navigationBar addSubview:self._progressView];
}



-(void)viewWillDisappear:(BOOL)animated
{
    if (self.mSharedType==0) {
        self.mNavView.hidden = NO;
    }
    [super viewWillDisappear:animated];
    _mNavView.labelText.text = self.title;//自定义navbar
    [HCAnalysis controllerEnd:@"VehicleDetailPage"];
    [self._progressView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self  creatBaseView];
    [self  creatBackButton];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //__weak VehicleDetailViewController *bSelf = self;
    if (IOS_VERSION_8_OR_ABOVE) {
        WKUserContentController* userContentController = WKUserContentController.new;
        WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource: @"document.cookie ='TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2';"injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
          [userContentController addUserScript:cookieScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 通过JS与webview内容交互
        config.userContentController = userContentController;;
        self.WkWebView = [[WKWebView alloc]initWithFrame: CGRectMake(0, kNavHegith, HCSCREEN_WIDTH, HCSCREEN_HEIGHT- kNavHegith - kTabbarBottom) configuration:config];
        self.WkWebView.UIDelegate = self;
        self.WkWebView.navigationDelegate = self;
        [self.view addSubview:self.WkWebView];
        [self.WkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
       //dispatch_async(DefaultQueue, ^{
            [self.WkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
       // });
    }else{
        if (self.dlWebView == nil) {
            self.dlWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kNavHegith, HCSCREEN_WIDTH, HCSCREEN_HEIGHT- kNavHegith - kTabbarBottom)];
        }
        self.dlWebView.delegate = self;
        [self.view addSubview:self.dlWebView];
    // dispatch_async(DefaultQueue, ^{
        [self.dlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //});
    }
    [self  initProcessBar];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  // NSDate *dateNow =[NSDate date];
    //_starttime = [dateNow timeIntervalSince1970];
    // NSLog(@"开始加载");
}
//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.VehicleChannel ==nil ) {
        self.VehicleChannel = @"其他";
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // NSLog(@"error%@",error);
    self.hcNetworkErrorView.hidden = NO;
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
    self.hcNetworkErrorView.hidden = YES;
    NSURL *url = navigationAction.request.URL;
    decisionHandler(WKNavigationActionPolicyAllow);
    UIApplication *app = [UIApplication sharedApplication];
    //打开打电话功能
    if ([url.scheme isEqualToString:@"tel"])
    {
       
        if ([app canOpenURL:url])
        {
            self.telUrl = url;
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:self.telUrl];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:url.resourceSpecifier message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
//            [alert show];
            
            
//            decisionHandler(WKNavigationActionPolicyCancel);
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
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==1) {
//      
//    }
//}

- (void)dealloc
{
    if (IOS_VERSION_8_OR_ABOVE) {
        [self.WkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }else{
        NSLog(@"走你 走走走走走啊走");
        self.dlWebView.delegate = nil;
        self.dlWebView = nil;
        self._progressProxy.progressDelegate = nil;
        _hcNetworkErrorView=nil;
        self.view = nil;
        [self.dlWebView stopLoading];
    }
}

#pragma mark - PrivateVariable
-(void)creatBaseView
{
    _hcNetworkErrorView = [HCNodataView getWebNetWorkErrorView:_hcNetworkErrorView];
    _hcNetworkErrorView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [_hcNetworkErrorView addGestureRecognizer:bgTap];
   
    _mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    
    [self.view addSubview:self.mNavView];
}

- (void)initProcessBar
{
    self._progressProxy = [[NJKWebViewProgress alloc] init];
    self.dlWebView.delegate = self._progressProxy;
    self._progressProxy.webViewProxyDelegate = self;
    self._progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect  navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect  barFrame = CGRectMake(0 , navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self._progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self._progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}


#pragma mark - NJKWebViewProgressDelegate
- (void)setSharedBtnByContentTpye:(NSInteger)type sharedObj:(id)sharedObject
{
    self.mSharedType = type;
    self.sharedObj = sharedObject;
    if(type!=0){
        self.mNavView.hidden = YES;
        [self addItemWithImageName:@"share" frame:CGRectMake(0, 0, 40, 40) title:@"" selector:@selector(shareContent:) location:NO];
    }else{
        self.mNavView.hidden = YES;
        self.title = @"";
    }
}

- (void)collection:(UIButton *)collectionBtn
{
    if ([[HCLogin standLog]isLog]) {
        [self panduan];
    }else{
        [self pushToLoginController];
    }
}

- (void)panduan
{
    if (_isBtnClick == YES) {
        _isBtnClick = NO;
        [_collectionButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [self requestCollectionAndrequestGetClick:NO];
    }else{
        [self requestCollectionAndrequestGetClick:YES];
        _isBtnClick = YES;
        
        [_collectionButton setImage:[UIImage imageNamed:@"collectionActivation"] forState:UIControlStateNormal];
        Vehicle *vehicle = (Vehicle *)self.sharedObj;
        if (self.VehicleChannel ==nil ) {
            self.VehicleChannel = @"";
        }

        [HCAnalysis HCclick:@"VehicleCollect" WithProperties:[self createProperties:vehicle]];
    }
   
}

- (void)pushToLoginController
{
    __weak VehicleDetailViewController *bSelf = self;
    LoginViewController *viewController =  [[LoginViewController alloc]init];
    viewController.guidanceFinishBlock = ^(){
        [bSelf panduan];
    };
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = @"登 录";
    viewController.type = 1;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)requestCollectionAndrequestGetClick:(BOOL)reture
{
    [BizRequestCollection requestCollection:_source_id byfinish:^(NSString *esser, NSInteger code) {
        if (code == -1) {
             [self showMsg:@"网络错误" type:FVAlertTypeError];
        }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionNot" object:nil userInfo:nil];
            if (_mBalloonView) {
                 [_mBalloonView removeFromSuperview];
            }
            if (reture) {
                
                _mBalloonView =  [UIView view:YES addView:self.view];
                }else{
                _mBalloonView =  [UIView view:NO addView:self.view];
            }
            NSTimeInterval timeInterval = 1.2 ;
            _mTime = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:)userInfo:nil repeats:NO];
        }
    } reture:reture];
}

- (void)handleMaxShowTimer:(NSTimer *)timer
{
    [_mBalloonView removeFromSuperview];
}

- (void)requestVehicleInfoBy:(NSInteger)vehicle_id
{
    [BizMySaleVehicle getVehicleDetailWithVehicleid:vehicle_id finish:^(Vehicle *vehicle, NSInteger code) {
        if (code!=0) {
            
        }else{
            self.vehicle = vehicle;
            self.sharedObj = vehicle;
            [self setSharedBtnByContentTpye:0 sharedObj:vehicle];
            [HCAnalysis HCclick:@"VehicleDetailInfo" WithProperties:[self createProperties:self.vehicle ]];
            if(vehicle.collection_status==1){
                _isBtnClick = YES;
                [_collectionButton setImage:[UIImage imageNamed:@"collectionActivation"] forState:UIControlStateNormal];

            }else{
                _isBtnClick = NO;
               [_collectionButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            }
        }
    }];
}
- (NSMutableDictionary*)createProperties:(Vehicle*)vehicle{
     NSMutableDictionary *dict;
    if (!dict) {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:[BizCity getCurCity].cityName forKey:@"city"];
    NSString *vehicleid = [NSString stringWithFormat:@"vehicle.vehicleSourceId"];
    [dict setObject:vehicleid forKey:@"VehicleId"];
    [dict setObject:vehicle.brandName forKey:@"VehicleBrand"];
    [dict setObject:[NSString stringWithFormat:@"%@万",vehicle.seller_price] forKey:@"VehiclePrice"];
    [dict setObject:[NSDate yearsago:vehicle.register_year] forKey:@"VehicleAge"];
    [dict setObject:[NSString stringWithFormat:@"%@万公里",vehicle.miles] forKey:@"VehicleMiles"];
    [dict setObject:vehicle.geerbox_type forKey:@"VehicleGearBox"];
    [dict setObject:self.VehicleChannel forKey:@"VehicleChannel"];
    return dict;
}
- (void)creatCollectBtn
{
    _collectionButton = [self createNavBtn:nil action:@selector(collection:)];//[self createLocationButtionWithTitle:@"" selector:@selector(collection:)];
    _collectionBtn = [[UIBarButtonItem alloc] initWithCustomView:_collectionButton];
}

- (UIButton*)createNavBtn:(NSString*)imageName action:(SEL)action
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName.length!=0||imageName!=nil) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setVehicleCompareBtn
{
   [self creatCollectBtn];
   [self requestVehicleInfoBy:_source_id];
//   self.compareItem = [[UIBarButtonItem alloc]initWithCustomView:[self createNavBtn:@"contrast" action:@selector(compareVehicle:)]];
   self.consultItem = [[UIBarButtonItem alloc]initWithCustomView:[self createNavBtn:@"share" action:@selector(shareContent:)]];
   [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: self.consultItem,_collectionBtn,nil]];
}

- (void)compareVehicle:(id)sender
{
    VehicleCompareViewController *nextViewController =[[VehicleCompareViewController alloc]init];
    nextViewController.title = @"比一比";
    nextViewController.hidesBottomBarWhenPushed = YES;
    [nextViewController setMainVehicle:self.vehicle];
    [self.navigationController pushViewController:nextViewController animated:YES];
}


- (void)shareContent:(id)sender{
    [HCAnalysis HCUserClick:@"detail_shared_click"];
    if (self.mSharedType == 0)
    {
        //1.7日张熙修改分享内容 按三科要求将车辆分享详情由服务器端控制
        Vehicle *vehicle = (Vehicle *)self.sharedObj;
        NSString *sharedUrl = vehicle.share_link;
        NSString *content = vehicle.share_desc;
        NSString *title = vehicle.share_title;
        NSString *coverImgUrl = vehicle.share_image;
        [self doSharedByContent:content defaultContent:content coverImgUrl:coverImgUrl sharedTitle:title sharedUrl:sharedUrl desc:content];
    }
    else if (self.mSharedType == 1)
    {
        Banner *banner = (Banner *)self.sharedObj;
        NSString *share_url = banner.link_url;

        if ([banner.share_image isEqualToString:@""]) {banner.share_image = banner.pic_url;}
        NSString *sharedTitle = (banner.title && [banner.title length] > 0) ? banner.title : @"好车无忧";

            [self doSharedByContent:sharedTitle defaultContent:sharedTitle coverImgUrl:banner.share_image sharedTitle:sharedTitle sharedUrl:share_url desc:banner.title];
    }

}

- (void)doSharedByContent:(NSString *)content
           defaultContent:(NSString *)defaultContent
              coverImgUrl:(NSString *)coverImgUrl
              sharedTitle:(NSString *)sharedTitle
                sharedUrl:(NSString *)sharedUrl
                     desc:(NSString *)desc{
    
    NSArray* imageArray = @[coverImgUrl];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams  SSDKSetupShareParamsByText:content
                                          images:imageArray
                                             url:[NSURL URLWithString:sharedUrl]
                                           title:sharedTitle
                                            type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        [self.miniapp SSDKSetupWeChatMiniProgramShareParamsByTitle:sharedTitle description:content webpageUrl:[NSURL URLWithString:sharedUrl] path:[NSString stringWithFormat:@"/pages/detail/detail?id=%ld",self.vehicle.vehicle_id] thumbImage:[imageArray firstObject] hdThumbImage:[imageArray firstObject] userName:@"gh_7154d801998f" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        SSUIPlatformItem *item = [SSUIPlatformItem itemWithPlatformType:SSDKPlatformSubTypeWechatSession];
        item.platformName = @"好车无忧";
        item.iconNormal = [UIImage imageNamed:@"wechat"];
        item.platformName = @"微信好友";
//        item.iconSimple = [UIImage imageNamed:@"dexi"];
        [item addTarget:self action:@selector(sharesmallapp)];
        
        NSArray * platforms =@[item,@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)];
        [ShareSDK showShareActionSheet:nil customItems:platforms shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            [self didSelectSocialPlatform:platformType];
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [Remind_L showCenterWithText:@"分享成功"];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [Remind_L showCenterWithText:@"分享失败"];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (void)sharesmallapp{
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:self.miniapp
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         [self didSelectSocialPlatform:SSDKPlatformSubTypeWechatSession];
         switch (state) {
             case SSDKResponseStateSuccess:
                 [Remind_L showCenterWithText:@"分享成功"];
                 break;
             case SSDKResponseStateFail:
                 [Remind_L showCenterWithText:@"分享失败"];
                 break;
             default:
                 break;
         }
     }];
}

- (void)didSelectSocialPlatform:(SSDKPlatformType )platformName{
    if (self.mSharedType==0) {
        Vehicle *vehicle = (Vehicle *)self.sharedObj;
        if (self.VehicleChannel ==nil ) {
            self.VehicleChannel = @"其他";
        }
        NSMutableDictionary *dict = [self createProperties:vehicle];
        NSString *platName ;
        if (platformName == SSDKPlatformTypeSinaWeibo) {
            platName = @"新浪微博";
        }else if (platformName == SSDKPlatformSubTypeQZone){
            platName = @"QQ空间";
        }else if (platformName == SSDKPlatformSubTypeWechatSession){
            platName = @"微信好友";
        }else if (platformName == SSDKPlatformSubTypeWechatTimeline){
            platName = @"微信朋友圈";
        }else if (platformName == SSDKPlatformSubTypeQQFriend){
            platName = @"QQ好友";
        }else if(platformName ==SSDKPlatformSubTypeWechatFav){
            platName = @"微信收藏";
        }
        if (platName!=nil) {
             [dict setObject:platName forKey:@"sharePlatName"];
        }
        [HCAnalysis HCclick:@"ShareDetail" WithProperties:dict];
    }
}


-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self._progressView setProgress:progress animated:YES];
    if(self.mSharedType==1){
        Banner *banner = (Banner *)self.sharedObj;
        if (banner.title ==nil) {
           self.title = [self.dlWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }else{
            self.title = banner.title;
        }
    }
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self requestVehicleInfoBy:self.source_id];
    
    if (IOS_VERSION_8_OR_ABOVE) {
        [self.WkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
        [self.dlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }

  //  [self.dlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.WkWebView) {
            [self._progressView setAlpha:1.0f];
            [self._progressView setProgress:self.WkWebView.estimatedProgress animated:YES];
            if(self.mSharedType==1){
                Banner *banner = (Banner *)self.sharedObj;
                if (banner.title ==nil) {
                    self.title = [self.dlWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
                }else{
                    self.title = banner.title;
                }
            }
            if(self.WkWebView.estimatedProgress >= 1.0f) {
                
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
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.VehicleChannel ==nil ) {
        self.VehicleChannel = @"其他";
    }
   
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [self.hcNetworkErrorView removeFromSuperview];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == -999) {
        return;
    }
    [self.view addSubview:self.hcNetworkErrorView];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.hcNetworkErrorView removeFromSuperview];
}

-(void)back:(id)sender
{
    if (IOS_VERSION_8_OR_ABOVE) {
        if ([self.WkWebView canGoBack]) {
            [self.WkWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if ([self.dlWebView canGoBack]) {
            [self.dlWebView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

@end
