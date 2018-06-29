//
//  UseCouponsViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "UseCouponsViewController.h"
#import "UserCouponViewControllerCell.h"
#import "NavView.h"
#import "BizCoupon.h"
#import "UIAlertView+ITTAdditions.h"
#import "HCInfoView.h"
#import "WebUserViewController.h"
#import "MyCouponVehicle.h"
#import "HCNodataView.h"
#import "User.h"
#import "BizUser.h"
@interface UseCouponsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic,strong) NSMutableArray *mArrayData;

@property (nonatomic,strong) NavView  * mNavView;
@property (nonatomic,strong) NSString * mCoupon_id;
@property (nonatomic,strong) NSString * mTrans_id;
@property (nonatomic,strong) NSString * mStrUrl;

@property (nonatomic) BOOL color;
@property (nonatomic) NSInteger money;
@property (nonatomic) NSIndexPath * selectIndex;

@end

@implementation UseCouponsViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_mArrayData == nil) {
        _mArrayData = [[NSMutableArray alloc]init];
    }
    [self DataView];
    self.title = @"使用优惠券";
    _mNavView.frame = CGRectMake(0, -64, HCSCREEN_WIDTH, 64);
    [self.view addSubview:_mNavView];
    [self creatBackButton];
    [self setupRefresh:_mTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"useCouponPage"];
    [self updateVehicleSource];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"useCouponPage"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - PrivateVariable
- (void)DataView
{
     _color = NO;
    _mTableView.dataSource =self;
    _mTableView.delegate = self;
    _mTableView.tableFooterView = [[UIView alloc]init];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    [_userBtn.layer setCornerRadius:5.0];
    [_userBtn.layer setMasksToBounds:YES];
    [_userBtn.layer setBorderWidth:0.1];
}

- (IBAction)useDirection:(id)sender
{
    HCInfoView *info = [[HCInfoView alloc]initWithFrame:self.view.bounds type:kMyOrderStatusTwo];
    [self.view addSubview:info];
}

- (void)showColock
{
    if (_color == YES) {
        _userBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - RequestUpdateVehicleSource
- (void)updateVehicleSource
{
    [BizCoupon getNewCouponRecord:1  get:^(NSArray *ret, NSInteger code) {
        if (code != 0) {
                _mArrayData = [NSMutableArray arrayWithArray:[MyCouponVehicle getVehicleSourceList]];
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
            [_mTableView setBackgroundView:[HCNodataView getNetwordErrorViewWith:@"您的网不太给力哦~" view:nil]];
            }else if (code == 0) {
             _mArrayData = [NSMutableArray arrayWithArray:ret];
                if (_mArrayData.count == 0){
            [_mTableView setBackgroundView:[HCNodataView getNetwordErrorViewWith:@"抱歉,暂无优惠劵!" view:nil]];
                }
            }
        [self.mTableView headerEndRefreshing];
        [self.mTableView reloadData];
    }];
    [self.mTableView headerEndRefreshing];
}

- (void)getHistoryVehicleSource
{
    [BizCoupon appendHistoryRecordForlist:2  get:_mArrayData byfinish:^(NSArray *ret, NSInteger code) {
        if (code == 0) {
            _mArrayData = [NSMutableArray arrayWithArray:ret];
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type :FVAlertTypeDone];
        }else{
            _mArrayData = [NSMutableArray arrayWithArray:[MyCouponVehicle getVehicleSourceList]];
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
        }
        
        [self.mTableView reloadData];
        
    }];
    [self.mTableView footerEndRefreshing];
}

- (void)headerRefreshing
{
    [self updateVehicleSource];
}

- (void)footerRefreshing
{
     [self getHistoryVehicleSource];
}


#pragma mark - buttonWebRquest
- (IBAction)btnCilck:(UIButton *)sender
{
    WebUserViewController *userView = [[WebUserViewController alloc]init]; //IPHONE
    userView.type = 2;
    userView.requestURL = [NSString stringWithFormat:@"%@phone=%@&amount=%ld&coupon_id=%@&trans_id=%@",USERCOUPON,IPHONE,(long)_money,_mCoupon_id,_mTrans_id];
    [self.navigationController pushViewController:userView animated:YES];//连接
}

#pragma mark - UItableVeiwDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mArrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"UserCouponViewControllerCell";
    UserCouponViewControllerCell *useCouponCell = [tableView dequeueReusableCellWithIdentifier:strCell];
     Coupon *modelCoupon = [_mArrayData HCObjectAtIndex:indexPath.row];
    if (!useCouponCell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UserCouponViewControllerCell" owner:nil options:nil];
        useCouponCell = [nibs lastObject];
        _mTableView.delaysContentTouches = NO;
        
        if (self.selectIndex&&indexPath == self.selectIndex) {
            
            [useCouponCell setChecked:YES];
        }
    }
    useCouponCell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    [useCouponCell initCellWith:modelCoupon];
    return useCouponCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCouponViewControllerCell *cell = (UserCouponViewControllerCell*)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _mStrUrl = cell.strURL;
    _mTrans_id = [NSString stringWithFormat:@"%ld",(long)_typeId];
    _mCoupon_id = [NSString stringWithFormat:@"%@",cell.coupon_id];
    _money = [cell.priceLabel.text integerValue];
     NSArray *array = [tableView visibleCells];
    for (UserCouponViewControllerCell *cell in array) {
        [cell setChecked:NO];
    } [cell setChecked:YES];
    self.selectIndex = indexPath;
    _userBtn.backgroundColor = PRICE_STY_CORLOR;
    _color = YES;
    _showLabel.text = [NSString stringWithFormat:@"使用一张券%@元",cell.priceLabel.text];
    _showLabel.textColor = PRICE_STY_CORLOR;
}


@end
