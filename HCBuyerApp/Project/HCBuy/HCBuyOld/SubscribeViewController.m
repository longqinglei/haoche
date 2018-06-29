//
//  SubscribeViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubSettViewController.h"
#import "ManagementViewController.h"
#import "UIImage+RTTint.h"
#import "VehicleDetailViewController.h"
#import "LowerPriceVehicleBigCellTableViewCell.h"
#import "BizUser.h"
#import "HCVehicleCell.h"
#import "MJRefresh.h"
#import "FVCustomAlertView.h"
#import "SubscribeRquest.h"
#import "DataFilter.h"
#import "MyVehicle.h"
#import "BizCity.h"
#import "UIView+ITTAdditions.h"
#import "BizVisitRecord.h"
#import "HCNodataView.h"
#import "HCVehicleCell.h"
#import "DataFilter.h"
#import "HCDropdownListView.h"
#import "SDImageCache.h"
#import "ViewSubCri.h"
#import "UIView+ITTAdditions.h"
#import "UiTapView.h"
#import "PageView.h"
#import "NavView.h"

@interface SubscribeViewController ()<SubSettViewControllerDelegate,HCDropdowListViewDataDelegate,managerSubDelegate,UiTapViewDeleate,ViewSubCriDelegate>

//@property (nonatomic,strong)ViewSubCri *viewSubCri;
@property (nonatomic,strong)DataFilter *dataFilter;
@property (nonatomic,strong)UiTapView *tapView;
@property (nonatomic,strong)ViewSubCri *nologinView;
@property (weak, nonatomic) IBOutlet UILabel *allCar;
@property (strong, nonatomic)  UIView *coatView;
@property (weak, nonatomic) IBOutlet UIView *gusetView;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carAdName;
@property (weak, nonatomic) IBOutlet UILabel *carStar;
@property (nonatomic,strong)NavView *liView;
//@property (weak, nonatomic) IBOutlet UILabel *carmanualAutomatic;
@property (weak, nonatomic) IBOutlet UIImageView *numberIamge;
@property (nonatomic)NSInteger subId;
@property (nonatomic)CityElem *selectedCity;
@property (nonatomic,strong)NSArray *arrayAllSubscribe;
@property (nonatomic,strong)UIImageView *noClassid;
@property (nonatomic,strong)UIView *noDataView;
@property (nonatomic,strong)NSArray *vehicleData;
@property (nonatomic,strong)NSArray *orderData;
@property (nonatomic,strong)NSMutableDictionary *query;
@property (nonatomic,strong)UITapGestureRecognizer* singleRecognizer;
@property (nonatomic,strong)UIButton *sortBtn;
@property (strong, nonatomic) UIView *noVehicleDataView;
@property (strong, nonatomic) UIView *networkErrorView;
@property (nonatomic, strong) UIView *mNoView;
//@property (nonatomic,strong)PageView *pageView;
//@property (nonatomic)NSInteger page;
@end

@implementation SubscribeViewController

static int number;

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self addNSNotificationObserver];
    if (!self.dataFilter) {
        self.dataFilter =[[DataFilter alloc]init];
    }
    if (!_query) {
        _query = [[NSMutableDictionary alloc]init];
     }
    self.orderData = [SortCond getSortCondData];
    [self coatVIew];
    self.nologinView = [[ViewSubCri alloc] initWithFrame:CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    self.nologinView.delegate = self;
    _isShowTab = NO;
    [self viewData];
    [self setupRefresh:_mSubTableView];
    [self.mSubTableView headerBeginRefreshing];
    [self creatBackButton];

    [self.mSubTableView reloadData];
    //[self createSortBtn];
    //[self createSortView];
    [self noVehicleView];
    [self mNoView];
}
- (void)addNSNotificationObserver{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:@"logoutSuccess" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Switch:) name:@"Switch" object:nil];
}

//- (void)loginSuccess:(NSNotification *)loginNoti{
//    [self.mSubTableView headerBeginRefreshing];
//    [self.mSubTableView reloadData];
//    self.sortBtn.hidden = NO;
//    [self.nologinView removeFromSuperview];
//}
//- (void)logoutSuccess:(NSNotification*)logoutNoti{
//    [self.view addSubview:self.nologinView];
//}
- (void)LoginControllerJump{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"select"];
    [self.tabBarController setSelectedIndex:1];
    [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"selctcontroller"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)coatVIew
{
    _coatView = [UIView viewbackAddSuperVIew:CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64)];
    _tapView = [[UiTapView alloc]initWithFrame:_coatView];
    _tapView.tapdelegate = self;
}


//下面先拿出来等着封装
- (void)mNoview
{
    self.mNoView = [HCNodataView getWebNetWorkErrorView:self.mNoView];
    self.mNoView.frame = CGRectMake(0, -50, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
    self.mNoView.backgroundColor = [UIColor whiteColor];
    self.mNoView.hidden = YES;
    [self.view addSubview:self.mNoView];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mNoView addGestureRecognizer:bgTap];
    
}

- (void)noVehicleView
{
//    self.noVehicleDataView = [HCNodataView createNoVehicleView:self.noVehicleDataView target:self action1:@selector(showSubAllVehicle:) action2:@selector(visitBangmaiPage:) fram:CGRectMake(0, 0, 0, 0) text:@"点全部好车，进行上新提醒" andText:@"查看全部二手车" ishow:NO];
    self.noVehicleDataView = [HCNodataView createEmptySubVehicelview:self.noVehicleDataView fram:CGRectMake(0, 108, 0, HCSCREEN_HEIGHT-157)];
    self.noVehicleDataView.hidden = YES;
    [self.view addSubview:self.noVehicleDataView];

}


- (void)bgTappedAction:(UIGestureRecognizer *)gest
{
    [self AllRequest];
    [self updateVehicleSource];
}


- (void)Switch:(NSNotification *)not
{
    [self hiddar];
}
- (void)sortStatistic:(SortCond*)sortCond{
    if (sortCond.sortType == SortTypeDefault) {
        [HCAnalysis HCUserClick:@"SubSortTypeDefault"];
    }else if (sortCond.sortType == SortTypeAgeAsc){
        [HCAnalysis HCUserClick:@"SubSortTypeAgeAsc"];
    }else if (sortCond.sortType == SortTypeMilesAsc){
        [HCAnalysis HCUserClick:@"SubSortTypeMilesAsc"];
    }else if (sortCond.sortType == SortTypePriceAsc){
        [HCAnalysis HCUserClick:@"SubSortTypePriceAsc"];
    }
}

- (void) hcDropDownListViewDidSelectRowAtIndexPath:(NSInteger)idx fromViewTag:(NSInteger)tagId conditon:(id)cond
{
    _isShowTab = NO;
   //  NSString *titleStr = ((SortCond *)cond).sortDesc;
     [self.dataFilter setSortCond:(SortCond *)cond];
     [self listPageUpdateByFilter:self.dataFilter];
}

- (void)listPageUpdateByFilter:(DataFilter *)filter
{
     [self refreshData:filter];
}

-(void)refreshData:(DataFilter *)dataFilter
{
    if (self.noDataView.superview == self.view)
    {
        [self.noDataView removeFromSuperview];
    }
    self.dataFilter = dataFilter;
    [self.mSubTableView headerBeginRefreshing];
}

#pragma mark 刷新控件
-(NSMutableDictionary*)setSortType
{
    NSMutableDictionary *sortDic = [[NSMutableDictionary alloc]init];
    if (self.dataFilter.sortCond==nil||self.dataFilter.sortCond.sortType==SortTypeDefault)
    {
        [sortDic setObject:@1 forKey:@"desc"];
        [sortDic setObject:@"refresh_time" forKey:@"order_by"];
    }
    if (self.dataFilter.sortCond&&[self.dataFilter.sortCond isValid])
    {
        switch (self.dataFilter.sortCond.sortType)
         {
            case SortTypeAgeAsc:
                [sortDic setObject:@1 forKey:@"desc"];
                [sortDic setObject:@"register_time" forKey:@"order_by"];
                break;
            case SortTypeMilesAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"miles" forKey:@"order_by"];
                break;
            case SortTypePriceAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"seller_price" forKey:@"order_by"];
                break;
            default:
                break;
        }
    }
    return sortDic;
}

- (void)listPageUpdateByFilter
{
    if (_isShowTab == NO) {
        _isShowTab = YES;
    }else{
        _isShowTab = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self AllRequest];
  //  _pageView = [[PageView alloc]initWithFrameRect:CGRectMake(HCSCREEN_WIDTH/2.34, HCSCREEN_HEIGHT-40, HCSCREEN_WIDTH-(HCSCREEN_WIDTH/2.34*2), 20)];
    self.navigationController.navigationBar.hidden = NO;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"subNum"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    SUBSCRI;SUBSCRISHO;
    [self stactHiddar];
}

- (void)headerRefreshing
{
    [self updateVehicleSource];
}

- (void)footerRefreshing
{
    [self getHistoryVehicleSource];
}

#pragma mark - Request
- (void)getHistoryVehicleSource
{
    NSMutableDictionary *dict = [self setSortType];

    [SubscribeRquest append:self.vehicleData tpye:dict sub:_subId city:_selectedCity.cityId byfinish:^(NSArray *ret, NSInteger code,NSInteger numberPage) {

        if (code != 0 && code != -2) {

            [self showMsg:@"网络不给力" type:FVAlertTypeError];
        } else if (code == 0) {
            self.vehicleData = ret;
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
       //  [_pageView timeDuration:2 superView:self.view pageNumber:_page-1];
        [self.mSubTableView reloadData];
       [self.mSubTableView footerEndRefreshing];
    }];
}

- (void)updateVehicleSource
{
    if ([[HCLogin standLog]isLog]) {
        [self CarNumberRequestAll:_subId];
    }
    
    NSMutableDictionary *dict = [self setSortType];
    [SubscribeRquest getSubscriber:1 tpye:dict sub:_subId city:_selectedCity.cityId SourceInformation:^(NSArray *ret , NSInteger code,NSInteger allCount) {
        if (code != 0 && code != -2){
             [self showMsg:@"网络不给力" type:FVAlertTypeError];
          //  self.vehicleData = [MyOrderDetail getVehicleSourceList];
            if(self.vehicleData.count == 0){
                 self.mNoView.hidden = NO;
            }
        }else if (code == 0) {
            self.vehicleData = ret;
              self.mNoView.hidden = YES;
            if (self.vehicleData.count == 0)
            {
               self.noVehicleDataView.hidden = NO;
            }else{
                self.noVehicleDataView.hidden = YES;
            }
        }
        //[self count:allCount];
       //  [_pageView timeDuration:1 superView:self.view pageNumber:_page-1];
        [self.mSubTableView headerEndRefreshing];
        [self.mSubTableView reloadData];
    }];

}

//- (void)count:(NSInteger)count
//{
//    BOOL isMultipleOfTen = !(count % 10);
//    if (count-10 <= 0) {
//        _page = 1;
//    }else if(isMultipleOfTen== NO){
//        _page = (int)count/10+1;
//    }else if(isMultipleOfTen== YES){
//        _page = (int)count/10;
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_detailVC.view removeFromSuperview];
}

- (void)CarNumberRequestAll:(NSInteger)subid
{
    [SubscribeRquest getTimeCar:0 city:[BizCity getCurCity].cityId subid:subid
             SourceInformation:^(int num, NSInteger code) {
                 if (code == 0) {
                     number = num;
//          _mSortView.numberLabel.text =[NSString stringWithFormat:@"%d辆订阅的好车",number];
                 }else{
                     number = 0;
            }
    }];
}

#pragma mark - ViewData
- (void)viewData
{
    _selectedCity = [BizCity getCurCity];
    _detailVC = [[SubSettViewController alloc] init];
    _mSubTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _gusetView.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64-40)];
    _mSubTableView.tableFooterView = [[UIView alloc]init];
    _mSubTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _mSubTableView.dataSource = self;
    _mSubTableView.delegate = self;
    [self.view addSubview:_mSubTableView];
    _singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(consultselet:)];
    _singleRecognizer.numberOfTapsRequired = 1;
    _gusetView.backgroundColor = MTABLEBACK;
    [_gusetView addGestureRecognizer:_singleRecognizer];
    self.liView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    self.liView.labelText.text = @"上新提醒";
    [self.view addSubview:self.liView];
    [self initNavigationBar];
}

#pragma mark - mView
-(void)initNavigationBar
{
    self.noClassid = [[UIImageView alloc]initWithFrame:CGRectMake(19, 8, 25, 25)];
    [self.gusetView addSubview:self.noClassid];
    self.noClassid.hidden = YES;    
}

- (void)tapGestureView
{
    [self hiddar];
}

- (void)hiddar
{
    if (_detailVC) {
        [self stactHiddar];
    }
}

- (IBAction)consultselet:(id)sender
{
    [self.view addSubview:_coatView];
    _isShowTab = NO;
    CGFloat  height = 54*_arrayAllSubscribe.count+49+44;
    _detailVC.view.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, height);
     _detailVC.arrayData = _arrayAllSubscribe;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_detailVC.view];
    _coatView.hidden = NO;
    _detailVC.delegate = self;
    [UIView animateWithDuration:0.2 animations:^{
         _detailVC.view.frame =CGRectMake(0, HCSCREEN_HEIGHT-height,HCSCREEN_WIDTH, height);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark Requerst
- (void)AllRequest
{
    [SubscribeRquest getSubscriber:2 tpye:0 sub:0 city:0 SourceInformation:^(NSArray *ret, NSInteger code,NSInteger number) {
        if (code == -1)
        {
             _arrayAllSubscribe = [MyVehicle getMyVehicleList];
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
        } else if (code == 0) {
            if (ret.count>0) {
                [self.nologinView removeFromSuperview];
                _gusetView.hidden = NO;
            }else{
                [self.view addSubview:self.nologinView];
            }
        _arrayAllSubscribe = ret;
        _detailVC.arrayData = _arrayAllSubscribe;
        [_detailVC.mTableView reloadData];
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
        [self number];
    }];
}

- (void)pushView
{
    [self stactHiddar];
    ManagementViewController *managerment = [[ManagementViewController alloc]init];
    managerment.mArray = _arrayAllSubscribe;
    managerment.delegate = self;
    managerment.title = @"上新提醒管理";
    [self.navigationController pushViewController:managerment animated:YES];
}

- (void)deleteSuccess
{
    [self SelectCell:nil];
}

- (void)stactHiddar
{
    _coatView.hidden = YES;
    [_detailVC.view removeFromSuperview];
}

- (void)pushViewController:(id)ID
{
    [self pushView];
}

- (void)setBOOL:(BOOL)isShow
{
    _carImageView.hidden = isShow;
    _carAdName.hidden = isShow;
    _carStar.hidden = isShow;
}

- (void)setImageTitle:(NSMutableArray *)array
{
    _carImageView.image = [array HCObjectAtIndex:1];
    _carAdName.text = [array HCObjectAtIndex:0];
    _carAdName.textColor = UIColorFromRGBValue(0x424242);
    if ([_carAdName.text hasPrefix:@"品牌不限"]) {
        _carImageView.hidden = YES;
        _noClassid.hidden = NO;
        _noClassid.image =[array HCObjectAtIndex:1];
    }else{
        _carImageView.hidden = NO;
        _noClassid.hidden = YES;
    }
    _carStar.textColor = UIColorFromRGBValue(0x424242);
    _carStar.text = [array HCObjectAtIndex:2];
    _subId = [[array HCObjectAtIndex:3] integerValue];
}

- (void)SelectCell:(NSMutableArray *)array
{
    [self stactHiddar];
    if (array.count == 0) {
        _allCar.hidden = NO;
        _numberIamge.hidden = NO;
        self.noClassid.hidden = YES;
        [self setBOOL:YES];
        _vehicleData = @[];
        _subId = 0;
    }else{
        [self setBOOL:NO];
        _allCar.hidden = YES;
        _carImageView.hidden = NO;
        _numberIamge.hidden = YES;
        [self setImageTitle:array];
    }
    [self updateVehicleSource];
    [self.mSubTableView setContentOffset:CGPointMake(0, 0) animated:NO];
}

#pragma mark - AllCarBtn
//- (void) showSubAllVehicle:(id)btn
//{
//    NSNotification *notification =[NSNotification notificationWithName:@"resetFilter" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//    [self pushToHCSectWidth:0];
//    [self.tabBarController setSelectedIndex:1];
//}


//这个放到基类里面
- (void) visitBangmaiPage:(id)btn
{
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    nextViewController.title = @"帮买服务";
    nextViewController.url = [NSString stringWithFormat:BANGMAI_URL, (long)[BizUser getUserId]];
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

-(void)consult:(id)sender
{
    [self pushView];
}


#pragma mark - UITableViewDataSource And UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HC_VEHICLE_LIST_ROW_HEIGHT+5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _vehicleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"hc_vehicle_cell";
    HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Vehicle *vehicle;
    if (self.vehicleData.count!=0) {
        vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    }
    if (!cell) {
        cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return  cell;
    }
    [cell setVehicleData:vehicle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self nav:YES]) {
        [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    }
     _isShowTab = NO;
    [HCAnalysis HCUserClick:@"sublist_click"];
    Vehicle *vehicle;
    if (indexPath.row<self.vehicleData.count) {
      vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self pushToVehicelDetailandVehic:vehicle hadCom:YES vehicleChannel:@"上新提醒"];
}

- (void)number
{
    if (_arrayAllSubscribe.count == 0) {
        _gusetView.hidden = YES;
        [_mSubTableView reloadData];
    }else if (_arrayAllSubscribe.count == 1) {
        [self name:@"ImageOne" int:1];
    }else if (_arrayAllSubscribe.count == 2){
        [self name:@"ImageTwo" int:2];
    }else if (_arrayAllSubscribe.count == 3){
        [self name:@"ImageThree" int:3];
    }else if (_arrayAllSubscribe.count == 4){
        [self name:@"ImageFore" int:4];
    }else if (_arrayAllSubscribe.count == 5){
        [self name:@"ImageFree" int:5];
    }
}

- (void)name:(NSString *)ImageName int:(int)number
{
    _numberIamge.image = [UIImage imageNamed:ImageName];
    _allCar.textColor = UIColorFromRGBValue(0x424242);
    _allCar.text = [NSString stringWithFormat:@"全部%d个上新提醒",number];
}

static float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;

}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    if (lastContentOffset < scrollView.contentOffset.y) {
//        [UIView animateWithDuration:0.2 animations:^{
//           // _mSubTableView.frame = CGRectMake(0, 20, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-20);
//            self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//            self.sortView.frame = CGRectMake(HCSCREEN_WIDTH, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, 0, 0);
//            [self.sortView resetTableViewFrame:YES];
//           // [super.navigationController setNavigationBarHidden:YES animated:TRUE];
//            //self.tabBarController.tabBar.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, self.tabBarController.tabBar.height);
//        }completion:^(BOOL finished) {
//            self.sortBtn.hidden = YES;
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            self.sortBtn.hidden = NO;
//            //_mSubTableView.frame = CGRectMake(0, 104, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-49);
//        // [super.navigationController setNavigationBarHidden:NO animated:TRUE];
//         //   self.tabBarController.tabBar.frame = CGRectMake(0, HCSCREEN_HEIGHT-self.tabBarController.tabBar.height, HCSCREEN_WIDTH, self.tabBarController.tabBar.height);
//              self.sortBtn.frame = CGRectMake(HCSCREEN_WIDTH-15-HCSCREEN_WIDTH*0.14, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
//        }];
//    }
//}

@end
