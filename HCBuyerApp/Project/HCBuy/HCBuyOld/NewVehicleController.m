//
//  HCBuyerApp
//
//  Created by wj on 15/6/25.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "NewVehicleController.h"
#import "VehicleDetailViewController.h"
#import "ListPageDropdownView.h"
#import "UIImage+RTTint.h"
#import "HCNodataView.h"
#import "BizUser.h"
#import "SortView.h"
#import "CityViewController.h"
#import "HCDropdownListView.h"
#import "DataFilter.h"
#import "BizCity.h"
#import "BizHelpBuy.h"
#import "UIButton+ITTAdditions.h"
#import "UiTapView.h"
#import "UIView+ITTAdditions.h"
#import "HCVehicleCell.h"
#import "PageView.h"
#import "BizNewViehicle.h"
#import "HCTodayNewVehicleCell.h"
@interface NewVehicleController ()< UIGestureRecognizerDelegate, HCListPageDropdownSelectedDelegate,HCDropdowListViewDataDelegate,UiTapViewDeleate>

#pragma mark - TheClassNameAndView

@property (nonatomic, strong) UIView *noVehicleDataView;
@property (nonatomic, strong) UIView *networkErrorView;
@property (nonatomic, strong) UIView *mNoView;
@property (nonatomic, strong) UIView *mLowviewback;
@property (nonatomic, assign) float lastContentOffset;

@property (nonatomic, strong) DataFilter *dataFilter;
@property (nonatomic, strong) NSMutableDictionary *query;
@property (nonatomic, strong) UiTapView *tapView;


@property (nonatomic, strong) NSArray *orderData;
@property (nonatomic, strong) NSArray *vehicleData;
@property (nonatomic, strong) NSArray *vehicleinfo;

 @property (nonatomic) BOOL isLoadFinish;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger page;

@property (nonatomic, strong) PageView *pageView;
@property (nonatomic, strong) NSTimer *timer;


@end
static BOOL isInit = NO;
static DataFilter *predefinedDataFilter = nil;
static NSTimeInterval timeInterval = 1;

@implementation NewVehicleController

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
- (void)startTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer =  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerAction {
    NSArray *cells = [self.vehcleTableView visibleCells];
    for (HCVehicleCell *cell in cells) {
       // NSIndexPath *indexPath = [self.vehcleTableView indexPathForCell:cell];
        //    Vehicle *vehicle = self.vehicleData[indexPath.item];
        if ([cell isKindOfClass:[HCVehicleCell class]]) {
            if (cell.vehicle.qianggou!=0) {
                if (![cell endTime:cell.vehicle]) {
                    [cell changeTime:cell.vehicle.qianggou];
                }else{
                    [cell endtimeHide];
                    [self.vehcleTableView reloadData];
                }
            }
            
        }
        
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushFilterSelected:) name:@"LowFilterSelected" object:nil];
    [self initData];
    isInit = YES;
    _isLoadFinish = NO;
    if (!_query) {
        _query = [[NSMutableDictionary alloc]init];
    }
    
    if (predefinedDataFilter) {
        [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:@"CityChanged" object:nil];
    [self.dataFilter setCity:[BizCity getCurCity]];
//    _cityViewController = [CityViewController shareCity];
//    _cityViewController.delegate = self;
    [self creatBackButton];
    [self DataView];
    
    [self.vehcleTableView headerBeginRefreshing];
}

+(BOOL)isInit
{
    return isInit;
}
//
//- (void)PushFilterSelected:(NSNotification*)notif{
//    DataFilter *dataFilter = (DataFilter *)[[notif userInfo] objectForKey:@"dataFilter"];
//    self.dataFilter = dataFilter;
//    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
//    [self refreshData:self.dataFilter];
//}

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
        [self.vehcleTableView headerBeginRefreshing];
    }
    
    //[self.listPageDropdownView getCurrentCity];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
    //if (_isRefre == YES) {
    
    //}
    
}

//- (void)setdelegate{
//    if (self.cityViewController) {
//        self.cityViewController.delegate = self;
//    }
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewWillDisappear:animated];
}

- (void)tapGestureView
{
    //[self cityShow:NO];
    [self.listPageDropdownView setSegmentUnselected:0];
}

//- (void)hidden_viewBack
//{
//    _mLowviewback.hidden = YES;
//    _cityViewController.view.frame = CGRectMake(0, -_height-110 , HCSCREEN_WIDTH, -_height-110);
//    [self.listPageDropdownView setSegmentUnselected:-1];
//}

//
//- (void)pushViewController:(NSInteger)ID CityName:(NSString *)name CityId:(NSInteger)cityId
//{
//    [self hidden_viewBack];
//}

- (void)DataView
{
    self.listPageDropdownView = [[ListPageDropdownView alloc] initWithframe:CGRectMake(0, 64, HCSCREEN_WIDTH, 44) forData:self.dataFilter forSuperView:self.view delegate:self coverTabbar:YES suitable:1];
    self.listPageDropdownView.isTodayNew = YES;
    self.listPageDropdownView.delegate = self;
    //self.segmentMinYpos = self.listPageDropdownView.segmentViewMinYPos;
    //self.segmentMaxYpos = self.listPageDropdownView.segmentViewMaxYPos;
   // [self.listPageDropdownView getCurrentCity];
    [self.view addSubview:self.listPageDropdownView];
    
    self.vehcleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.listPageDropdownView.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-154)];
    self.vehcleTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.vehcleTableView.delegate = self;
    self.vehcleTableView.dataSource = self;
    [self setupRefresh:self.vehcleTableView];
    [self.view addSubview:self.vehcleTableView];
    self.lastContentOffset = 0;//下面的是没有筛选出东西来
    
    self.noVehicleDataView = [HCNodataView createNoVehicleView:_noVehicleDataView target:self action1:@selector(showLowAllVehicle:) action2:@selector(visitBangmaiPage:) fram:CGRectMake(0, 0, 0, 0) text:nil andText:@"查看全部新上" ishow:NO];
    
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
        [self.vehcleTableView headerBeginRefreshing];
    }
    
    _mLowviewback = [UIView viewbackAddSuperVIew:CGRectMake(0, 108, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    _tapView = [[UiTapView alloc]initWithFrame:_mLowviewback];
    _tapView.tapdelegate = self;
    [self.view addSubview:_mLowviewback];
    _pageView = [[PageView alloc]initWithFrameRect:CGRectMake(HCSCREEN_WIDTH/2.34, HCSCREEN_HEIGHT-40, HCSCREEN_WIDTH-(HCSCREEN_WIDTH/2.34*2), 20)];
    
}

- (void)sortStatistic:(SortCond*)sortCond{
    if (sortCond.sortType == SortTypeDefault) {
        [HCAnalysis HCUserClick:@"NewSortTypeDefault"];
    }else if (sortCond.sortType == SortTypeAgeAsc){
        [HCAnalysis HCUserClick:@"NewSortTypeAgeAsc"];
    }else if (sortCond.sortType == SortTypeMilesAsc){
        [HCAnalysis HCUserClick:@"NewSortTypeMilesAsc"];
    }else if (sortCond.sortType == SortTypePriceAsc){
        [HCAnalysis HCUserClick:@"NewSortTypePriceAsc"];
    }
}

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
            case SortTypePriceDsc:
                [sortDic setObject:@1 forKey:@"desc"];
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
    _isLoadFinish = NO;
    NSMutableDictionary *sort = [self setSortType];
    [BizNewViehicle getTodayNewVehicleSourceRemote:_query sortDic:sort byfinish:^(NSArray * ret, NSInteger code, NSInteger count) {
        if (code == VehicleSourceUpdateFailed) {
            [self.vehcleTableView headerEndRefreshing];
            if (self.vehicleData.count == 0) {
                self.mNoView.hidden = NO;
            }
        } else if (code == VehicleSourceUpdateSuccess) {
            self.mNoView.hidden = YES;
            self.vehicleData = ret;
            _count = count;
            if ([self.vehicleData count] == 0) {
                [self.vehcleTableView setBackgroundView:nil];
                self.noVehicleDataView.hidden = NO;
            }else{
                self.vehcleTableView.hidden = NO;
                self.noVehicleDataView.hidden = YES;
            }
        }
        [self count:count];
        [_pageView timeDuration:1 superView:self.view pageNumber:_page];
        [self.vehcleTableView headerEndRefreshing];
        [self.vehcleTableView reloadData];
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
    [BizNewViehicle appendTodayHistoryVehicleSource:self.vehicleData query:_query sortDic:sort byfinish:^(NSArray * ret, NSInteger code, NSInteger count) {
        if (code == VehicleSourceUpdateFailed) {
            [self showMsg:@"网络不给力" type:FVAlertTypeError];
        } else if (code == VehicleSourceUpdateSuccess) {
            self.vehicleData = ret;
            [self.vehcleTableView reloadData];
        } else if (code == VehicleSourceUpdateHistoryNone) {
            _isLoadFinish = YES;
            [self.vehcleTableView reloadData];
           // [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
        
       [_pageView timeDuration:1 superView:self.view pageNumber:_page];
        [self.vehcleTableView footerEndRefreshing];
        
    }];
}

- (void) hcDropDownListViewDidSelectRowAtIndexPath:(NSInteger)idx fromViewTag:(NSInteger)tagId conditon:(id)cond
{
    
}

- (void)listPageUpdateByFilter
{
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
     Vehicle *vehicle = [self.vehicleData objectAtIndex:indexPath.row];
    if (_isLoadFinish==YES&&indexPath.row==self.vehicleData.count) {
        return HCSCREEN_WIDTH *0.13;
    }else{
       
        if (_isLoadFinish==YES&&indexPath.row==self.vehicleData.count) {
            return HCSCREEN_WIDTH *0.13;
        }else{
            if (vehicle.qianggou!=0) {
                NSInteger dataNow = [[NSDate date]timeIntervalSince1970];
                if (vehicle.qianggou <=dataNow) {
                    return HC_VEHICLE_LIST_ROW_HEIGHT+5;
                }else{
                    return HC_VEHICLE_LIST_ROW_HEIGHT+5+20+HCSCREEN_WIDTH*0.048;
                }
            }else if (vehicle.act_text.length!=0){
                return HC_VEHICLE_LIST_ROW_HEIGHT+5+20+HCSCREEN_WIDTH*0.048;
            }else{
                return HC_VEHICLE_LIST_ROW_HEIGHT+5;
            }
            
            return HC_VEHICLE_LIST_ROW_HEIGHT+5;
        }
        

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.vehicleData.count) {
        Vehicle *vehicles = [self.vehicleData HCObjectAtIndex:indexPath.row];
        [HCAnalysis HCUserClick:@"Today_NewClick"];
        [self pushToVehicelDetailandVehic:vehicles hadCom:YES vehicleChannel:@"新上"];
    }
}


#pragma mark -- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isLoadFinish ==YES) {
          return self.vehicleData.count+1;
    }else{
        return self.vehicleData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.dataFilter getFilterRequestParam:3];
    Vehicle *vehicle ;
    if (_isLoadFinish==YES&&indexPath.row==self.vehicleData.count) {
        NSString *NewBottomCell = @"NewBottomCell";
        HCTodayNewVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:NewBottomCell];
        if (cell==nil) {
            cell = [[HCTodayNewVehicleCell alloc]initWithCellStyle:UITableViewCellStyleDefault reuseIdentifier:NewBottomCell];
            cell.isHaveLine = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        if (indexPath.row < self.vehicleData.count) {
            vehicle  = [self.vehicleData HCObjectAtIndex:indexPath.row];
        }
        static NSString * cellIdentifier = @"hc_vehicle_cell";
        HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return  cell;
        }
        [cell setVehicleData:vehicle];
        return cell;
    }
    return nil;
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


- (void)listPageUpdateByFilter:(DataFilter *)filter
{
    [self refreshData:filter];
}



-(void)refreshData:(DataFilter *)dataFilter
{
    self.dataFilter = dataFilter;
    [self.listPageDropdownView reloadDataByDataFilter:self.dataFilter];
    _query = [dataFilter getFilterRequestParam:0];
    [_query setObject:[NSNumber numberWithInteger:self.dataFilter.city.cityId] forKey:@"city"];
    NSMutableDictionary *dict;
    if (dict==nil) {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:@"新上" forKey:@"VehicleChannel"];
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
    [self.vehcleTableView headerBeginRefreshing];
}


static float lastContentOffset;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    if (lastContentOffset < scrollView.contentOffset.y) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//            self.sortView.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, 0, 0);
//            [self.sortView resetTableViewFrame:YES];
//        }completion:^(BOOL finished) {
//            self.sortBtn.hidden = YES;
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            self.sortBtn.hidden= NO;
//            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH-15-HCSCREEN_WIDTH*0.14, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//        }];
//    }
//}
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