//
//  LowerPriceVehicleListControllerViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/6/25.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "LowerPriceVehicleListControllerViewController.h"
#import "LowerPriceVehicleBigCellTableViewCell.h"
#import "VehicleDetailViewController.h"
#import "BizLowPriceVehicleSource.h"
#import "ListPageDropdownView.h"
#import "FVCustomAlertView.h"
#import "UIImage+RTTint.h"
#import "HCNodataView.h"
#import "MJRefresh.h"
#import "MobClick.h"
#import "BizUser.h"
#import "CityViewController.h"
#import "HCDropdownListView.h"
#import "DataFilter.h"
#import "BizCity.h"
#import "HCNearCityCell.h"
#import "HCbangmaiCell.h"
#import "BizHelpBuy.h"
#import "UIButton+ITTAdditions.h"
#import "UiTapView.h"
#import "UIView+ITTAdditions.h"

#import "PageView.h"

@interface LowerPriceVehicleListControllerViewController ()< UIGestureRecognizerDelegate, HCListPageDropdownSelectedDelegate,HCDropdowListViewDataDelegate,CityViewControllerDelegate,HCbangmaiDelegate,UiTapViewDeleate>

#pragma mark - TheClassNameAndView

@property (nonatomic, strong) UIView *noVehicleDataView;
@property (nonatomic, strong) UIView *networkErrorView;
@property (nonatomic, strong) UIView *sortBg;
@property (nonatomic, strong) UIView *mNoView;
@property (nonatomic, strong) UIView *mLowviewback;

@property (nonatomic, assign) BOOL isCollapsed;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) float lastContentOffset;

@property (nonatomic, strong) DataFilter *dataFilter;
@property (nonatomic, strong) NSMutableDictionary *query;
@property (nonatomic, strong) CityViewController *cityViewController;
@property (nonatomic, strong) UiTapView *tapView;


@property (nonatomic, strong) NSArray *orderData;
@property (nonatomic, strong) NSArray *vehicleData;
@property (nonatomic, strong) NSArray *vehicleinfo;

@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger page;

@property (nonatomic) CGFloat segmentMinYpos;
@property (nonatomic) CGFloat segmentMaxYpos;
@property (nonatomic) BOOL isRefre;
@property (nonatomic, strong) PageView *pageView;
@property (nonatomic, strong) UIButton *sortBtn;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) NSTimer *imer;


@end
static BOOL isInit = NO;
static DataFilter *predefinedDataFilter = nil;
@implementation LowerPriceVehicleListControllerViewController

- (void)initData
{
    if (predefinedDataFilter != nil)
    {
        self.dataFilter = predefinedDataFilter;
    } else {
        self.dataFilter = [[DataFilter alloc] init];
        CityElem *city = [[CityElem alloc] init];
        CityElem *userSelectedCity = [BizCity getCurCity];
        city.cityId = userSelectedCity.cityId;
        city.cityName = userSelectedCity.cityName;
        [self.dataFilter setCity:city];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushFilterSelected:) name:@"LowFilterSelected" object:nil];
    [self initData];
    _isShowTab = NO;
    isInit = YES;
    if (!_query) {
        _query = [[NSMutableDictionary alloc]init];
    }
    if (predefinedDataFilter) {
        [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:@"CityChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lowCarInfo:) name:@"LowCarInformation" object:nil];
    [self.dataFilter setCity:[BizCity getCurCity]];
    _cityViewController = [CityViewController shareCity];
    _cityViewController.delegate = self;
    [self creatBackButton];
    [self DataView];

  
}

+(BOOL)isInit
{
    return isInit;
}

- (void)PushFilterSelected:(NSNotification*)notif{
    DataFilter *dataFilter = (DataFilter *)[[notif userInfo] objectForKey:@"dataFilter"];
    self.dataFilter = dataFilter;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
   [self refreshData:self.dataFilter];
}

+ (void)setPredefinedDataFilter:(DataFilter *)dataFitler
{
    predefinedDataFilter = dataFitler;
}

- (void)cityChanged:(NSNotification*)notification
{
    CityElem *cityData = (CityElem *)[[notification userInfo] objectForKey:@"city"];
    DataFilter *dataFilter = [[DataFilter alloc] init];
    dataFilter.city = cityData;
    self.dataFilter = dataFilter;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    if (self.dataFilter.city && self.dataFilter.city.cityId > 0) {
        _query = [self.dataFilter getFilterRequestParam:0];
        [_query setObject:[NSNumber numberWithInteger:self.dataFilter.city.cityId] forKey:@"city"];
        [_query setObject:[NSNumber numberWithInteger:1] forKey:@"suitable"];
        [self.mLowerTableView headerBeginRefreshing];
    }
    
   // [self.listPageDropdownView getCurrentCity];
    self.isExpanded = YES;
    self.isCollapsed = NO;
    [self.sortBtn setBackgroundImage:[UIImage imageNamed:@"sortBgBlack"] forState:UIControlStateNormal];
    [self.sortBtn setImage:[UIImage imageNamed:@"sortBlack"] forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isRefre == YES) {
        [self.mLowerTableView headerBeginRefreshing];
    }
    _pageView = [[PageView alloc]initWithFrameRect:CGRectMake(HCSCREEN_WIDTH/2.34, HCSCREEN_HEIGHT-40, HCSCREEN_WIDTH-(HCSCREEN_WIDTH/2.34*2), 20)];
}

- (void)setdelegate{
    if (self.cityViewController) {
        self.cityViewController.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)tapGestureView
{
    [self cityShow:NO];
    [self.listPageDropdownView setSegmentUnselected:0];
}

- (void)hidden_viewBack
{
    _mLowviewback.hidden = YES;
    _cityViewController.view.frame = CGRectMake(0, -_height-110 , HCSCREEN_WIDTH, -_height-110);
    [self.listPageDropdownView setSegmentUnselected:-1];
}


- (void)pushViewController:(NSInteger)ID CityName:(NSString *)name CityId:(NSInteger)cityId
{
    [self hidden_viewBack];
}

- (void)DataView
{
    self.listPageDropdownView = [[ListPageDropdownView alloc] initWithframe:CGRectMake(0, 64, HCSCREEN_WIDTH, 44) forData:self.dataFilter forSuperView:self.view delegate:self coverTabbar:YES suitable:1];
    self.segmentMinYpos = self.listPageDropdownView.segmentViewMinYPos;
    self.segmentMaxYpos = self.listPageDropdownView.segmentViewMaxYPos;
    
    self.isCollapsed = NO;
    self.isExpanded = NO;
    //[self.listPageDropdownView getCurrentCity];
    [self.view addSubview:self.listPageDropdownView];
    
    self.mLowerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.listPageDropdownView.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-154)];
    self.mLowerTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.mLowerTableView.delegate = self;
    self.mLowerTableView.dataSource = self;
    [self setupRefresh:self.mLowerTableView];
    [self.view addSubview:self.mLowerTableView];
    self.lastContentOffset = 0;//下面的是没有筛选出东西来

    self.noVehicleDataView = [HCNodataView createNoVehicleView:_noVehicleDataView target:self action1:@selector(showLowAllVehicle:) action2:@selector(visitBangmaiPage:) fram:CGRectMake(0, 0, 0, 0) text:nil andText:@"查看全部超值低价车" ishow:NO];

    self.noVehicleDataView.hidden = YES;
    [self.view addSubview:self.noVehicleDataView];
    self.mNoView = [HCNodataView getWebNetWorkErrorView:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    self.mNoView.backgroundColor = [UIColor whiteColor];
    self.mNoView.hidden = YES;
    [self.view addSubview:self.mNoView];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mNoView addGestureRecognizer:bgTap];
    
    
    if (self.dataFilter.city && self.dataFilter.city.cityId > 0) {
        [_query setObject:[NSNumber numberWithInteger:self.dataFilter.city.cityId] forKey:@"city"];
        [_query setObject:[NSNumber numberWithInteger:1] forKey:@"suitable"];
        [self.mLowerTableView headerBeginRefreshing];
    }
    //self.sortBtn = [UIButton initCreatSort:self.view target:self action:@selector(showSortView:)];
    
    _mLowviewback = [UIView viewbackAddSuperVIew:CGRectMake(0, 108, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    _tapView = [[UiTapView alloc]initWithFrame:_mLowviewback];
    _tapView.tapdelegate = self;
    [self.view addSubview:_mLowviewback];
    
}

//- (void)hiddenSortBg
//{
//    [self hideSortbgandSortview];
//}
//


- (void)sortStatistic:(SortCond*)sortCond{
    if (sortCond.sortType == SortTypeDefault) {
        [HCAnalysis HCUserClick:@"LowSortTypeDefault"];
    }else if (sortCond.sortType == SortTypeAgeAsc){
        [HCAnalysis HCUserClick:@"LowSortTypeAgeAsc"];
    }else if (sortCond.sortType == SortTypeMilesAsc){
        [HCAnalysis HCUserClick:@"LowSortTypeMilesAsc"];
    }else if (sortCond.sortType == SortTypePriceAsc){
        [HCAnalysis HCUserClick:@"LowSortTypePriceAsc"];
    }
}
//- (void)sortVehicle:(id)sortCond
//{
//       /// [self hideSortbgandSortview];
//        [self sortStatistic:(SortCond *)sortCond];
//        [self.dataFilter setSortCond:(SortCond *)sortCond];
//    if (self.dataFilter.sortCond.sortType != SortTypeDefault) {
//        [self.sortBtn setBackgroundImage:[UIImage imageNamed:@"sortBgRed"] forState:UIControlStateNormal];
//        [self.sortBtn setImage:[UIImage imageNamed:@"sortRed"] forState:UIControlStateNormal];
//         [self.sortBtn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
//    }else{
//        [self.sortBtn setBackgroundImage:[UIImage imageNamed:@"sortBgBlack"] forState:UIControlStateNormal];
//        [self.sortBtn setImage:[UIImage imageNamed:@"sortBlack"] forState:UIControlStateNormal];
//        [self.sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//        [self listPageUpdateByFilter:self.dataFilter];
//}

- (void)bgTappedAction:(UIGestureRecognizer *)gest
{
    [self updateVehicleSoure];
}

-(DataFilter*)dataFilter
{
    if (!_dataFilter) {
        _dataFilter = [[DataFilter alloc] init];
    }
    return _dataFilter;
}


#pragma mark 刷新控件

-(NSMutableDictionary*)setSortType
{

    NSMutableDictionary *sortDic = [[NSMutableDictionary alloc]init];
    if (self.dataFilter.sortCond==nil||self.dataFilter.sortCond.sortType==SortTypeDefault) {
        [sortDic setObject:@1 forKey:@"desc"];
        [sortDic setObject:@"time" forKey:@"order"];
    }
    
    if (self.dataFilter.sortCond&&[self.dataFilter.sortCond isValid]) {
        switch (self.dataFilter.sortCond.sortType) {
            case SortTypeAgeAsc:
                [sortDic setObject:@1 forKey:@"desc"];
                [sortDic setObject:@"register_time" forKey:@"order"];
                break;
            case SortTypeMilesAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"miles" forKey:@"order"];
                break;
            case SortTypePriceAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"price" forKey:@"order"];
                break;

            default:
                break;
        }
    }
    return sortDic;
}

- (void)updateVehicleSoure
{
    _isRefre = NO;
    NSMutableDictionary *sort = [self setSortType];
    [BizLowPriceVehicleSource getNewVehicleSourceRemote:_query sortDic:sort byfinish:^(NSArray * ret, NSInteger code, NSInteger count) {
        if (code == VehicleSourceUpdateFailed) {
            [self.mLowerTableView headerEndRefreshing];
            if (self.vehicleData.count == 0) {
                self.mNoView.hidden = NO;
            }
        } else if (code == VehicleSourceUpdateSuccess) {
            self.mNoView.hidden = YES;
            self.vehicleData = ret;

            _count = count;
            if ([self.vehicleData count] == 0) {

            [self.mLowerTableView setBackgroundView:nil];
            self.noVehicleDataView.hidden = NO;

            }else{
            self.mLowerTableView.hidden = NO;
            self.noVehicleDataView.hidden = YES;
            }
        }
        [self count:count];
        [_pageView timeDuration:1 superView:self.view pageNumber:_page];
        [self.mLowerTableView headerEndRefreshing];
        [_mLowerTableView reloadData];
    }];

}

- (void)count:(NSInteger)count
{
    BOOL isMultipleOfTen = !(count % 10);
    if (count-10 <= 0) {
        _page = 1;
    }else if(isMultipleOfTen== NO){
        _page = (int)count/10+1;
    }else if(isMultipleOfTen== YES){
        _page = (int)count/10;
    }
}


- (void)getHistoryVehicleSoure
{
    NSMutableDictionary *sort = [self setSortType];
    [BizLowPriceVehicleSource appendHistoryVehicleSource:self.vehicleData query:_query sortDic:sort byfinish:^(NSArray * ret, NSInteger code, NSInteger count) {
        if (code == VehicleSourceUpdateFailed) {
            [self showMsg:@"网络不给力" type:FVAlertTypeError];
        } else if (code == VehicleSourceUpdateSuccess) {
            self.vehicleData = ret;
             [self.mLowerTableView reloadData];
        } else if (code == VehicleSourceUpdateHistoryNone) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
        
         [_pageView timeDuration:1 superView:self.view pageNumber:_page];
        [self.mLowerTableView footerEndRefreshing];
       
    }];
}

- (void) hcDropDownListViewDidSelectRowAtIndexPath:(NSInteger)idx fromViewTag:(NSInteger)tagId conditon:(id)cond
{
    _isShowTab = NO;
   // [self.orderFilterView hide:YES];
    [self.dataFilter setSortCond:(SortCond *)cond];
    [self listPageUpdateByFilter:self.dataFilter];
}

- (void)listPageUpdateByFilter
{
    if (_isShowTab == NO) {
       // [self.orderFilterView show];
        _isShowTab = YES;
    }else{
        //[self.orderFilterView hide:YES];
        _isShowTab  = NO;
    }
}

- (void)headerRefreshing
{
    [self updateVehicleSoure];
}


- (void)footerRefreshing
{
    [self getHistoryVehicleSoure];
}

- (BOOL)nav:(BOOL)hidden{
    [super.navigationController setNavigationBarHidden:hidden animated:TRUE];
    return hidden;
}


#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    if (vehicle.nearCity!=nil){
        return HCSCREEN_WIDTH*0.21+5;
    }else if (vehicle.bangmaiCount !=0){
        return 350;
    }else{
       return HC_LOW_PRICE_VEHICLE_BIG_CELL_ROW_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.orderFilterView hide:YES];
    _isShowTab = NO;
    if ([self nav:YES]) {
        [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    }
    Vehicle *vehicles = [self.vehicleData HCObjectAtIndex:indexPath.row];
     if (vehicles.bangmaiCount==0&&vehicles.nearCity==nil) {
         if ([vehicles.vehicle_name hasPrefix:@"["]) {
            [HCAnalysis HCUserClick:@"lowlist_buwei_click"];
         }else{
             [HCAnalysis HCUserClick:@"lowlist_detail_click"];
            }
         
         
         [self pushToVehicelDetailandVehic:vehicles hadCom:YES vehicleChannel:@"超值"];
     }
}


#pragma mark -- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vehicleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.dataFilter getFilterRequestParam:3];
    Vehicle *vehicle ;
    if (self.vehicleData.count>0) {
       vehicle  = [self.vehicleData HCObjectAtIndex:indexPath.row];
    }
    
    if (vehicle.nearCity!=nil) {
        static NSString *cellIdentifier = @"hc_nearcity_cell";
        HCNearCityCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[HCNearCityCell alloc]initWithNearCity];
             cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setnearcity:vehicle];
        return  cell;
        
    }else if(vehicle.bangmaiCount!=0){
        static NSString *cellIdentifier = @"hc_bangmai_cell";
        HCbangmaiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSString *string = [self.vehicleinfo componentsJoinedByString:@" , "];
        if (!cell) {
            cell = [[HCbangmaiCell alloc]initWithbangmai];
            cell.delegate = self;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.contentView.userInteractionEnabled = YES;
        }
        [cell hideGusselike];
        [cell setVehicleInfoLabeltext:string];
        [cell resetPeopleNum:vehicle];
        return cell;
        
    }else{
        static NSString * cellIdentifier = @"hc_low_price_vehicle_big_cell";
        LowerPriceVehicleBigCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
             
            cell = [[LowerPriceVehicleBigCellTableViewCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_LOW_PRICE_VEHICLE_BIG_CELL_ROW_HEIGHT) data:vehicle];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return  cell;
        }
        [cell setVehicleData:vehicle];
        return cell;
        
    }
    
}

- (void)delegatePhone:(NSString *)phoneNum{
    if ([phoneNum isEqualToString:@"-1"]) {
        [self showMsg:@"手机号有误" type:FVAlertTypeError];
        return;
    }
    [BizHelpBuy requesthelpbuyWithphone:phoneNum query:_query word:[self.vehicleinfo componentsJoinedByString:@" , "] finish:^(NSInteger code) {
        if (code>=0) {
           [self showInfo:@"信息已提交，请等待客服联系" type:FVAlertTypeDone];
        }else{
           [self showMsg:@"提交失败" type:FVAlertTypeDone];
        }
    }];
}

- (void)lowCarInfo:(NSNotification*)userInfo{
    self.vehicleinfo = [userInfo.userInfo allValues];
}

- (void)visitBangmaiPage:(id)sender
{
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    nextViewController.title = @"帮买服务";
    nextViewController.url = [NSString stringWithFormat:BANGMAI_URL, (long)[BizUser getUserId]];
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)showLowAllVehicle:(id)sender

{
    CityElem *curCity = self.dataFilter.city;
    self.dataFilter = [[DataFilter alloc] init];
    self.dataFilter.city = curCity;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    [self refreshData:self.dataFilter];
}

- (void)prohibitionMovement:(BOOL)ishow{
    self.mLowerTableView.userInteractionEnabled = ishow;
}

- (void)listPageUpdateByFilter:(DataFilter *)filter
{
    [self refreshData:filter];
}

- (void)mEditing:(BOOL)open
{
    if (open == NO) {
        [UIView animateWithDuration:0.25f animations:^{
            self.view.top -=  100;
        }];
    }else{
        [UIView animateWithDuration:0.25f animations:^{
            self.view.top +=  100;
        }];
    }
}

-(void)refreshData:(DataFilter *)dataFilter
{
    self.dataFilter = dataFilter;
    _query = [dataFilter getFilterRequestParam:0];
    [_query setObject:[NSNumber numberWithInteger:self.dataFilter.city.cityId] forKey:@"city"];
    [_query setObject:[NSNumber numberWithInteger:1] forKey:@"suitable"];
    NSMutableDictionary *dict;
    if (dict==nil) {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:@"超值" forKey:@"VehicleChannel"];
    [dict setObject:[BizCity getCurCity].cityName forKey:@"city"];
    [dict setObject:dataFilter.brandSeriesCond.brandName forKey:@"VehicleBrand"];
    [dict setObject:dataFilter.priceCond.desc forKey:@"VehiclePrice"];
    [dict setObject:dataFilter.ageCond.desc forKey:@"VehicleAge"];
    [dict setObject:dataFilter.milesCond.desc forKey:@"VehicleMiles"];
    [dict setObject:dataFilter.gearboxCond.desc forKey:@"VehicleGearBox"];
    [dict setObject:dataFilter.emissionStandarCond.desc forKey:@"VehicleEmissionStandard"];
    [dict setObject:dataFilter.structureCond.desc forKey:@"VehicleStructure"];
    [dict setObject:dataFilter.emissionCond.desc forKey:@"VehicleEmission"];
    [dict setObject:dataFilter.sortCond.sortDesc forKey:@"VehicleSort"];
    [HCAnalysis HCclick:@"ViewClassifyPage" WithProperties:dict];
    [self.mLowerTableView headerBeginRefreshing];

}

- (void)cityShow:(BOOL)isHidden
{
    if (isHidden == YES) {
        [HCAnalysis HCUserClick:@"lowlist_city_click"];
        CGFloat x = [City getCityList].count%3;
        if (x == 0) {
            _height =  HCSCREEN_HEIGHT/10*([City getCityList].count/3)+110;
        }else{
            _height = HCSCREEN_HEIGHT/10*(1+[City getCityList].count/3)+110;
        }
        _cityViewController.view.frame = CGRectMake(0, self.listPageDropdownView.bottom, HCSCREEN_WIDTH,0);
        _cityViewController.arrayData = [City getCityList];
        _cityViewController.arrayHeight = _height;
        [self.view addSubview:_cityViewController.view];
        _mLowviewback.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            _cityViewController.view.frame =CGRectMake(0, self.listPageDropdownView.bottom,HCSCREEN_WIDTH,_height);
        } completion:^(BOOL finished) {
        }];
    }else{
        [self hidden_viewBack];
    }
}

static float lastContentOffset;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [UIView animateWithDuration:0.2 animations:^{
//            self.mLowerTableView.frame = CGRectMake(0, 20, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-20);
//            [super.navigationController setNavigationBarHidden:YES animated:TRUE];
//            self.tabBarController.tabBar.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, self.tabBarController.tabBar.height);
                }completion:^(BOOL finished) {
            self.sortBtn.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.sortBtn.hidden= NO;
//            [super.navigationController setNavigationBarHidden:NO animated:TRUE];
//            self.mLowerTableView.frame = CGRectMake(0, 108, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-154);
//            self.tabBarController.tabBar.frame = CGRectMake(0, HCSCREEN_HEIGHT-self.tabBarController.tabBar.height, HCSCREEN_WIDTH, self.tabBarController.tabBar.height);
            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH-15-HCSCREEN_WIDTH*0.14, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
