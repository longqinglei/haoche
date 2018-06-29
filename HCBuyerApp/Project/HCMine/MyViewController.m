//
//  MyViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/5/5.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyViewController.h"

#import "UserVisitRecordViewController.h"
#import "MyOtherFunctionView.h"
#import "HCCollectionViewController.h"
#import "BizUser.h"
#import "User.h"
#import "UMFeedback.h"
#import "BizCoupon.h"
#import "AutoSeries.h"
#import "MyRecordAndRecommendView.h"
#import "RecommendLowerPriceVehicleViewController.h"
#import "CouponListViewController.h"
#import "HCSettingViewController.h"
#import "Reachability.h"
#import "HCCouponShot.h"
#import "SubscribeViewController.h"
#import "MyHaveSeenTheCarViewController.h"
#import "UIAlertView+ITTAdditions.h"
#import "LoginViewController.h"
#import "HCCollectionViewController.h"
#import "BizUserRecommendVehicle.h"



#define Line_Gap_Width 10
#define Image_Offset 0
#define MyImage_YPos 79
#define Move_Speed 0.7f
#define Consult_top 30

static MyViewController *_myViewcontroller = nil;
@interface MyViewController ()< MyOtherFunctionViewDelegate, MyRecordAndRecommendViewDelegate, UIScrollViewDelegate,HCCouponDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIImageView *imgProfile;
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) NSArray *vehicleArr;
@property (strong, nonatomic) UIButton* constulBtn;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UILabel *myPhoneNumLabel;

@property (strong, nonatomic) UIScrollView *mainView;
@property (strong, nonatomic) MyRecordAndRecommendView *recordAndRecomendView;
@property (strong, nonatomic) MyOtherFunctionView *otherFunctionView;
@property (strong, nonatomic) UIView *gapLineForVisitView;
@property (strong, nonatomic) HCCouponShot *couponshot;

@property (nonatomic) CGFloat mainViewScrollHeight;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic) CGFloat imageHeight;
@property (nonatomic) CGFloat imageWidth;

@end

@implementation MyViewController

- (void)createreachbility
{
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self receiveNotification];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.imageWidth = HCSCREEN_WIDTH;
    self.imageHeight = self.imageWidth * 0.5f;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self createreachbility];
    self.imgProfile = [[UIImageView alloc] initWithFrame:CGRectMake(0, Image_Offset, self.imageWidth, self.imageHeight)];
    self.imgProfile.image = [UIImage imageNamed:@"myTopBg"];
    self.userImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, HCSCREEN_WIDTH*0.25, HCSCREEN_WIDTH * 0.21, HCSCREEN_WIDTH * 0.21)];
    self.couponshot = [[HCCouponShot alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) num:0];
    self.couponshot.delegate  =self;
    self.loginBtn =  [UIButton buttonWithFrame: CGRectMake(self.userImage.right+15, HCSCREEN_WIDTH*0.31, HCSCREEN_WIDTH * 0.35, 35) title:@"登录 / 注册"  titleColor:nil bgColor:nil titleFont:[UIFont systemFontOfSize:16.0f] image:nil selectImage:nil target:self action:@selector(login) tag:0];
    self.loginBtn.titleLabel.textAlignment= NSTextAlignmentLeft;
    self.myPhoneNumLabel = [UILabel labelWithFrame:self.loginBtn.frame text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] tag:0 hasShadow:NO isCenter:YES];
    self.mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    self.mainView.delegate = self;
    self.mainViewScrollHeight = 0.0f;
    self.recordAndRecomendView = [[MyRecordAndRecommendView alloc] initWithFrame:CGRectMake(0, self.imgProfile.height, HCSCREEN_WIDTH, My_RecordAndRecommendView_Cell_Height * 3+HCSCREEN_WIDTH*13/64+10)];
    self.recordAndRecomendView.delegate = self;
    self.mainViewScrollHeight += self.recordAndRecomendView.height;
    self.gapLineForVisitView = [[UIView alloc] initWithFrame:CGRectMake(0, self.recordAndRecomendView.bottom,HCSCREEN_WIDTH, Line_Gap_Width)];
    [self.gapLineForVisitView setBackgroundColor:MTABLEBACK];
    self.mainViewScrollHeight += self.gapLineForVisitView.height;
    self.otherFunctionView = [[MyOtherFunctionView alloc] initWithFrame:CGRectMake(0, self.gapLineForVisitView.bottom, HCSCREEN_WIDTH, 0 + (HC_VEHICLE_LIST_ROW_HEIGHT+5)*self.vehicleArr.count)];
    self.otherFunctionView.delegate = self;
    self.mainViewScrollHeight += self.otherFunctionView.height;
    [self.mainView addSubview:self.recordAndRecomendView];
    [self.mainView addSubview:self.gapLineForVisitView];
    [self.mainView addSubview:self.otherFunctionView];
    self.mainView.showsVerticalScrollIndicator = NO;
    [self.mainView setContentSize:CGSizeMake(self.mainView.width, self.recordAndRecomendView.height+self.otherFunctionView.height+self.imageHeight+64)];
    self.constulBtn = [self createMyConsultBtn];
    self.constulBtn.frame  =  CGRectMake(HCSCREEN_WIDTH - 10 - 70, 30, 70, 30);
    [self.mainView setBackgroundColor:MTABLEBACK];
    [self NSUserDefaults];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.imgProfile];
    [self.mainView addSubview:self.userImage];
    [self.mainView addSubview:self.constulBtn];
}

- (void)reachabilityChanged:(NSNotification*)netChange{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        Reachability* curReach = [netChange object];
        NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
        if (curReach.currentReachabilityStatus!=NotReachable) {
            [self updateInterfaceWithReachability:curReach];
        }
    });
}
- (void)updateInterfaceWithReachability:(Reachability*)reach
{
    if (reach.currentReachabilityStatus!=NotReachable) {
        [self requestRecommendData];
        if ([[HCLogin standLog]isLog]) {
            [self.recordAndRecomendView requestNumData];
        }
    }
}

- (void)requestRecommendData{
    [BizUserRecommendVehicle getNewVehicleSourceRemote:^(NSArray * vehicleArr, NSInteger code) {
        if (code!=0) {
            
        }else{
           
            if (vehicleArr.count!=0) {
                self.vehicleArr = vehicleArr;
                [self.otherFunctionView reloaddata:vehicleArr];
                if (vehicleArr.count>=5) {
                   [self.otherFunctionView setHeight:My_OtherTableView_Cell_Height + (HC_VEHICLE_LIST_ROW_HEIGHT+5)*5];
                }else{
                    [self.otherFunctionView setHeight:My_OtherTableView_Cell_Height + (HC_VEHICLE_LIST_ROW_HEIGHT+5)*vehicleArr.count];
                }
                [self.mainView setContentSize:CGSizeMake(self.mainView.width, self.recordAndRecomendView.height+self.otherFunctionView.height+self.imageHeight+64)];
            }
        }
    }];
}

- (void)addCollectionPoint:(NSNotification*)collect
{
    [self.recordAndRecomendView setCollectNew];
}

- (void)receiveNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCollectionPoint:) name:@"collectionNew" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mSubcri:) name:@"subscri" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNot:) name:@"Screening" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:@"logoutSuccess" object:nil];
}

- (void)NSUserDefaults
{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"collection"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"collection"]isEqualToString:@"1"]) {
            [self.recordAndRecomendView setCollectNew];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"myhaveSeen"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"myhaveSeen"]isEqualToString:@"1"]) {
            [self.recordAndRecomendView setHaveSeenNew];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]integerValue]>0) {
            [self.recordAndRecomendView setSubscribeNew:[[[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]integerValue]];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]integerValue]>0) {
            [self.otherFunctionView setRecommendNew:[[[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]integerValue]];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"couponNum"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"couponNum"]integerValue]>0) {
            [self.recordAndRecomendView setCouponNew:[[[NSUserDefaults standardUserDefaults]objectForKey:@"couponNum"]integerValue]];
        }
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[NSUserDefaults standardUserDefaults]setObject:@3 forKey:@"selctcontroller"];
   // [HCAnalysis HCClick:@"MyPageClick" WithName:@"我的界面"];
    [HCAnalysis HCclick:@"TabbarClick"WithProperties:@{@"TabName":@"MyPage"}];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"MyPage"];
  
}

- (void)logoutSuccess:(NSNotification*)notifi
{
    [self.recordAndRecomendView logout];
}

- (void)loginSuccess:(NSNotification*)notifi
{
    [self.recordAndRecomendView requestNumData];
    [BizCoupon checkNewCounpon:^(NSInteger num)
    {
        if (num>0) {
            [self.recordAndRecomendView setCouponNew:num];
            [self.couponshot reloadNum:num];
            [self.view addSubview:self.couponshot];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString getNowTimestamp] forKey:@"checkCoupon"];
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)num] forKey:@"couponNum"];
        }
    }];
}

- (void)checkNewCoupon
{
    [HCAnalysis HCUserClick:@"myCoupons"];
    [self.recordAndRecomendView setCouponReaded];
    if ([[HCLogin standLog]isLog])
    {
        CouponListViewController *viewController = [[CouponListViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self pushToLoginView:0];
        return;
    }
}

#pragma mark - NSNotification
-(void)mSubcri:(NSNotification*)notifi
{
    [self.recordAndRecomendView setSubscribe];
}

- (void)receiveNot:(NSNotification*)notifi
{
    [self postLastRefreshTime:notifi.userInfo];
};

- (void)login
{
    [self pushToLoginView:0];
}

- (void)postLastRefreshTime:(NSDictionary*)dic
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"myhaveSeen"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"myhaveSeen"]isEqualToString:@"1"]) {
            [self.recordAndRecomendView setHaveSeenNew];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]integerValue]>0) {
            [self.recordAndRecomendView setSubscribeNew:[[[NSUserDefaults standardUserDefaults]objectForKey:@"subNum"]integerValue]];
        }
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]integerValue]>0) {
           [self.otherFunctionView setRecommendNew:[[[NSUserDefaults standardUserDefaults]objectForKey:@"recordNum"]integerValue]];
        }
    }
}

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [HCAnalysis controllerBegin:@"MyPage"];
    if([[HCLogin standLog]isLog]){
        [self.recordAndRecomendView requestNumData];
    }
           
    self.tabBarController.delegate = self;
  //  [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
    [super viewWillAppear:animated];
   
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if ([[HCLogin standLog]isLog]&&(self.myPhoneNumLabel.superview != self.mainView))
    {
        
        [self.userImage setImage:[UIImage imageNamed:@"userlogin"]];
        NSMutableString *temp = [NSMutableString stringWithString:IPHONE];
        NSRange range;
        range.length = 4;
        range.location = 3;
        [temp replaceCharactersInRange:range withString:@"****"];
        [self.myPhoneNumLabel setText:temp];
        [self.mainView addSubview:self.myPhoneNumLabel];
        if (self.loginBtn.superview == self.mainView) {
            [self.loginBtn removeFromSuperview];
        }
    } else if (![[HCLogin standLog]isLog])
    {
         [self.userImage setImage:[UIImage imageNamed:@"usernologin"]];
        if (self.myPhoneNumLabel.superview == self.mainView)
        {
            [self.myPhoneNumLabel removeFromSuperview];
        }
        if (self.loginBtn.superview != self.mainView)
        {
            [self.mainView addSubview:self.loginBtn];
        }
        [self.recordAndRecomendView setCouponReaded];
    }
    //self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UITabBarItem *item =  [self.tabBarController.tabBar.items HCObjectAtIndex:3];
    [item setBadgeValue:nil];
    UIImageView *pointView = (UIImageView *)[self.tabBarController.tabBar viewWithTag:626];
    [pointView removeFromSuperview];
}
//收藏
- (void)showColleciton
{
    [HCAnalysis HCUserClick:@"my_Collection"];
    if ([[HCLogin standLog]isLog]) {
        HCCollectionViewController *colect = [[HCCollectionViewController alloc]init];
        colect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:colect animated:YES];
        colect.title = @"收藏";
    }else{
        LoginViewController *viewController =  [[LoginViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.title = @"登 录";
        viewController.type = 1;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)showVehicleDetail:(Vehicle *)vehicle
{
   
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"推荐车源"}];
    [self pushToVehicelDetailandVehic:vehicle hadCom:YES vehicleChannel:@"推荐"];
}
//登录
- (void)pushToLoginController
{
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"登录"}];
    [self pushToLoginView:1];
}
//浏览记录
- (void)showAllRecord
{
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"浏览记录"}];
    UserVisitRecordViewController *uservisit = [[UserVisitRecordViewController alloc]init];
    uservisit.title = @"浏览记录";
    uservisit.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:uservisit animated:YES];
}

- (void)showRecommend
{
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"推荐"}];
    RecommendLowerPriceVehicleViewController *viewController = [[RecommendLowerPriceVehicleViewController alloc]init];
    viewController.title = @"推荐";
    [self.otherFunctionView setRecommendReaded];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//我的订阅点击
- (void)showSubscribe
{
    [HCAnalysis HCUserClick:@"my_Subscribe_click"];
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"上新提醒"}];
    if ([[HCLogin standLog]isLog]) {
        [BizUserRecommendVehicle updateLastFetchTime];
        
        SubscribeViewController *subCon = [[SubscribeViewController alloc]init];
        subCon.title = @"上新提醒";
        subCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:subCon animated:YES];
    }else{
        LoginViewController *viewController =  [[LoginViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.title = @"登 录";
        viewController.type = 2;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}
//我的优惠劵
- (void)showMyCoupons
{
    [HCAnalysis HCUserClick:@"my_coupons_click"];
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"优惠劵"}];
    [self.recordAndRecomendView setCouponReaded];
    if ([[HCLogin standLog]isLog])
    {
        CouponListViewController *viewController = [[CouponListViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self pushToLoginView:0];
        return;
    }
}
//设置点击
-(void)showSetting
{
    HCSettingViewController *nextViewController = [[HCSettingViewController alloc]init];
    nextViewController.title = @"设置";
    nextViewController.hidesBottomBarWhenPushed = YES;
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"设置"}];
    [self.navigationController pushViewController:nextViewController animated:YES];
}
//我的预定点击
- (void)showMyScan
{
    [self.recordAndRecomendView setHaveSeen];
    [HCAnalysis HCUserClick:@"my_order_click"];
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"预定"}];
    if ([[HCLogin standLog]isLog]) {
        MyHaveSeenTheCarViewController *mySeen = [[MyHaveSeenTheCarViewController alloc]init];
        mySeen.title = @"预定";
        mySeen.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mySeen animated:YES];
    }else{
        [self pushToLoginView:0];
        return;
    }
}

-(void)showFeedback
{
    
    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
}

@end
