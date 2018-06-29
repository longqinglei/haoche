//
//  UserVisitRecordViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/6/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "UserVisitRecordViewController.h"
#import "VehicleDetailViewController.h"
#import "BizUser.h"
#import "HCVehicleCell.h"
#import "BizVisitRecord.h"
#import "UIImage+RTTint.h"
#import "NavView.h"
#import "HCNodataView.h"
#import "SortView.h"



@interface UserVisitRecordViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *vehicleData;
@property (strong, nonatomic) UIView *mNoNetView;
@property (strong, nonatomic) UIView *mRecordView;
@property (strong, nonatomic) SortView *mSortView;
@property (strong, nonatomic) NavView *liView;
#pragma mark - biaoji
@property (nonatomic) int number;
@property (nonatomic) BOOL isShowTab;



@end

@implementation UserVisitRecordViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {self.edgesForExtendedLayout = UIRectEdgeNone;}
    // self.navigationController.hidesBarsOnSwipe = YES;
    [self creatBackButton];
    [self tableView];
    [self navView];
    [self requestNumber];
    [self noDataShowView];
    [self Nodata];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
   
    [HCAnalysis controllerBegin:@"userHistoryPage"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"userHistoryPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - navViewtext
- (void)navView
{
    self.liView = [[NavView alloc]initWithFrame:CGRectMake(0, -64, HCSCREEN_WIDTH, 64)];
    self.liView.labelText.text = @"浏览记录";
    //self.title =  @"浏览记录";
    [self.view addSubview:self.liView];
}


#pragma mark - NoDataShowView
- (void)noDataShowView
{
    self.mNoNetView = [HCNodataView getNetwordErrorViewWith:@"您的网络不太给力哦~" view:self.mNoNetView];
    self.mNoNetView.hidden = YES;
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRefresh:)];
    [self.mNoNetView addGestureRecognizer:bgTap];
    [self.view addSubview:self.mNoNetView];
}

#pragma mark - NoData
- (void)Nodata
{
    self.mRecordView = [HCNodataView getNetword:@"抱歉!暂无浏览记录" view:self.mRecordView];
    self.mRecordView.hidden = YES;
    [self.view addSubview:self.mRecordView];
}

- (void)tableView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setupRefresh:_mTableView];
    [self.mTableView headerBeginRefreshing];
}

- (void)gestureRefresh:(UIGestureRecognizer *)gest
{
    [self updateVehicleSource];
    [self requestNumber];
}

- (void)headerRefreshing
{
    [self updateVehicleSource];
    [self requestNumber];
}

- (void)footerRefreshing
{
    [self getHistoryVehicleSource];
}

#pragma mark - Request
- (void)updateVehicleSource
{
    [BizVisitRecord getNewVisitRecord:^(NSArray *ret, NSInteger code)
     {
        if (code == -1) {

            self.mNoNetView.hidden = NO;

        } else if (code == 0) {
            self.mNoNetView.hidden = YES;
            self.vehicleData = ret;
            if ([self.vehicleData count] == 0) {
                self.mRecordView.hidden = NO;
            }else{
                self.mRecordView.hidden = YES;
            }
        }
    [self.mTableView headerEndRefreshing];
        [self.mTableView reloadData];
    }];
}

- (void)getHistoryVehicleSource
{
    [BizVisitRecord appendHistoryRecordForlist:self.vehicleData byfinish:^(NSArray *ret, NSInteger code)
     {
        if (code == -1) {
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
        } else if (code == 0) {
            self.vehicleData = ret;
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
        [self.mTableView footerEndRefreshing];
        [self.mTableView reloadData];
    }];
}

- (void)requestNumber
{

   [BizVisitRecord getOrderRecord:^(int num, NSInteger code)
    {
       if (code != 0) {
        _number = 0;
       }else{
        _number = num;
       }
   }];

    [_mTableView reloadData];

}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_number==0){
        return [[UIView alloc]init];;
    }else{
        UIView *mViewHeader= [[UIView alloc]init];
        mViewHeader.backgroundColor = [UIColor whiteColor];
        if (!_mSortView) {
            _mSortView = [[SortView alloc] initWithframeRec:CGRectMake(0, 0, HCSCREEN_WIDTH, 44)];
        }
        _mSortView.numberLabel.text = [NSString stringWithFormat:@"%d辆看过的车",_number];
        [_mSortView isHiddenYes];
        [mViewHeader addSubview:_mSortView];
        return mViewHeader;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HC_VEHICLE_LIST_ROW_HEIGHT+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [HCAnalysis HCUserClick:@"historylist_click"];
    HCVehicleCell *vehicleCell = (HCVehicleCell *)[tableView cellForRowAtIndexPath:indexPath];
    Vehicle *vehicle = [vehicleCell getVehicle];
    self.navigationController.title = nil;
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    nextViewController.source_id = vehicle.vehicle_id ;
    nextViewController.VehicleChannel = @"浏览记录";
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.url = [NSString stringWithFormat:DETAIL_URL, (long)vehicle.vehicle_id,(long)[BizUser getUserId],[BizUser getUserType]];
    [nextViewController setVehicleCompareBtn];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark -- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vehicleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"hc_vehicle_cell";
    HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return  cell;
    }
    [cell setVehicleData:vehicle];
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}





@end
