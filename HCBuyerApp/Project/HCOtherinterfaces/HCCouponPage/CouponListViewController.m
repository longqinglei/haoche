//
//  CouponListViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponListViewControllerCell.h"
#import "BizCoupon.h"
#import "NavView.h"
#import "Coupon.h"
#import "HCNodataView.h"
#import "WebUserViewController.h"
#import "MyCouponVehicle.h"
#import "UIAlertView+ITTAdditions.h"

@interface CouponListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UITextField *mTextField;
@property (weak, nonatomic) IBOutlet UILabel  *labelCoupon;
@property (weak, nonatomic) IBOutlet UIButton *exchange;

@property (nonatomic,strong)NSMutableArray *mArrayData;
@property (nonatomic,strong)NSMutableArray *mIndexPaths;
@property (nonatomic,strong)NavView  *mNavView;


@property (nonatomic)BOOL isNumber;

@end
@implementation CouponListViewController

#define MCOUPON @"我的优惠券"
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self data];
    [self DataView];
    [self headerRefreshing];
    [self DataView];
    [self creatBackButton];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"couponListPage"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"couponNum"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    [HCAnalysis controllerBegin:@"couponListPage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public
- (void)DataView
{
    if (_mArrayData == nil)
    {
        _mArrayData = [[NSMutableArray alloc]init];
    }
    _isNumber = NO;
    _mTextField.delegate = self;
    _mTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_exchange.layer setCornerRadius:5.0];
    [_exchange.layer setMasksToBounds:YES];
    [_exchange.layer setBorderWidth:0.1];
    _exchange.backgroundColor = PRICE_STY_CORLOR;
    _exchange.backgroundColor = [UIColor colorWithRed:0.88f green:0.00f blue:0.00f alpha:1.00f];
    self.mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    _mNavView.labelText.text = MCOUPON;
    self.title = MCOUPON;
    [self.view addSubview:_mNavView];
}

- (void)data
{
    if (_mIndexPaths == nil)
    {
        _mIndexPaths = [[NSMutableArray alloc] init];
    }
    _mTableView.tableFooterView = [[UIView alloc]init];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.dataSource =self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = [UIColor colorWithRed:0.91f green:0.92f blue:0.92f alpha:1.00f];
    [self setupRefresh:self.mTableView];
}

- (void)headerRefreshing
{
    [self updateVehicleSource];
}

- (void)footerRefreshing
{
     [self getHistoryVehicleSource];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mArrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"CouponListViewControllerCell";
    Coupon *modelCoupon = [_mArrayData HCObjectAtIndex:indexPath.row];
    CouponListViewControllerCell *couponListCell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!couponListCell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CouponListViewControllerCell" owner:nil options:nil];
        couponListCell = [nibs lastObject];
        
        _mTableView.delaysContentTouches = NO;
    }
     [couponListCell initCellWith:modelCoupon];
    return couponListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *coupon = [_mArrayData HCObjectAtIndex:indexPath.row];
    WebUserViewController *userView = [[WebUserViewController alloc]init];
    userView.type = 1;
    userView.requestURL = coupon.url;
    [self.navigationController pushViewController:userView animated:YES];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   _labelCoupon.text = @"";
    return YES;
}

#pragma mark - Sender
- (IBAction)coupon:(UIButton *)sender
{
    [_mTextField resignFirstResponder];
    if(_mTextField.text.length == 0){
        _labelCoupon.text=self.mExchangeTitle;
    }else{
    [BizCoupon postNew:_mTextField.text show:^(NSString *esstre){
    if ([esstre length] < 20){
        _labelCoupon.text = esstre;
    }else{
        _labelCoupon.text = self.strNetwork;
    }
    } CouponRequest:^(NSArray *array, NSInteger code)
        {
        if (code != 0)
        {
            
        } else if (code == 0)
        {
            self.emptyView.hidden = YES;
            [self updateVehicleSource];
            _isNumber = YES;
        }
    }];
    }
}

- (IBAction)retureTextField:(id)sender
{
    [_mTextField resignFirstResponder];
}

#pragma mark - PrivateVariable
- (void)numberAnimation:(NSArray *)arrayRet
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_mArrayData insertObject:[arrayRet HCObjectAtIndex:0] atIndex:0];
    [_mIndexPaths addObject:indexPath];
    [self.mTableView insertRowsAtIndexPaths:_mIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.mTableView endUpdates];
    [self showMsg:@"兑换成功" type:FVAlertTypeDone];
    [self.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)dataViewloadt
{
    if (_mArrayData.count ==0) {
        [self reloadEmptyView];
    }
}

#pragma mark - RequestData
- (void)updateVehicleSource
{
    [BizCoupon getNewCouponRecord:0  get:^(NSArray *ret, NSInteger code) {
        if (code != 0) {
            _mArrayData = [NSMutableArray arrayWithArray:[MyCouponVehicle getVehicleSourceList]];
            [_mTableView reloadData];
             self.strName = @"请检查网络,重新下拉刷新!";
            [self dataViewloadt];
            
        } else if (code == 0) {
            if (_isNumber == YES) {
                [self numberAnimation:ret];
            }else{
                _mArrayData = [NSMutableArray arrayWithArray:ret];
                if(_mArrayData.count==0){
                    self.emptyView.hidden  = NO;
                    self.strName = @"抱歉,暂无优惠券!";
                    [self dataViewloadt];
                }else{
                   self.emptyView.hidden  = YES;
                }
            }
              [_mTableView reloadData];
        }
    }];
    [self.mTableView headerEndRefreshing];
     _isNumber = NO;
}

- (void)getHistoryVehicleSource
{
    [BizCoupon appendHistoryRecordForlist:1  get:_mArrayData byfinish:^(NSArray *ret, NSInteger code) {
        if (code == 0) {
            _mArrayData = [NSMutableArray arrayWithArray:ret];
        } else if (code == -2) {
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }else{
            _mArrayData = [NSMutableArray arrayWithArray:[MyCouponVehicle getVehicleSourceList]];
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
        } 

        [self.mTableView footerEndRefreshing];
        [self.mTableView reloadData];
        
    }];
    [self.mTableView footerEndRefreshing];
}



@end
