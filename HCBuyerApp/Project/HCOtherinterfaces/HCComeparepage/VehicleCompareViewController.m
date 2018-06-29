//
//  VehicleCompareViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/7/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehicleCompareViewController.h"
#import "ComparedVehicleCellContentView.h"
#import "ComparedDetailViewController.h"
#import "VehicleDetailViewController.h"
#import "BizVehicleSourceCompare.h"
#import "ComparedVehicleCell.h"
#import "FVCustomAlertView.h"
#import "BizVisitRecord.h"
#import "UIImage+RTTint.h"
#import "VehicleDetail.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "BizUser.h"

@interface VehicleCompareViewController ()<UIGestureRecognizerDelegate,ComapredVehicleCellSelectedDelegate>

#pragma mark - Attribute
@property (strong, nonatomic) ComparedVehicleCellContentView *mainVehicleView;
@property (strong, nonatomic) UITableView * mComparedVehicleTableView;
@property (strong, nonatomic) UIButton    * mSelectBtn;
@property (strong, nonatomic) Vehicle     * mSelectedVehicle;
@property (strong, nonatomic) UILabel     * mComparedTitle;
@property (strong, nonatomic) NSArray     * mVehicleData;

@end

@implementation VehicleCompareViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self creatBackButton];
    [self initView];
    [self setupRefresh];
    [self updateVehicleSource];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"comparePage"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"comparePage"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    self.mVehicleData = [[NSArray alloc] init];
    self.mSelectedVehicle = nil;
    [self.mainVehicleView setBackgroundColor:ColorWithRGB(236, 239, 241)];
    [self.mainVehicleView setSelectedBtnSelectedAndDisable];
    [self.view addSubview:self.mainVehicleView];
    self.mComparedTitle = [[UILabel alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH * 0.13f, self.mainVehicleView.top + self.mainVehicleView.height, HCSCREEN_WIDTH, 40)];
    [self.mComparedTitle setText:@"我看过的车"];
    [self.mComparedTitle setFont:[UIFont systemFontOfSize:13]];
    [self.mComparedTitle setTextColor:ColorWithRGB(117, 117, 117)];
    [self.view addSubview:self.mComparedTitle];
    self.mComparedVehicleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.mComparedTitle.top + self.mComparedTitle.height, HCSCREEN_WIDTH, HCSCREEN_HEIGHT - 64 - self.mainVehicleView.height - self.mComparedTitle.height- 45)];
    self.mComparedVehicleTableView.delegate = self;
    self.mComparedVehicleTableView.dataSource = self;
    [self.view addSubview:self.mComparedVehicleTableView];
    self.mComparedVehicleTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.mSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mSelectBtn.frame = CGRectMake(0, HCSCREEN_HEIGHT - 64 - 45, HCSCREEN_WIDTH, 45);
    [self.mSelectBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.mSelectBtn addTarget:self action:@selector(compare:) forControlEvents:UIControlEventTouchUpInside];
    [self setSelectBtnDefault];
    [self.view addSubview:self.mSelectBtn];
}

#pragma mark 刷新控件
#pragma mark - Access to historical data
- (void)getHistoryVehicleSource
{
    [BizVisitRecord appendHistoryRecordForlist:self.mVehicleData byfinish:^(NSArray *ret, NSInteger code) {
        if (code == -1) {
            [self showMsg:@"网络不给力" type:FVAlertTypeError];
        } else if (code == 0) {
            self.mVehicleData = ret;
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }
        [self.mComparedVehicleTableView footerEndRefreshing];
        [self.mComparedVehicleTableView reloadData];
        
    }];
}

#pragma mark - PrivateVariable

- (void)setSelectBtnDefault
{
    [self.mSelectBtn setTitle:@"请再选择一辆车进行对比" forState:UIControlStateNormal];
    [self.mSelectBtn setTitleColor:ColorWithRGB(117, 117, 117) forState:UIControlStateNormal];
    [self.mSelectBtn setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.95]];
}

- (void)setSelectBtnReady
{
    [self.mSelectBtn setTitle:@"对比" forState:UIControlStateNormal];
    [self.mSelectBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.mSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mSelectBtn setBackgroundColor:PRICE_STY_CORLOR];
}

- (void)compare:(id)sender
{
    if (self.mSelectedVehicle) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BizVehicleSourceCompare getComparedResultBetween:[self.mainVehicleView getVehicle].vehicle_id andId2:self.mSelectedVehicle.vehicle_id finish:^(NSArray *ret) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (ret != nil && [ret count] == 2) {
                VehicleDetail *lh = [[VehicleDetail alloc] initWithVehicleData:[ret HCObjectAtIndex:0]];
                VehicleDetail *rh = [[VehicleDetail alloc] initWithVehicleData:[ret HCObjectAtIndex:1]];
            if (lh.vehicleSourceId != [self.mainVehicleView getVehicle].vehicle_id) {
                    VehicleDetail *tmp = lh;
                    lh = rh;
                    rh = tmp;
                }
                ComparedDetailViewController *nextViewController = [[ComparedDetailViewController alloc]init];
                nextViewController.title = @"对比详情";
                nextViewController.hidesBottomBarWhenPushed = YES;
                [nextViewController setComparedDataBetween:lh and:rh];
                [self.navigationController pushViewController:nextViewController animated:YES];
            }else{
                [self showMsg:@"获取失败!" type:FVAlertTypeError];
            }
        }];
    }
}

-(ComparedVehicleCellContentView *)mainVehicleView
{
    if (!_mainVehicleView) {
        _mainVehicleView = [[ComparedVehicleCellContentView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:nil];
    }
    return _mainVehicleView;
}

- (void)setupRefresh
{
    [self.mComparedVehicleTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    self.mComparedVehicleTableView.footerPullToRefreshText = @"上拉加载更多数据";
    self.mComparedVehicleTableView.footerReleaseToRefreshText = @"松开加载更多数据";
    self.mComparedVehicleTableView.footerRefreshingText = @"加载中,请稍候";
}

- (void)footerRefreshing
{
    [self getHistoryVehicleSource];
}

- (void)setMainVehicle:(Vehicle *)vehicle
{
    [self.mainVehicleView setVehicleData:vehicle];
}

- (void)selectedVehicle:(Vehicle *)vehicle
{
    if (!self.mSelectedVehicle || self.mSelectedVehicle.vehicle_id != vehicle.vehicle_id) {
        for (Vehicle *v in self.mVehicleData) {
            if (self.mSelectedVehicle && v.vehicle_id == self.mSelectedVehicle.vehicle_id) {
                v.isSelectedForCompare = NO;
            }
            if (v.vehicle_id == vehicle.vehicle_id) {
                v.isSelectedForCompare = YES;
            }
        }
        self.mSelectedVehicle = vehicle;
        [self setSelectBtnReady];
        [self.mComparedVehicleTableView reloadData];
    }
}

- (void)unselectVehicle:(Vehicle *)vehicle
{
    if (self.mSelectedVehicle && self.mSelectedVehicle.vehicle_id == vehicle.vehicle_id) {
        for (Vehicle *v in self.mVehicleData) {
            if (v.vehicle_id == self.mSelectedVehicle.vehicle_id) {
                v.isSelectedForCompare = NO;
            }
        }
        self.mSelectedVehicle = nil;
        [self setSelectBtnDefault];
        [self.mComparedVehicleTableView reloadData];
    }
}

#pragma mark - update car source information
- (void)updateVehicleSource
{
    [BizVisitRecord getNewVisitRecord:^(NSArray *ret, NSInteger code) {
        if (code == -1) {
            [self showMsg:@"网络不给力" type:FVAlertTypeError];
        } else if (code == 0) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (Vehicle *vehicle in ret) {
                if (vehicle.vehicle_id != [self.mainVehicleView getVehicle].vehicle_id) {
                    [array addObject:vehicle];
                }
            }
            self.mVehicleData = array;
        }
        [self.mComparedVehicleTableView reloadData];
    }];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HC_VEHICLE_LIST_ROW_HEIGHT+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComparedVehicleCell *vehicleCell = (ComparedVehicleCell *)[tableView cellForRowAtIndexPath:indexPath];
    Vehicle *vehicle = [vehicleCell getVehicle];
    [self pushToVehicelDetailandVehic:vehicle hadCom:YES vehicleChannel:@"对比"];
}

#pragma mark -- UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mVehicleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"hc_compared_vehicle";
    ComparedVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Vehicle *vehicle = [self.mVehicleData HCObjectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[ComparedVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
        cell.comparedContentView.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return  cell;
    }
    [cell setVehicleData:vehicle];
    return cell;
}


@end
