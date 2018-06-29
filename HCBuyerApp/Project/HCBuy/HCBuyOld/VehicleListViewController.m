//
//  VehicleListViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/5/5.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehicleListViewController.h"
#import "CouponListViewController.h"
#import "SubscribeViewController.h"
#import "ListPageDropdownView.h"
#import "HCVehicleListView.h"
#import "UIImage+RTTint.h"
#import "DataFilter.h"
#import "BizBrandSeries.h"
#import "BizCity.h"
#import "User.h"
#import "BizUser.h"
#import "LoginViewController.h"
#import "VehicleDetailViewController.h"
#import "UserVisitRecordViewController.h"
#import "CityViewController.h"
#import "RecommendLowerPriceVehicleViewController.h"
#import "MyHaveSeenTheCarViewController.h"
#define HC_DROPDOWN_VIEW_TAG_BEGIN    4000

#import "UIView+ITTAdditions.h"
#import "UiTapView.h"
#import "UIButton+ITTAdditions.h"


static BOOL isInit = NO;
static BOOL allBrandShow = NO;
static BOOL allPriceShow = NO;
static DataFilter *predefinedDataFilter = nil;

@interface VehicleListViewController ()<UIGestureRecognizerDelegate, HCVehicleCellSelectedDelegate, HCListPageDropdownSelectedDelegate,UiTapViewDeleate>
@property (nonatomic,strong) UIView     *viewback;
@property (nonatomic,strong) NSArray    *orderData;
@property (nonatomic,strong) DataFilter *dataFilter;
@property (nonatomic,strong) UiTapView *tapView;
@property (nonatomic,assign) BOOL isCollapsed;
@property (nonatomic,assign) BOOL isExpanded;
@property (nonatomic) CGFloat segmentMinYpos;
@property (nonatomic) CGFloat segmentMaxYpos;
@property (nonatomic) NSInteger height;

@end

@implementation VehicleListViewController


#pragma matk -  LifeCycle


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mListTableView startTimer];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mListTableView stopTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:@"CityChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeFilterSelected:) name:@"HomeFilterSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyVehicleBtnClick:) name:@"HomeBuyClick" object:nil];
    [self createBaseView];
    
    _viewback = [UIView viewbackAddSuperVIew:CGRectMake(0, 108, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    _tapView = [[UiTapView alloc]initWithFrame:_viewback];
    _tapView.tapdelegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sortStatistic:(SortCond*)sortCond{
    if (sortCond.sortType == SortTypeDefault) {
        [HCAnalysis HCUserClick:@"AllSortTypeDefault"];
    }else if (sortCond.sortType == SortTypeAgeAsc){
        [HCAnalysis HCUserClick:@"AllSortTypeAgeAsc"];
    }else if (sortCond.sortType == SortTypeMilesAsc){
        [HCAnalysis HCUserClick:@"AllSortTypeMilesAsc"];
    }else if (sortCond.sortType == SortTypePriceAsc){
        [HCAnalysis HCUserClick:@"AllSortTypePriceAsc"];
    }
}


- (void)tapGestureView
{
//    [self cityShow:NO];
    [self.listPageDropdownView setSegmentUnselected:0];
}

#pragma mark - hiddenCityView

//- (void)emptyPrice
//{
//   [self.listPageDropdownView emptyPrice];
//
//}
//- (void)emptyAll
//{
//    [self.listPageDropdownView emptyPrice];
//    [self.listPageDropdownView emptyBrand];
//    [self.listPageDropdownView empMoreAll];
//}

- (void)createBaseView
{
    self.listPageDropdownView = [[ListPageDropdownView alloc] initWithframe:CGRectMake(0, kNavHegith, HCSCREEN_WIDTH, 44) forData:self.dataFilter forSuperView:self.view delegate:self coverTabbar:YES suitable:0];
    self.listPageDropdownView.delegate = self;
   //[self.listPageDropdownView getCurrentCity];
    self.segmentMinYpos = self.listPageDropdownView.segmentViewMinYPos;
    self.segmentMaxYpos = self.listPageDropdownView.segmentViewMaxYPos;
    self.isCollapsed = NO;
    self.isExpanded = NO;
    [self.view addSubview:self.listPageDropdownView];
    self.mListTableView = [[HCVehicleListView alloc] initWithFrame:CGRectMake(0, self.listPageDropdownView.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) filter:self.dataFilter];
    self.mListTableView.delegate = self;
    [self.view addSubview:self.mListTableView];
    isInit = YES;
    if (predefinedDataFilter) {
        [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    }
    if (allBrandShow) {
        [self.listPageDropdownView showBrandDropdownView];
    }
    if (allPriceShow) {
        [self.listPageDropdownView showPriceDropdownView];
    }
}

+ (void)setPredefinedDataFilter:(DataFilter *)dataFitler
{
    predefinedDataFilter = dataFitler;
    
}

+ (void)setShowAllBrandSelectView
{
    allBrandShow = YES;
}

+(void)setShowAllPriceSelectView{
    
    allPriceShow = YES;
}

+ (BOOL)isInit
{
    return isInit;
}

- (void)buyVehicleBtnClick:(NSNotification*)noti{
    CityElem *curCity = self.dataFilter.city;
    self.dataFilter = [[DataFilter alloc] init];
    self.dataFilter.city = curCity;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    [self.mListTableView refreshData:self.dataFilter];
}
- (void)listViewUpdateWithfilter:(DataFilter *)filter{
    self.dataFilter = filter;
    [self.mListTableView refreshData:filter];
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    //[self.listPageDropdownView reloadDataByDataFilter:filter];
}
- (void)listPageUpdateByFilter:(DataFilter *)filter
{
    self.dataFilter = filter;
    [self.mListTableView refreshData:filter];
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
}

- (void)initData
{
    if (predefinedDataFilter != nil)
    {
        self.dataFilter = predefinedDataFilter;
    }
    else
    {
        self.dataFilter = [[DataFilter alloc] init];
        CityElem *city = [[CityElem alloc] init];
        CityElem *userSelectedCity = [BizCity getCurCity];
        city.cityId = userSelectedCity.cityId;
        city.cityName = userSelectedCity.cityName;
        [self.dataFilter setCity:city];
    }
}

//- (void)pushsubviewController
//{
//    if ([[HCLogin standLog] isLog])
//    {
//        SubscribeViewController *subScribe = [[SubscribeViewController alloc]init];
//        subScribe.title = @"我的订阅";
//        subScribe.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:subScribe animated:YES];
//    }else{
//        [self pushToLoginView:2];
//    }
//}

- (BOOL)nav:(BOOL)hidden
{
   [super.navigationController setNavigationBarHidden:hidden animated:TRUE];
    return hidden;
}


- (void)hcVehicleCellSelected:(Vehicle *)vehicle
{
    if ([self nav:YES])
    {
        [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    }
   
    if (vehicle.title==nil) {
        VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
        nextViewController.source_id = vehicle.vehicle_id;
        nextViewController.VehicleChannel = @"全部";
        nextViewController.hidesBottomBarWhenPushed = YES;
        NSString *vehicleUrl;
        if (Home_Thread_In) {
            NSString *meixiansuo =[NSString stringWithFormat:DETAIL_URL, (long)vehicle.vehicle_id,(long)[BizUser getUserId],[BizUser getUserType]];
            vehicleUrl = [NSString stringWithFormat:@"%@&src=%@",meixiansuo,Home_Thread_In];
        }else{
            vehicleUrl = [NSString stringWithFormat:DETAIL_URL, (long)vehicle.vehicle_id,(long)[BizUser getUserId],[BizUser getUserType]];
        }
        vehicleUrl = [vehicleUrl stringByAppendingString:[NSString stringWithFormat:@"&promote_id=%@",APPMJCODE]];
        nextViewController.url =vehicleUrl;
        [nextViewController setVehicleCompareBtn];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }else{
        if (vehicle.jump==0) {
            VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
            nextViewController.url = vehicle.redirect_url;
            nextViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nextViewController animated:YES];
        }else{
            [self pushMyController:vehicle.jump];
        }
        
    }

}
- (void)pushMyController:(NSInteger)type
{
    switch (type) {
        case 1:
            [self.delegate selectIndex:0];

            break;
        case 2:
            [self.delegate selectIndex:1];
         
            break;
        case 3:
            [self.delegate selectIndex:2];
           
            break;
        case 4:
            if ([[HCLogin standLog]isLog]) {
                MyHaveSeenTheCarViewController *viewController = [[MyHaveSeenTheCarViewController alloc]init];
                viewController.title = @"预定";
                viewController.hidesBottomBarWhenPushed = YES;
                  [self.navigationController pushViewController:viewController animated:YES];
            }else{
                [self pushToLoginView:0];
            }
            break;
        case 5:
            [self.delegate selectIndex:3];
           
            break;
        case 6:
            [self pushToLoginView:0];
            break;
        case 7:
            if (type) {
                RecommendLowerPriceVehicleViewController *viewController = [[RecommendLowerPriceVehicleViewController alloc]init];
                viewController.title = @"推荐";
                viewController.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case 8:
        {
            CouponListViewController *coupon = [[CouponListViewController alloc]init];
            coupon.title = @"我的优惠劵";
            coupon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:coupon animated:YES];
        }
            break;
        case 9:
        {
            UserVisitRecordViewController *userVisit = [[UserVisitRecordViewController alloc]init];
            userVisit.title=@"浏览记录";
            userVisit.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:userVisit animated:YES];
        }
            break;
        default:
            break;
    }

    
    
    
}
- (void)hcBangmaiClick
{
    VehicleDetailViewController *nextViewController =[[VehicleDetailViewController alloc]init];
    nextViewController.title = @"帮买服务";
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.url = [NSString stringWithFormat:BANGMAI_URL, (long)[BizUser getUserId]];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)JumpViewcontroller:(id)notFavt
{
    [self pushToLoginView:2];
}

- (void)resetFilter:(NSInteger)type
{
    CityElem *curCity = self.dataFilter.city;
    self.dataFilter = [[DataFilter alloc] init];
    self.dataFilter.city = curCity;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    if (type==1) {
        [self.mListTableView refreshData:self.dataFilter];
    }
}
- (void)showInfoMess:(NSString *)message type:(FVAlertType)type{
    
    [self showInfo:message type:type];
}
- (void)showMessage:(NSString *)message type:(FVAlertType)type{
    //[self showInfo:message type:type];
   [self showMsg:message type:type];
}

- (void)showSubSuccessInfo{
    [self showSubSuccess];
}
#pragma  mark - Browse and record

#pragma  mark - Notice of city list selection
- (void)cityChanged:(NSNotification*)notification
{
    CityElem *cityData = (CityElem *)[[notification userInfo] objectForKey:@"city"];
    DataFilter *dataFilter = [[DataFilter alloc] init];
    dataFilter.city = cityData;
    self.dataFilter = dataFilter;
   
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    [self.mListTableView refreshData:self.dataFilter];
    //[self.listPageDropdownView getCurrentCity];
    self.isExpanded = YES;
    self.isCollapsed = NO;
   //  [self.sortView resetTableViewCellColorIndexPath:-1];
//    [self.sortBtn setBackgroundImage:[UIImage imageNamed:@"sortBgBlack"] forState:UIControlStateNormal];
//    [self.sortBtn setImage:[UIImage imageNamed:@"sortBlack"] forState:UIControlStateNormal];
//    [self.sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


//- (void)isBtnClick:(BOOL)click
//{
//    if (click) {
//       // self.listPageDropdownView.hidden = YES;
//        [UIView animateWithDuration:0.3 animations:^{
//
//            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//            self.sortView.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, 0, 0);
//            [self.sortView resetTableViewFrame:YES];
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH-15-HCSCREEN_WIDTH*0.14, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//        }];
//        
//    }
//}
#pragma 首页价格, 品牌 选择后的通知
- (void)homeFilterSelected:(NSNotification *)notification
{
    DataFilter *dataFilter = (DataFilter *)[[notification userInfo] objectForKey:@"dataFilter"];
    self.dataFilter = dataFilter;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    [self.mListTableView refreshData:self.dataFilter];
    if ([[notification userInfo] objectForKey:@"moreBrand"]) { 
        [self.listPageDropdownView showBrandDropdownView];
    }
    if ([[notification userInfo] objectForKey:@"morePrice"]) {
        [self.listPageDropdownView showPriceDropdownView];
    }
    self.isExpanded = YES;
    self.isCollapsed = NO;
}



@end
