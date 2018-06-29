
//  HCVehicleListView.m
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCVehicleListView.h"
#import "HCVehicleCell.h"
#import "BizVehicleSource.h"
#import "UILabel+ITTAdditions.h"
#import "DataFilter.h"
#import "HCActivityCell.h"
#import "HCNodataView.h"
#import "BizUser.h"
#import "BizSearch.h"
#import "HCRecommendCell.h"
#import "HCNearCityCell.h"
#import "UIView+ITTAdditions.h"

#import "HCbangmaiCell.h"
#import "BizHelpBuy.h"
#import "UIButton+ITTAdditions.h"
#import "PageView.h"
#import "BizCity.h"
#import "HCSubBtn.h"


#import "HCBuyListCell.h"

@interface HCVehicleListView()<HCbangmaiDelegate>{

    UIButton *version;
}
@property (nonatomic, strong) NSMutableDictionary *dicInfo;
@property (nonatomic, strong) NSMutableDictionary *query;
@property (nonatomic, strong) UILabel *mViewLabelNumber;
@property (nonatomic, strong) NSString *vehicelName;
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic)BOOL isChangeDatafilter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *strMensss;
@property (nonatomic, strong) NSString *strNameSearch;
@property (nonatomic)BOOL timeChange;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *mNoView;
@property (nonatomic, strong) NSTimer* mTime;

//[timer invalidate]
@property (nonatomic, strong) NSArray *arrayAll;
@property (nonatomic, strong) NSArray *vehicleData;
@property (nonatomic, assign) ScreeningStatus screeningStatus;
@property (nonatomic, strong) PageView *pageView;
@property (nonatomic, strong)NSMutableArray *bangmaiArray;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic)BOOL isRecommend;


@property (nonatomic)NSInteger vehicleNum;

@property (nonatomic, strong) UIView *topadView;
@property (nonatomic, strong) UIImageView *adimageView;


@end
static NSTimeInterval timeInterval = 1;
@implementation HCVehicleListView

- (id)initWithFrame:(CGRect)frame filter:(DataFilter *)dataFilter
{
    self = [super initWithFrame:frame];
#pragma mark - sign
    _isShow = NO;  self.isRecommend = NO;
    _isChangeDatafilter = YES;

    if (_bangmaiArray==nil) {
        _bangmaiArray  =[[NSMutableArray alloc]init];
    }
    if (_titleArray==nil) {
        _titleArray  = [[NSMutableArray alloc]init];
    }
    if (_query   == nil) {_query = [[NSMutableDictionary alloc]init];}
    [self initQuery:dataFilter];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetdatafiler) name:@"resetFilter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchresult:) name:@"SearchResult"object:nil];
#pragma maek - TableView
    if (self){
        self.dataFilter1 = dataFilter;
        [self TableView:frame];
        [self NodataView];
    }
    _pageView = [[PageView alloc]initWithFrameRect:CGRectMake(HCSCREEN_WIDTH/2.34, HCSCREEN_HEIGHT-60, HCSCREEN_WIDTH-(HCSCREEN_WIDTH/2.34*2), 20)];
    return self;
}
#pragma mark --timer
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
    NSArray *cells = [self.mTableView visibleCells];
    for (HCVehicleCell *cell in cells) {
       // NSIndexPath *indexPath = [self.mTableView indexPathForCell:cell];
    //    Vehicle *vehicle = self.vehicleData[indexPath.item];
        if ([cell isKindOfClass:[HCVehicleCell class]]) {
            if (cell.vehicle.qianggou!=0) {
                if (![cell endTime:cell.vehicle]) {
                    [cell changeTime:cell.vehicle.qianggou];
                }else{
                    [cell endtimeHide];
                    self.timeChange = YES;
                    [self.mTableView reloadData];
                }
            }
            
        }
       
    }
    
}

- (void)NodataView
{
    self.mNoView = [HCNodataView getNetwordErrorViewWith:@"您的网络不太给力哦~" view:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -80, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRefresh:)];
    [self.mNoView addGestureRecognizer:bgTap];
    [self addSubview:self.mNoView];
    self.mNoView.hidden = YES;
}


#define TABLEW frame.size.width

- (UITableView *)TableView:(CGRect)frame
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,TABLEW,HCSCREEN_HEIGHT-154) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.showsVerticalScrollIndicator = NO;
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.mTableView];
    [self setupRefresh:self.mTableView];
    [self.mTableView headerBeginRefreshing];
    return self.mTableView;
}

//2.8.3更改的
- (void)initQuery:(DataFilter *)dataFilter
{
    [_query setObject:[NSNumber numberWithInteger:self.dataFilter1.city.cityId] forKey:@"city"];//********
    [_query setObject:[NSNumber numberWithInteger:0] forKey:@"suitable"];
    [_query addEntriesFromDictionary:[dataFilter getFilterRequestParam:1]];
    self.arrayAll = [dataFilter getCondDescArray];

}


- (void)gestureRefresh:(UIGestureRecognizer *)gest
{
    [self resetdatafiler];
}


- (void)resetdatafiler
{
    _strNameSearch = nil;
    self.arrayAll = @[];
    _query = [[NSMutableDictionary alloc]init];
   [_query setObject:[NSNumber numberWithInteger:self.dataFilter1.city.cityId] forKey:@"city"];
    [_query setObject:[NSNumber numberWithInteger:0] forKey:@"suitable"];
    _dataFilter1 = [self.dataFilter1 cleanAllData];

    [self refreshData:_dataFilter1];
    _isShow= NO;
    [_mTableView reloadData];
    if (self.delegate) {
        [self.delegate resetFilter:1];
    }
}

#pragma mark 请求数据
static int page;
- (void)updateVehicles:(NSMutableDictionary*)query
{
//    if (self.delegate) {
//        [self.delegate isBtnClick:NO];
//    }
    if ([query objectForKey:@"type"]) {
        [query removeObjectForKey:@"type"];
    }
    if (![query objectForKey:@"suitable"]) {
        [query setObject:@0 forKey:@"suitable"];
    }
    if (query.count ==2) {
        _isShow = NO;
    }else{
        _isShow = YES;
    }
//    [query removeObjectForKey:@"city"];
    
    NSMutableDictionary *dict = [self setSortType:self.dataFilter1];
    [BizVehicleSource getVehicelSource:query sortDic:dict
    byfinish:^(NSArray *ret,NSArray *recommend, NSInteger code,NSInteger count,NSInteger allNumber)
     {
        if (code == VehicleSourceUpdateFailed) {

            if ([self.vehicleData count] == 0) {
                self.mNoView.hidden = NO;
            }else{
                [self showMessage:1];
            }
        } else if (code == VehicleSourceUpdateSuccess) {
            self.mNoView.hidden = YES;
            if (recommend.count == 0) {
                self.vehicleData = ret;
                self.isRecommend = NO;
                if (ret.count==0) {
                    NSMutableArray *data = [NSMutableArray arrayWithArray:ret];
                    [data insertObject:[[Vehicle alloc]init] atIndex:0];
                    self.vehicleData = data;
                    self.isRecommend = YES;
                }
            }else{
                self.vehicleData = recommend;
                self.isRecommend = YES;
            }
            self.vehicleNum = count;
        }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self count:self.vehicleNum];
             [self.mTableView headerEndRefreshing];
             [_pageView timeDuration:1 superView:self pageNumber:page];
             [self.mTableView reloadData];
             [self.mViewLabelNumber removeFromSuperview];
             self.mViewLabelNumber = [UIView numberAddView:self and:count];
//             self.mTableView.tableHeaderView = nil;
         });
//         if (recommend.count == 0) {
//         }else{
//             self.mTableView.tableHeaderView = self.topadView;
//         }
        NSTimeInterval timeInterval = 1.0;
        _mTime = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:)userInfo:nil repeats:NO];
    }];
}

- (void)count:(NSInteger)count
{
    BOOL isMultipleOfTen = !(count % 10);
    if (self.vehicleNum-10 <= 0) {
        page = 1;
    }else if(isMultipleOfTen== NO){
        page = (int)count/10+1;
    }else if(isMultipleOfTen== YES){
        page = (int)count/10;
    }
}

- (void)handleMaxShowTimer:(NSTimer *)timer{
    [self.mViewLabelNumber removeFromSuperview];
    [_mTime invalidate];  //防止内存泄露
}

- (void)getHistoryVehicleSource
{
    NSMutableDictionary *dict = [self setSortType:self.dataFilter1];
    [BizVehicleSource appendHistoryVehicleSource:self.vehicleData query:_query sortDic:dict byfinish:^(NSArray *ret, NSInteger code, NSInteger count,NSInteger numberPage) {
        if (code == VehicleSourceUpdateFailed) {
            [self showMessage:1];
        } else if (code == VehicleSourceUpdateSuccess) {
            self.vehicleData = ret;
            [self.mTableView reloadData];
        } else if (code == VehicleSourceUpdateHistoryNone) {
            [self showMessage:0];
        }
        [_pageView timeDuration:1 superView:self pageNumber:page];
        [self.mTableView footerEndRefreshing];
      
    }];
}

-(void)refreshData:(DataFilter *)dataFilter //筛选1
{
    _isChangeDatafilter = YES;
    self.dataFilter1 = dataFilter;
    [self.mTableView setTop:0];
    [_query removeAllObjects];
    [_query setObject:[NSNumber numberWithInteger:self.dataFilter1.city.cityId] forKey:@"city"];
    [_query setObject:[NSNumber numberWithInteger:0] forKey:@"suitable"];
    [_query addEntriesFromDictionary:[dataFilter getFilterRequestParam:1]];

    if ([dataFilter isValid]) {
        _isShow = YES;
    }else{
        _isShow = NO;
    }
    NSMutableDictionary *dict;
    if (dict==nil) {
        dict = [[NSMutableDictionary alloc]init];
    }
    [dict setObject:@"全部" forKey:@"VehicleChannel"];
    [self getVehicleInfoFromDatafile:dataFilter dict:dict];
    [HCAnalysis HCclick:@"ViewClassifyPage" WithProperties:dict];
    self.arrayAll = [dataFilter getCondDescArray];
    [self.mTableView headerBeginRefreshing];

}
- (void)getVehicleInfoFromDatafile:(DataFilter*)dataFilter dict:(NSMutableDictionary*)dict{
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
    
}
#pragma mark -- subscribeVehicle
- (void)subscribeVehicle:(UIButton *)subscribebtn
{
    if ([self.dataFilter1 isValid]==YES|| _strNameSearch!=nil) {
        _isShow = YES;
        _dicInfo = [self.dataFilter1  getFilterRequestParams];
        [_dicInfo setObject:[NSNumber numberWithInteger:self.dataFilter1.city.cityId] forKey:@"city_id"];
        [_dicInfo setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    }else{
        _isShow = NO;
    }
    if (_dicInfo.count <= 2) {
        return;
    }
    NSMutableDictionary *dict;
    if (dict==nil) {
        dict = [[NSMutableDictionary alloc]init];
    }
    [self getVehicleInfoFromDatafile:self.dataFilter1 dict:dict];
    [HCAnalysis HCclick:@"VehiclesSubscribe" WithProperties:dict];
    
     subscribebtn.userInteractionEnabled = YES;
    if ([[HCLogin standLog] isLog]) {
            [BizVehicleSource getNeSubscribe:0 Parame:_dicInfo show:^(NSString *strMess) {
                if (strMess) {
                    _strMensss = strMess;
                    return ;
                }
            } byfinish:^(NSArray *ret, NSInteger code) {

                if (code == VehicleSourceUpdateFailed){
                    if ([_strMensss length] > 15)
                    {

                        [self showMessage:1];
                    }else{
                        [self showMessage:3];
                    }
                    return ;
                }else if (code == VehicleSourceUpdateSuccess){
                    _isShow = YES;
                    [self showMessage:2];
                    [_mTableView reloadData];
                    //versionTag.userInteractionEnabled = NO;
                    [version setTitle:@"成功提醒" forState:UIControlStateNormal];
                    version.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
                    [version setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    version.userInteractionEnabled = NO;
                 }
            } dataFilter:self.dataFilter1];
    }else{
        if (self.delegate) {
            [self.delegate JumpViewcontroller:nil];
        }
    }
}

- (void)showMessage:(NSInteger)type
{
    if (self.delegate) {
        if (type==0) {
            [self.delegate showMessage:@"没有车源了" type:FVAlertTypeDone];
        }else if(type==1){
            [self.delegate showMessage:@"网络不给力" type:FVAlertTypeError];

        }else if(type == 2){
            [self.delegate showSubSuccessInfo];
        }else{
            [self.delegate showMessage:_strMensss type:FVAlertTypeWarning];
        }
    }
}
- (void)headerRefreshing
{
    [_query setObject:[NSNumber numberWithInteger:self.dataFilter1.city.cityId] forKey:@"city"];
    [_query setObject:[NSNumber numberWithInteger:0] forKey:@"suitable"];
    [self updateVehicles:_query];
    
}

- (void)footerRefreshing
{
    
    [self getHistoryVehicleSource];
  
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.vehicleData.count) {
//        return UITableViewAutomaticDimension;
//    }else{
        Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
        
        if (self.isRecommend==YES) {
            if (indexPath.row==0) {
                return HCSCREEN_WIDTH*0.33+5;
            }else{
                if (vehicle.title!=nil&&![vehicle.title isEqualToString:@""]) {
                    return HCSCREEN_WIDTH/vehicle.pic_rate+5;
                }else if (vehicle.nearCity!=nil&&![vehicle.nearCity isEqualToString:@""]){
                    return HCSCREEN_WIDTH*0.21+5;
                }else if (vehicle.bangmaiCount !=0){
                    return 350;//+ HCSCREEN_WIDTH*0.14;
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
                    
                }
            }
        }else{
            if (vehicle.title!=nil&&![vehicle.title isEqualToString:@""]) {
                return HCSCREEN_WIDTH/vehicle.pic_rate+5;
            }else if (vehicle.nearCity!=nil&&![vehicle.nearCity isEqualToString:@""]){
                return HCSCREEN_WIDTH*0.21+5;
            }else if (vehicle.bangmaiCount !=0){
                return 350;
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
                
            }
        }
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isRecommend==YES&&indexPath.row==0){
        
    }else{
        if(self.vehicleData.count>0){
            Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
        if (vehicle.bangmaiCount==0&&vehicle.nearCity==nil) {
            [self.mTableView reloadData ];
            _isShowTab = NO;
            if (self.delegate) {
                [self.delegate hcVehicleCellSelected:vehicle];
            }
        }
      }
    }
}

#pragma mark -- UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isShow && _query.count > 2) {
        
        return 50;
    }else{
        return 0;
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width=24;
    CGFloat height=24;
    return CGRectMake(0, 0, width, height);
}

#pragma mark - PrivateVariable
- (void)viewBtn:(UIView*)viewBtn
{
    version = [UIButton listView:viewBtn target:self action:@selector(subscribeVehicle:)];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (_view==nil) {
        _view = [[UIView alloc]init];
        _view.backgroundColor = MTABLEBACK;
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, HCSCREEN_WIDTH-100, 50)];
        [_mScrollView setShowsHorizontalScrollIndicator:NO];
        _mScrollView.backgroundColor = MTABLEBACK;
        [_view addSubview:_mScrollView];
    }
   
    if (_isShow) {
        if (_isChangeDatafilter==YES) {
            if (_mScrollView.subviews.count!=0) {
                [_mScrollView removeAllSubviews];
            }
        
        [self viewBtn:_view];
        int   W = 0;
            if (self.bangmaiArray.count!=0) {
                [self.bangmaiArray removeAllObjects];
            }
        for (int i = 0; i<self.arrayAll.count; i++) {
            HCSubBtn *termBtn = [[HCSubBtn alloc]initWithSubCond:[self.arrayAll objectAtIndex:i]];
            termBtn.backgroundColor = [UIColor whiteColor];
            //termBtn.tag = i;

            CGFloat btnWidth;
            if (IOS_VERSION_8_OR_ABOVE) {
                [termBtn.titleLabel sizeToFit];
                 btnWidth = termBtn.titleLabel.width+25;
            }else{
                CGRect tmpRect = [termBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] context:nil];
                ///CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:SEG_FONT] constrainedToSize:CGSizeMake(MAXFLOAT, 35) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize size = tmpRect.size;
                 btnWidth = size.width+25;
            }
            termBtn.frame = CGRectMake(W+8, 10, btnWidth, 32);
            UIImageView* closeView = [[UIImageView alloc]init];
            closeView.frame = CGRectMake(termBtn.width-16, termBtn.height-16, 16, 16);
            closeView.image = [UIImage imageNamed:@"graycancle"];
            [termBtn addSubview:closeView];

            W = termBtn.right;
            termBtn.selected = YES;
            [termBtn addTarget:self action:@selector(removeCondAndQuery:) forControlEvents:UIControlEventTouchUpInside];

            [_mScrollView addSubview:termBtn];
            }
        _isChangeDatafilter = NO;
        _mScrollView.contentSize = CGSizeMake(W, _view.height);
            
        }
    }
    return _view;
}


- (void)removeCondAndQuery:(HCSubBtn*)btn{
    
    [_bangmaiArray removeObject:btn];
    _isChangeDatafilter = YES;
    self.dataFilter1 = [self.dataFilter1 removeQueryCond:btn.subCond withdatafile:self.dataFilter1];
    //self.mDataFilter = [self.dataFilter1 cleanAllData];
    [self.delegate listViewUpdateWithfilter:self.dataFilter1];
    //[self refreshData: self.mDataFilter];
}

- (void)searchresult:(NSNotification*)notifi
{
//    if (self.delegate) {
//        [self.delegate emptyAll];
//    }
    _isChangeDatafilter = YES;
    self.dataFilter1 = [self.dataFilter1 cleanAllData];
    _isShow = YES;
    self.dataFilter1 = notifi.object;
    NSDictionary *dic = [self.dataFilter1 getFilterRequestParam:1];
    _query = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([dic objectForKey:@"searchString"]) {
        self.arrayAll  = [NSArray arrayWithObject:[dic objectForKey:@"searchString"]];
        [self.delegate listViewUpdateWithfilter:self.dataFilter1];
//        [self updateVehicles:_query];
    }else{
         [self.delegate listViewUpdateWithfilter:self.dataFilter1];
    }

}
- (void)mEditing:(BOOL)open
{
    if (open == NO) {
        [UIView animateWithDuration:0.25f animations:^{
            self.top -=  100;
        }];
    }else{
        [UIView animateWithDuration:0.25f animations:^{
            self.top +=  100;
        }];

    }
}

- (void)updateSearchResult:(NSString*)query{
    
    [BizSearch getSearchResultWithText:query ByFinish:^(NSArray * ret, NSInteger code ,NSInteger num, NSDictionary* quer) {
        if (code!=0){
            
        }else{
            if (ret.count>0) {
                self.isRecommend= YES;
                self.vehicleData = ret;
                self.vehicleNum  = num;
            }
        }
        [self.mTableView reloadData];
        [self.mTableView headerEndRefreshing];
    }];
  
}

- (void)postSearchMessage{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.dataFilter1 forKey:@"dataFilter"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFilterSelected" object:nil userInfo: param];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vehicleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    if (self.isRecommend==YES) {  //判断时候有无数据
        if (indexPath.row==0) {//推荐
            static NSString *cellIdentifier = @"hc_recommed_cell";
            HCRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[HCRecommendCell alloc]initWithRecommed];
                cell.selectionStyle =  UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                return  cell;
            }
            return cell;
        }else{
            if (vehicle.nearCity!=nil&&![vehicle.nearCity isEqualToString:@""]) {   //附加城市车源展示
                static NSString *cellIdentifier = @"hc_nearcity_cell";
                HCNearCityCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[HCNearCityCell alloc]initWithNearCity];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                }
                [cell setnearcity:vehicle];
                return  cell;
                
            }else if(vehicle.title!=nil&&![vehicle.title isEqualToString:@""]){
                static NSString *cellIdentifier = @"hc_activity_cell";
                HCActivityCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[HCActivityCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH/vehicle.pic_rate+5) data:vehicle];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }
                return  cell;
            }else if(vehicle.bangmaiCount!=0){
                static NSString *cellIdentifier = @"hc_bangmai_cell";
                HCbangmaiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                NSString *string =[self.dataFilter1 getCondeDescString];
                
                if (!cell) {
                    cell = [[HCbangmaiCell alloc]initWithbangmai];
                    cell.delegate = self;
                    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.contentView.userInteractionEnabled = YES;
                }
                if (self.vehicleData.count<=2)
                {
                     [cell hideGusselike];
                }
                if (self.arrayAll.count!=0)
                {
                    [cell setVehicleInfoLabeltext:string];
                }
               
                [cell resetPeopleNum:vehicle];
                return cell;
                
            }else{
                static NSString * cellIdentifier = @"hc_vehicle_cell";
                HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    return  cell;
                }
                    [cell setVehicleData:vehicle];
//                HCBuyListCell *cell = [HCBuyListCell creatTableViewCellWithTableView:tableView];
//                cell.vehicle = vehicle;
//                return cell;
            }
        }
    }else{
            if (vehicle.nearCity!=nil&&![vehicle.nearCity isEqualToString:@""]) {
                    static NSString *cellIdentifier = @"hc_nearcity_cell";
                    HCNearCityCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[HCNearCityCell alloc]initWithNearCity];
                        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    [cell setnearcity:vehicle];
                    return  cell;

            }else if(vehicle.title!=nil&&![vehicle.title isEqualToString:@""]){
                    static NSString *cellIdentifier = @"hc_activity_cell";
                    HCActivityCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[HCActivityCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH/vehicle.pic_rate+5) data:vehicle];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    return  cell;
            }else if(vehicle.bangmaiCount!=0){
                static NSString *cellIdentifier = @"hc_bangmai_cell";
                HCbangmaiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
              NSString *string =[self.dataFilter1 getCondeDescString];
                
                if (!cell) {
                    cell = [[HCbangmaiCell alloc]initWithbangmai];
                    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.contentView.userInteractionEnabled = YES;
                }
                [cell hideGusselike];
                [cell setVehicleInfoLabeltext:string];
                [cell resetPeopleNum:vehicle];
                return cell;
            
            }else{
                static NSString * cellIdentifier = @"hc_vehicle_cell";
                HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
               
                if (!cell) {
                   
                    cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    return  cell;
                }
                     [cell setVehicleData:vehicle];
               
                return cell;
//                HCBuyListCell *cell = [HCBuyListCell creatTableViewCellWithTableView:tableView];
//                cell.vehicle = vehicle;
//                return cell;
            }
    }
    return nil;
}

- (void)delegatePhone:(NSString *)phoneNum{
    
    if ([phoneNum isEqualToString:@"-1"]) {
        [self.delegate showMessage:@"手机号有误" type:FVAlertTypeError];
        return;
    }
    [BizHelpBuy requesthelpbuyWithphone:phoneNum query:_query word:[self.dataFilter1 getCondeDescString] finish:^(NSInteger code) {
                if (code>=0) {
                    [self.delegate showInfoMess:@"信息已提交，请等待客服联系" type:FVAlertTypeDone];   //NSLog(@"提交成功");
                }else{
                    [self.delegate showMessage:@"提交失败" type:FVAlertTypeError];   //NSLog(@"提交失败");
                }
            }];
}

static float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
    NSNotification *carInfo =[NSNotification notificationWithName:@"close" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:carInfo];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y){
        _isShowTab = NO;
    }
    CGFloat sectionHeaderHeight = 55;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);

    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }

}

- (UIView *)topadView{
    if (_topadView == nil) {
        _topadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Width(120))];
        self.adimageView = [[UIImageView alloc]initWithFrame:CGRectMake(Width(15), Width(10), kScreenWidth - Width(30), Width(100))];
        self.adimageView.userInteractionEnabled = YES;
        [self.adimageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adaction)]];
        self.adimageView.image = [UIImage imageNamed:@"default_vehicle"];
        self.adimageView.backgroundColor = [UIColor orangeColor];
        self.adimageView.layer.cornerRadius = Width(5);
        self.adimageView.layer.masksToBounds = YES;
        [_topadView addSubview:self.adimageView];
        _topadView.clipsToBounds = YES;
    }
    return _topadView;
}

- (void)adaction{
    NSLog_L(@"点击广告");
}

@end
