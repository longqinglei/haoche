                                                                                                                                                                                                                                                 //
//  AppDelegate.m
//  HCBuyerApp
////                  _oo0oo_
//                   o8888888o
//                   88" . "88
//                   (| -_- |)
//                   0\  =  /0
//                 ___/`___'\___
//               .' \\|     |// '.
//              / \\|||  :  |||// \
//             / _||||| -:- |||||_ \
//            |   | \\\  _  /// |   |
//            | \_|  ''\___/''  |_/ |
//            \  .-\__  '_'  __/-.  /
//          ___'. .'  /--.--\  '. .'___
//        ."" '<  .___\_<|>_/___. '>' "".
//     | | :  `_ \`.;` \ _ / `;.`/ - ` : | |
//     \ \  `_.   \_ ___\ /___ _/   ._`  / /
//  ====`-.____` .__ \___||____/ __. -` ___.`====
//                   `=--||---='
//                   ~~~~
//                      ~~
//                     __||__
//                     \_||_/
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Created by wj on 14-10-17.
//  Copyright (c) 2014年 haoche51. All rights reserved.

#import "AppDelegate.h"
#import "TalkingData.h"
#import "AFNetworking.h"
#import "BizCoupon.h"
#import "BizUser.h"
#import "User.h"
#import "BizCity.h"
#import "LoginViewController.h"
#import "City.h"
#import "BrandSeries.h"
#import "AutoSeries.h"
#import "SubscribeViewController.h"
#import "Banner.h"
#import "BizBrandSeries.h"
#import "BizUserRecommendVehicle.h"
#import "GuideViewController.h"
#import "VehicleDetailViewController.h"
#import "HCUUID.h"
#import "SubscribeRquest.h"
#import <CoreLocation/CoreLocation.h>
#import "MyHaveSeenTheCarViewController.h"
#import "UMFeedback.h"
#import "RecommendLowerPriceVehicleViewController.h"
#import "BPush.h"
#import "CouponListViewController.h"
#import "UserVisitRecordViewController.h"
#import "VehicleListViewController.h"
#import "LowerPriceVehicleListControllerViewController.h"
#import "CityViewController.h"
#import "SensorsAnalyticsSDK.h"
#import "NSDate+ITTAdditions.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework
//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
////以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//以下是新浪微博SDK的依赖库：
//ImageIO.framework
//libsqlite3.dylib
//AdSupport.framework

//#import "VSDependencyCommon.h"
@interface AppDelegate() <CLLocationManagerDelegate,GuideViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) HCMyTabBarController *myTabBar;
@property (nonatomic, strong) GuideViewController *guideViewController;
@property (nonatomic, strong) CityElem *cityElem;
@property (nonatomic) BOOL isAll;
@property (nonatomic, strong) NSDictionary *pushDict;
@property (nonatomic, strong) DataFilter *dataFilter;

@end

@implementation AppDelegate

#pragma mark - 百度推送系统设置
- (void)registerRemoteNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)getcityArray{
    NSArray *cityArray = [City getCityList];
    BOOL empty ;
    
    if (cityArray.count==0) {
        empty = YES;
    }else{
        empty = NO;
    }
    [BizCity getCityListOrderedRemote:empty finish:^(NSArray *ret) {
    }];
}
#pragma mark - rootViewController为启动页
- (void)RootGuideViewController
{
    if (_guideViewController==nil) {
        _guideViewController = [[GuideViewController alloc]init];
    }
    _guideViewController.delegate = self;
    self.window.rootViewController = _guideViewController;
}
- (void)setShareSDKAppkey{
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:SinaKey
                                           appSecret:SinaSecret
                                         redirectUri:SINAURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WECHATID
                                       appSecret:WECHATSECRET];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQID
                                      appKey:QQKEY
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"IsNewUser"]) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"NewDate"];
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"IsNewUser"];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsNewUser"]isEqualToString:@"true"]) {
        NSDate *newdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewDate"];
        [[NSUserDefaults standardUserDefaults] setObject: [NSDate isNewUserWithInterval:[newdate zeroOfDate]] forKey:@"IsNewUser"];
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 // [[VSDependencyManager shareInstance] start];
#pragma mark -
    [NSThread sleepForTimeInterval:1];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   
    [self setShareSDKAppkey];
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:HC_SERVER_URL
                                     andConfigureURL:HC_CONFIGURE_URL
                                        andDebugMode:HC_DEBUG];
    
    //上线前修改
   // [SensorsAnalyticsSDK sharedInstance].flushBulkSize = 2;
    //[SensorsAnalyticsSDK sharedInstance].flushInterval = 5 * 1000;
    [self registerSuperProperties];
  
    //[[[SensorsAnalyticsSDK sharedInstance] people] setOnce:@"FirstLoadTime" to:[NSDate date]];
#pragma mark - TalkingData设置
//    [TalkingDataAppCpa init:ADTrackingKey withChannelId:@"AppStore"];
    //[TalkingData setiBeaconEnabled:NO];
    [TalkingData sessionStarted:TalkingDataKey withChannelId:@"AppStore"];
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData setLogEnabled:NO];
#pragma mark - NSUserDefaults存储设置

    [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"selctcontroller"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"select"];
    [User createTable];//创建用户
    [City createTable];//城市数据库创建
    [self getcityArray];
    [BrandSeries createTable];//品牌写入数据库
    [AutoSeries createTable];//车系ID
    //[VehicleSource createTable];//获取车源数据
    // [Banner createTable];//banner创建写入数据库
    [self registerRemoteNotification];//百度推送ios系统版本设置
#pragma mark - BPush百度注册
 
    //[BPush registerChannel:launchOptions apiKey:BAppKey pushMode:HC_PUSH_MODE withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    
    
    [BPush registerChannel:launchOptions apiKey:BAppKey pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil useBehaviorTextInput:NO isDebug:YES];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
        if ([[userInfo objectForKey:@"type"] intValue]==11 || [[userInfo objectForKey:@"type"] intValue]==12) {
            _pushDict = [userInfo objectForKey:@"data"];
            self.cityElem = [[CityElem alloc]init];
            if (_pushDict != nil) {
                self.cityElem.cityId = [[_pushDict objectForKey:@"city"]integerValue];
                self.cityElem.cityName = [City getCityNameById:[[_pushDict objectForKey:@"city"]integerValue]];
            }
        }
    }
#pragma mark - UM
    //dispatch_async(mQueue, ^{
     [UMFeedback setAppkey:UmengAppkey];
     //[BizBrandSeries getIncrementSeriesData:^(BOOL ret) {}];
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:@"FirstLaunch"];
    [self RootGuideViewController];
    [self.window makeKeyAndVisible];
    int cacheSizeMemory = 100*1024*1024;
    int cacheSizeDisk = 20*1024*1024;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];

    return YES;
  
}

- (void)registerSuperProperties{
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"FirstLaunch"] isEqualToString:@"first"]) {
        [[SensorsAnalyticsSDK sharedInstance]track:@"AppLoaded"withProperties:@{@"AppMarket":@"AppStore",@"FirstLaunch" : @"false"}];
    }else{
        [[SensorsAnalyticsSDK sharedInstance]track:@"AppLoaded" withProperties:@{@"AppMarket":@"AppStore",@"FirstLaunch" : @"true"}];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"IsNewUser"]isEqualToString:@"true"]) {
          [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsNewUser" : @"true"}];
    }else{
          [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsNewUser" : @"false"}];
    }
    if ([[HCLogin standLog]isLog]) {
        	
        [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsLogin" :@"true"}];
    }else{
        [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsLogin" :@"false"}];
    }
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 启动页的点击跳转活动界面  （delegate）
- (void)pushActiviti:(NSString *)weburl
{
    [self launchViewAction];
    VehicleDetailViewController *nextViewController =[[VehicleDetailViewController alloc]init];
    nextViewController.url  = weburl;
    nextViewController.mSharedType = 1;
    nextViewController.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:nextViewController animated:YES];
}

#pragma mark - 自定义系统的角标设置
- (void)loadPointView
{
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(HCSCREEN_WIDTH/10+12+ 4 * HCSCREEN_WIDTH/5, 5, 8, 8);
    imageView.layer.cornerRadius= 4;
    imageView.tag = 626;
    imageView.backgroundColor = PRICE_STY_CORLOR;
    [self.myTabBar.tabBar addSubview:imageView];
}

//- (void)loadForumPointView
//{
//    UIImageView  *imageView = [[UIImageView alloc] init];
//    imageView.frame = CGRectMake(HCSCREEN_WIDTH/10+12+ 3 * HCSCREEN_WIDTH/5, 5, 8, 8);
//    imageView.layer.cornerRadius= 4;
//    imageView.tag = 826;
//    imageView.backgroundColor = PRICE_STY_CORLOR;
//    [self.myTabBar.tabBar addSubview:imageView];
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDictionary *dic  = userInfo;
    
    if (![dic objectForKey:@"type"])
    {
        [AppClient tongji:@"&status=arrived"];
        return;
    }
    else
    {
        [AppClient tongji:[NSString stringWithFormat:@"&ptype=%d&status=arrived",[[dic objectForKey:@"type"] intValue]]];
    }
 
    if ([[dic objectForKey:@"type"] intValue] == 11 || [[dic objectForKey:@"type"] intValue] == 12) {
       
    }else{
        [self loadPointView];
    }

    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)
    {
        [self appdidReceiveNotificationFor:dic];
    }
    else
    {
        UIImageView *pointView = (UIImageView *)[self.myTabBar.tabBar viewWithTag:626];
        [pointView removeFromSuperview];
        [self appdidReceiveNotificationBG:dic];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 8.0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSString *token = [[[[deviceToken description]
//                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                        stringByReplacingOccurrencesOfString:@">" withString:@""]
//                       stringByReplacingOccurrencesOfString:@" " withString:@""];
//
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        if (result) {
            [BizUser registerUser:[result objectForKey:@"channel_id"] userid:[result objectForKey:@"user_id"] byfinish:^(BOOL success) {
            }];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [BizUser registerUser:@"" userid:@"" byfinish:^(BOOL success) {}];
}

#pragma mark - 3.0以上版本都会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dic  = userInfo;
    if (![dic objectForKey:@"type"]) {
        [AppClient tongji:@"&status=arrived"];
        return;
    }else{
        [AppClient tongji:[NSString stringWithFormat:@"&ptype=%d&status=arrived",[[dic objectForKey:@"type"] intValue]]];
    }
       [BPush handleNotification:userInfo];
    if ([[dic objectForKey:@"type"] intValue] == 11 || [[dic objectForKey:@"type"] intValue] == 12) {
        
    }else{
        [self loadPointView];
    }
    
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        [self appdidReceiveNotificationFor:dic];
    }
    else
    {
    UIImageView *pointView = (UIImageView *)[self.myTabBar.tabBar viewWithTag:626];
    [pointView removeFromSuperview];
    [self appdidReceiveNotificationBG:dic];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

#pragma mark - 在程序里面接收到通知，保存起来
- (void)appdidReceiveNotificationFor:(NSDictionary*)dic
{
    
    if (![dic objectForKey:@"type"]) {return;}
    if([[dic objectForKey:@"type"] intValue] == 6||[[dic objectForKey:@"type"] intValue] == 7){
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"myhaveSeen"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Screening" object:nil userInfo:nil];}
    if ([[dic objectForKey:@"type"]intValue]== 4) {
        [BizUserRecommendVehicle checkNewUserRecommend:^(BOOL ret,NSInteger cnt) {
        if (ret) {
        if (cnt>0) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)cnt] forKey:@"recordNum"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Screening" object:nil userInfo:nil];}}}];
    }
    if ([[dic objectForKey:@"type"]intValue]== 5) {
        [self chceksubnum];
    }
    if ([[dic objectForKey:@"type"] intValue] == 8||[[dic objectForKey:@"type"] intValue] == 9 ||[[dic objectForKey:@"type"] intValue] == 10 ||[[dic objectForKey:@"type"] intValue] == 13){
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"collection"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNew" object:nil userInfo:nil];
    }
}

#pragma mark - 前提：在后台的时候，有推送，直接点击跳转
- (void)appdidReceiveNotificationBG:(NSDictionary*)dic
{
    [self launchViewAction];
    if (![dic objectForKey:@"type"]) {
        [AppClient tongji:@"&status=clicked"];
        return;
    }else{
        [AppClient tongji:[NSString stringWithFormat:@"&ptype=%d&status=clicked",[[dic objectForKey:@"type"] intValue]]];
    }
    if ([[dic objectForKey:@"type"] intValue] == 4){[self PushRecommend];
    }else if([[dic objectForKey:@"type"] intValue] == 6||[[dic objectForKey:@"type"] intValue] == 7){
        [self PushHaveSeen];
    }else if([[dic objectForKey:@"type"] intValue] == 5){
        if ([[HCLogin standLog]isLog]) {
            [BizUserRecommendVehicle updateLastFetchTime];
            
            SubscribeViewController *subCon = [[SubscribeViewController alloc]init];
            subCon.title = @"上新提醒";
            subCon.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)_myTabBar.selectedViewController pushViewController:subCon animated:YES];
        }else{
            LoginViewController *viewController =  [[LoginViewController alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.title = @"登 录";
            viewController.type = 2;
            viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [(UINavigationController *)_myTabBar.selectedViewController pushViewController:viewController animated:YES];        }

    }else if ([[dic objectForKey:@"type"] intValue] == 8||[[dic objectForKey:@"type"] intValue] == 10||[[dic objectForKey:@"type"] intValue] == 13 ){
        [self PushVehicleDetai:dic];
    }else if([[dic objectForKey:@"type"] intValue] == 9 ){
        [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"select"];
        [_myTabBar setSelectedIndex:1];
    }else if ([[dic objectForKey:@"type"] intValue]==11 || [[dic objectForKey:@"type"] intValue]==12) {
        _pushDict = [dic objectForKey:@"data"];
        self.cityElem = [[CityElem alloc]init];
        if (_pushDict != nil) {
            self.cityElem.cityId = [[_pushDict objectForKey:@"city"]integerValue];
            self.cityElem.cityName = [City getCityNameById:[[_pushDict objectForKey:@"city"]integerValue]];
        }
        if ([[dic objectForKey:@"type"] intValue] == 11) {_isAll = YES;}else{_isAll = NO;}
        if ([BizCity getCurCity].cityId != [[_pushDict objectForKey:@"city"]intValue]) {  //切换城市
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"检测到您的访问城市发生变化,推荐的车辆在[%@],立即切换?",self.cityElem.cityName] message:nil delegate:self cancelButtonTitle:@"切换" otherButtonTitles:@"不切换", nil];
            [alertView show];
        }else{
            if ([[dic objectForKey:@"type"] intValue] == 12) {
                [self machingLowVehicleData];
                [self pushTabBarTwo];
            }else{
                [self matchingAllvehicleData];
                [self pushTabBarOne];
            }
        }
    }else if ([[dic objectForKey:@"type"] intValue]==3){
        NSDictionary *pushDic = [dic objectForKey:@"data"];
        NSString *url = [pushDic objectForKey:@"params"];
        VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
        //int vehicleid = [[[dic objectForKey:@"data"]objectForKey:@"vehicle_source_id"]intValue];
        //nextViewController.source_id = vehicleid;
        nextViewController.hidesBottomBarWhenPushed = YES;
        nextViewController.url = url;
        //[nextViewController setVehicleCompareBtn];
        [(UINavigationController *)_myTabBar.selectedViewController pushViewController:nextViewController animated:YES];
    }
}

- (void)pushTabBarTwo
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"select"];
    [_myTabBar setSelectedIndex:1];
}


- (void)pushTabBarOne
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"select"];
    [_myTabBar setSelectedIndex:1];
}

- (void)switchCity
{
    [BizCity saveSelectedCity:self.cityElem];
    CityViewController *cityController = [CityViewController shareCity];
    [cityController resetCityColor:self.cityElem.cityId];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.cityElem forKey:@"city"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:param];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (_isAll == YES) {
        if (buttonIndex == 0) {
          [self switchCity];
          [self pushTabBarOne];
          [self matchingAllvehicleData];
        }else{
            return;
        }
        
    }else{
        if (buttonIndex == 0) {
            [self switchCity];
            [self pushTabBarTwo];
            [self machingLowVehicleData];
        }else{
            return;
        }
       
    }
}

- (void)PushVehicleDetai:(NSDictionary *)dic
{
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    int vehicleid = [[[dic objectForKey:@"data"]objectForKey:@"vehicle_source_id"]intValue];
    nextViewController.source_id = vehicleid;
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.url = [NSString stringWithFormat:DETAIL_URL, (long)vehicleid,(long)[BizUser getUserId],[BizUser getUserType]];
    [nextViewController setVehicleCompareBtn];
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:nextViewController animated:YES];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - GuideViewControllerDelegate
- (void)launchViewAction
{
    if (!_myTabBar) {
        _myTabBar = [[HCMyTabBarController alloc] init];
    }
    [self.window setRootViewController:_myTabBar];
  //  [self loadForumPointView];
   
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //[UMSocialSnsService  applicationDidBecomeActive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[[SensorsAnalyticsSDK sharedInstance] people] set:@"LastLoadTime" to:[NSString fixStringForDate:[NSDate date]]];
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
    //NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */   //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //[UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - GexinSdkDelegate
- (void)chceksubnum
{
        NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"subs_refresh"] ;
        if (time == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"subs_refresh"];
        }
        NSInteger timeNum =[time integerValue];
        if ([[HCLogin standLog]isLog]) {
            [SubscribeRquest getTimeCar:timeNum city:[BizCity getCurCity].cityId subid:0 SourceInformation:^(int num, NSInteger code) {
                if (num>0) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    NSString *strNum = [NSString stringWithFormat:@"%d",num];
                    [dict setObject:strNum forKey:@"num"];
                    
                    NSNotification *notification =[NSNotification notificationWithName:@"receiveNoti" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [[NSUserDefaults standardUserDefaults]setObject:strNum forKey:@"subNum"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Screening" object:nil userInfo:nil];
                }
            }];
    }
}


- (void)pushViewController:(NSInteger)type
{
    [self launchViewAction];
    switch (type) {
        case 1:
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"select"];
            [_myTabBar setSelectedIndex:1];
            break;
        case 2:
              [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"select"];
            [_myTabBar setSelectedIndex:1];
            break;
        case 3:
            [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"select"];
            [_myTabBar setSelectedIndex:1];
            break;
        case 4:
            [self PushHaveSeen];
            break;
        case 5:
            [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"select"];
            [_myTabBar setSelectedIndex:1];
            break;
        case 6:
             [self pushtologin];
            break;
        case 7:
            if (type){
                [self PushRecommend];
            }
            break;
        case 8:
        {
            [self PushCouponViewController];
        }
            break;
        case 9:
        {
            [self PushUserVisit];
        }
            break;
        default:
            break;
    }
}

- (void)PushCouponViewController
{
    CouponListViewController *coupon = [[CouponListViewController alloc]init];
    coupon.title = @"我的优惠劵";
    coupon.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:coupon animated:YES];
}

- (void)PushUserVisit
{
    UserVisitRecordViewController *userVisit = [[UserVisitRecordViewController alloc]init];
    userVisit.title=@"浏览记录";
    userVisit.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:userVisit animated:YES];
}

- (void)PushRecommend
{
    RecommendLowerPriceVehicleViewController *viewController = [[RecommendLowerPriceVehicleViewController alloc]init];
    viewController.title = @"推荐";
    viewController.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:viewController animated:YES];
}

- (void)PushHaveSeen
{
    if ([[HCLogin standLog]isLog]) {
    MyHaveSeenTheCarViewController *viewController = [[MyHaveSeenTheCarViewController alloc]init];
    viewController.title = @"预定";
    viewController.hidesBottomBarWhenPushed = YES;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:viewController animated:YES];}else{
    [self pushtologin];}
}

- (void)pushtologin
{
    LoginViewController *viewController =  [[LoginViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = @"登 录";
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [(UINavigationController *)_myTabBar.selectedViewController pushViewController:viewController animated:YES];
}


- (void)setdatafilter{
    _dataFilter = [[DataFilter alloc] init];
    _dataFilter.city = self.cityElem;
    _dataFilter.brandSeriesCond = [[BrandSeriesCond alloc] init];
    _dataFilter.brandSeriesCond.brandId = [[_pushDict objectForKey:@"brand_id"] integerValue];
    _dataFilter.brandSeriesCond.seriesId = [[_pushDict objectForKey:@"class_id"] integerValue];
    _dataFilter.brandSeriesCond.brandName = [BrandSeries getBrandNameByBrandId:[[_pushDict objectForKey:@"brand_id"] integerValue]];
    _dataFilter.brandSeriesCond.seriesName = [AutoSeries getSeriesNamesByseries_id:[[_pushDict objectForKey:@"class_id"] integerValue]];
    
    if ([_pushDict objectForKey:@"price"]) {
        NSArray *arrayPrice = [_pushDict objectForKey:@"price"];
        int from = [[arrayPrice HCObjectAtIndex:0] intValue];
        int to = [[arrayPrice HCObjectAtIndex:1] intValue];   //滑动还没有进行调试
        PriceCond *priceCond = [[PriceCond alloc]init];
        if (to == 1000 || to == 0) {
            to = 1000;
        }
        if (from == 0 && to == 1000) {
            [priceCond setPriceFrom:-1];
            [priceCond setPriceTo:-1];
        }else{
            [priceCond setPriceFrom:from];
            [priceCond setPriceTo:to];
        }
        _dataFilter.priceCond = priceCond;
    }
}

- (void)matchingAllvehicleData
{
    [self setdatafilter];
    if ([VehicleListViewController isInit] == NO){
        [VehicleListViewController setPredefinedDataFilter:_dataFilter];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:_dataFilter forKey:@"dataFilter"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFilterSelected" object:nil userInfo: param];
    }
}

- (void)machingLowVehicleData{
        [self setdatafilter];
        if ([LowerPriceVehicleListControllerViewController isInit]==NO) {
            [LowerPriceVehicleListControllerViewController setPredefinedDataFilter:_dataFilter];
        }else{
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:_dataFilter forKey:@"dataFilter"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LowFilterSelected" object:nil userInfo: param];
        }
        [_dataFilter getFilterRequestParam:3];
}

@end
