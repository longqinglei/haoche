//
//  RecommendLowerPriceVehicleViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/7/21.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "RecommendLowerPriceVehicleViewController.h"
#import "UserVisitRecordViewController.h"
#import "VehicleDetailViewController.h"
#import "BizUserRecommendVehicle.h"
#import "FVCustomAlertView.h"
#import "BizVisitRecord.h"
#import "UIImage+RTTint.h"
#import "HCVehicleCell.h"
#import "HCNodataView.h"
#import "MJRefresh.h"
#import "BizUser.h"
#import "NavView.h"
#import "Vehicle.h"

@interface RecommendLowerPriceVehicleViewController ()<UIGestureRecognizerDelegate>

#pragma mark - Attribute
@property (strong, nonatomic) UITableView * mTableView;
@property (strong, nonatomic) UIView      * mNoDataView;
@property (strong, nonatomic) NavView     * mTopView;
@end

@implementation RecommendLowerPriceVehicleViewController


#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self creatBackButton];
    [self DataView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"UserRecommendRecordPage"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HCAnalysis controllerBegin:@"UserRecommendRecordPage"];
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"recordNum"];

}

#pragma mark 刷新控件
- (void)DataView
{
    self.mTopView = [[NavView alloc]initWithFrame:CGRectMake(0, -64, HCSCREEN_HEIGHT, 64)];
    _mTopView.labelText.text = @"推荐";
    [self.view addSubview:self.mTopView];
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.mTableView reloadData];
    [self requestRecommendData];
}

#pragma mark - UpdateVehicleSourceInformation
- (void)requestRecommendData{
    [BizUserRecommendVehicle getNewVehicleSourceRemote:^(NSArray * vehicleArr, NSInteger code) {
        if (code!=0) {
             [self showMsg:@"网络不给力" type:FVAlertTypeError];
            [self.mTableView setBackgroundView:[HCNodataView getNetwordErrorViewWith:@"您的网络不给力哦~" view:_mNoDataView]];
            }else{
            self.mVehicleData = vehicleArr;
            
            [self.mTableView setBackgroundView:nil];
        }
        [self.mTableView reloadData];
    }];
}


#pragma mark - AccessToHistoricalData
//- (void)getHistoryVehicleSource
//{
//    [BizUserRecommendVehicle appendHistoryVehicleSource:self.mVehicleData byfinish:^(NSArray *ret, NSInteger code) {
//        if (code == -1) {
//            [self showMsg:@"网络不给力" type:FVAlertTypeError];
//            if (self.mVehicleData.count == 0){
//                [self.mTableView setBackgroundView:[HCNodataView getNetwordErrorViewWith:@"请检查网络,重新下拉刷新!" view:_mNoDataView]];}
//        }else if (code == 0) {
//            self.mVehicleData = ret;
//            if (self.mVehicleData.count == 0){
//                [self.mTableView setBackgroundView:[HCNodataView getNetwordErrorViewWith:@"抱歉!暂无低价车可推荐!" view:_mNoDataView]];}
//        }else if (code == -2) {
//            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
//        }
//        [self.mTableView footerEndRefreshing];
//        [self.mTableView reloadData];
//    }];
//}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return HC_VEHICLE_LIST_ROW_HEIGHT+5;
}

#pragma mark -- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mVehicleData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCVehicleCell *vehicleCell = (HCVehicleCell *)[tableView cellForRowAtIndexPath:indexPath];
    Vehicle *vehicle = [vehicleCell getVehicle];
    [HCAnalysis HCUserClick:@"RecommendVehicleClick"];
    [self pushToVehicelDetailandVehic:vehicle hadCom:YES vehicleChannel:@"推荐"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"hc_vehicle_cell";
    HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Vehicle *vehicle = [self.mVehicleData HCObjectAtIndex:indexPath.row];
    if (!cell) {
    cell = [[HCVehicleCell alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5)data:vehicle];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return  cell;
    }
    [cell setVehicleData:vehicle];
    return cell;
}


@end
