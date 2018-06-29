//
//  MyHaveSeenTheCarViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyHaveSeenTheCarViewController.h"
#import "MyHaveSeenTheCarViewCell.h"
#import "MyHaveSeenVehicle.h"
#import "UseCouponsViewController.h"
#import "BizCoupon.h"
#import "NavView.h"
#import "User.h"
#import "HCNodataView.h"
#import "HCInfoView.h"
#import "HCMyHaveSeenVehicle.h"
#import "BizUser.h"
#import "VehicleDetailViewController.h"
@interface MyHaveSeenTheCarViewController ()
@property (nonatomic,strong)MyHaveSeenTheCarViewController *seenTheCark;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong)NSArray * mArrayData;
@property (nonatomic,strong)NavView * mNavView;
@property (nonatomic)NSInteger mId;

@end

@implementation MyHaveSeenTheCarViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self  dataView];
    [self  creatBackButton];
    [self setupRefresh:_mTableView];
    [_mTableView headerBeginRefreshing];
    _mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];_mNavView.labelText.text = @"预定";
    [self.view addSubview:_mNavView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"myOrderController"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"myhaveSeen"];
}

#pragma mark - Public
- (void)dataView
{
    _mTableView.dataSource = self;
    _mTableView.delegate  =self;
    _mTableView.tableFooterView = [[UIView alloc]init];
    if (self.mArrayData == nil) {
        self.mArrayData = [[NSArray alloc]init];
    }
}

- (void)headerRefreshing
{
    [self updateVehicleSource];
}

- (void)footerRefreshing
{
    [self getHistoryVehicleSource];
}

- (void)dataViewloadt
{
    if (_mArrayData.count ==0) {
        [self reloadEmptyView];
    }
    
}

#pragma Mark - Request
- (void)updateVehicleSource
{
    [BizCoupon postBuy:IPHONE CouponRequest:^(NSArray *array, NSInteger code) {
      if (code == 0) {
            self.mArrayData = array;
              self.strName = @"抱歉,暂无预约的车!";
            self.emptyView.logoImageName = @"error_data";
              [self dataViewloadt];
      }else{
          [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
          _mArrayData = [HCMyHaveSeenVehicle getVehicleSourceList];
          self.strName = @"您的网络不给力哦~,点击重新加载";
          self.emptyView.logoImageName = @"networkAnomaly";
          [self dataViewloadt];
      }
           [self.mTableView reloadData];
    }];
    [self.mTableView headerEndRefreshing];
}

- (void)getHistoryVehicleSource
{
    [BizCoupon postBuyList:IPHONE append:self.mArrayData CouponRequest:^(NSArray *ret, NSInteger code) {
        if (code == 0) {
            self.mArrayData = ret;
        }else if (code == -2){
            [self showMsg:@"已全部加载" type:FVAlertTypeDone];
        }else{
            _mArrayData = [HCMyHaveSeenVehicle getVehicleSourceList];
            [self showMsg:self.strNetworkTitle type:FVAlertTypeError];
            
        }
         [self.mTableView reloadData];
    }];
    [self.mTableView footerEndRefreshing];
   
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mArrayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeightAtIndexPath:indexPath];
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"MyHaveSeenTheCarViewCell";
    MyHaveSeenTheCarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    MyHaveSeenVehicle *model = [self.mArrayData HCObjectAtIndex:indexPath.row];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyHaveSeenTheCarViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [cell setWidth:HCSCREEN_WIDTH];
    [cell initCellWithRet:model];
    cell.useCoupon.tag = model.mStatus;
    cell.btnDetails.tag = model.mStatus;
    cell.userInteractionEnabled = YES;
    [cell.btnDetails addTarget:self action:@selector(btnDetails:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDetails.tag = indexPath.row;
    [cell.useCoupon addTarget:self action:@selector(showUseConpon:) forControlEvents:UIControlEventTouchUpInside];
    [cell.telephoneNum addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    [cell.servicePhone addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - PrivateVariable
- (CGFloat)getCellHeightAtIndexPath:(NSIndexPath*)index
{
    CGFloat height = 150+43+30+5;
    CGSize size= CGSizeMake(HCSCREEN_WIDTH - 50, 10000);
    CGSize size1= CGSizeMake(HCSCREEN_WIDTH - 20, 10000);
    CGSize size2,size3;
    
    MyHaveSeenVehicle *model = [self.mArrayData HCObjectAtIndex:index.row];
     CGRect tmpRect1 = [model.mPlace boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
     CGRect tmpRect2 = [model.mComment boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
    size2 = tmpRect1.size; //[model.mPlace sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    size3 = tmpRect2.size;//[model.mComment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size1 lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat infoHeight = size3.height+10;
    CGFloat addHeight = size2.height+28;
    
    if (model.mStatus == kMyOrderStatusOne) {
        height += 43 + addHeight+infoHeight;
    }else if (model.mStatus == kMyOrderStatusTwo){
        height += 43 + addHeight+infoHeight;
    }else if (model.mStatus == kMyOrderStatusThree){
        height += infoHeight;
    }else if (model.mStatus == kMyOrderStatusFour){
        height += 43 + addHeight+infoHeight;
    }else if (model.mStatus == kMyOrderStatusFive){
        height += 43+ infoHeight;
    }else if (model.mStatus == kMyOrderStatusSix){
        height += 43+ infoHeight;
    }else if(model.mStatus == kMyOrderStatusSeven){
        height += infoHeight;
    }else if (model.mStatus == kMyOrderStatusEight){
        height += infoHeight;
    }else if(model.mStatus == kMyOrderStatusNine){
        height += infoHeight;
    }
    return height;
}

#pragma mark - UIbutton
- (void)btnDetails:(UIButton *)btn
{
    UIView *view = [btn superview];
    MyHaveSeenTheCarViewCell *cell = (MyHaveSeenTheCarViewCell *)[view superview];
    NSIndexPath *indexPathAll = [self.mTableView indexPathForCell:cell];
    MyHaveSeenVehicle *subModel = [self.mArrayData HCObjectAtIndex:indexPathAll.row];
    [_mTableView deselectRowAtIndexPath:indexPathAll animated:YES];
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    nextViewController.source_id = [subModel.mVehicle_source_id integerValue] ;
    nextViewController.VehicleChannel = @"预定";
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.url = [NSString stringWithFormat:DETAIL_URL, (long)[subModel.mVehicle_source_id integerValue],(long)[BizUser getUserId],[BizUser getUserType]];
    [nextViewController setVehicleCompareBtn];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)showUseConpon:(UIButton *)sender
{
    MyHaveSeenTheCarViewCell * cell = (MyHaveSeenTheCarViewCell *)[[sender superview] superview];
    if (sender.tag == kMyOrderStatusSix) {
        UseCouponsViewController *viewController = [[UseCouponsViewController alloc]init];
        viewController.typeId = cell.mID;
        viewController.title = @"我的优惠劵";
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (sender.tag == kMyOrderStatusEight) {
        UseCouponsViewController *viewController = [[UseCouponsViewController alloc]init];
        viewController.title = @"我的优惠券";
        viewController.typeId = cell.mID;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (sender.tag == kMyOrderStatusOne||sender.tag ==kMyOrderStatusTwo||sender.tag ==kMyOrderStatusFour) {//1  2   4
        HCInfoView *infoview = [[HCInfoView alloc]initWithFrame:self.view.bounds type:kMyOrderStatusOne];
        [self.view addSubview:infoview];
    }
    if (sender.tag == kMyOrderStatusNine) {
      
        HCInfoView *infoview = [[HCInfoView alloc]initWithFrame:self.view.bounds type:kMyOrderStatusThree];
        [self.view addSubview:infoview];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"myOrderController"];
}

- (void)phone:(UIButton *)btn
{
    NSMutableString * str;
    str=[[NSMutableString alloc] initWithFormat:@"tel:%@",btn.titleLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}



@end
