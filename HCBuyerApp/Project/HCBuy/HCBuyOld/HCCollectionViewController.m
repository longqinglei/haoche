//
//  HCCollectionViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/26.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCCollectionViewController.h"
#import "BizRequestCollection.h"
#import "HCNodataView.h"
#import "HCVehicleCell.h"
#import "Reachability.h"
#import "HCBaseViewController.h"
#import "ViewSubCri.h"
#import "NavView.h"
@interface HCCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,ViewCollectionDelegate>
{
     BOOL _isLoadMore;
     NSInteger _pageNum;
}
@property (weak, nonatomic) IBOutlet UIView *noCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (nonatomic, strong)ViewSubCri *noLoginView;
@property (nonatomic,strong)NSMutableArray *vehicleData;
@property (nonatomic,strong)NavView *liView;
@property (nonatomic)BOOL success;


@end

@implementation HCCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageNum = 1;
    _success = NO;
    _isLoadMore = NO;
    [self creatBackButton];
    self.title = @"收藏";
    [self addNotificationObserver];
    if (_vehicleData == nil) {_vehicleData = [[NSMutableArray alloc]init];}
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.mTableView.tableFooterView = [[UIView alloc]init];
    [self setupRefresh:_mTableView];
    self.liView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    self.liView.labelText.text = @"收藏";
    [self.view addSubview:self.liView];
    self.noLoginView = [[ViewSubCri alloc] initWithFrameCollection:CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
     [self.mTableView headerBeginRefreshing];
    self.noLoginView.CollectionDelegate = self;
}
- (void)addNotificationObserver{
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess:) name:@"logoutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionNot:) name:@"collectionNot" object:nil];
}
//- (void)loginSuccess:(NSNotification *)loginNoti{
//    [self.mTableView headerBeginRefreshing];
//    [self.noLoginView removeFromSuperview];
//}
//- (void)logoutSuccess:(NSNotification*)logoutNoti{
//   [self.view addSubview:self.noLoginView];
//}
- (void)ViewCollectionJmp
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"select"];
    [self.tabBarController setSelectedIndex:1];
     [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"selctcontroller"];
    [self.navigationController popViewControllerAnimated:NO];
  //  [self pushToLoginView:1];
    
}
//- (void)judgeuserislog{
//    if ([[HCLogin standLog] isLog]) {
//        [self.mTableView headerBeginRefreshing];
//        [self.mTableView reloadData];
//    }else{
//        [self.view addSubview:self.noLoginView];
//    }
//}
- (void)collectionNot:(NSNotification *)not
{
    self.isShowing = YES;
    [self headerRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"collection"];
}

- (void)updateVehicleSource
{
    [BizRequestCollection requestCollection_list:_pageNum back:^(NSInteger code, NSArray *array,NSString *vehicle_list) {
        if (code != 0) {
            _errorView.hidden = NO;
        }else if(code == 0 && self.isShowing){
            if (_isLoadMore) {
              [self.vehicleData removeAllObjects];
               self.vehicleData = [NSMutableArray arrayWithArray:array];
               [self.mTableView headerEndRefreshing];
                _success = YES;
            }else{
                [self.vehicleData addObjectsFromArray:array];
                [self.mTableView footerEndRefreshing];
                if (array.count == 0) {
                    [self showMsg:@"已全部加载" type:FVAlertTypeDone];
                  _success = NO;
                }
            }
            if(self.vehicleData.count == 0){
                 [self.view addSubview:self.noLoginView];
            }else {
                  [self.noLoginView removeFromSuperview];
            }
          [_mTableView reloadData];
        }
    }];
}

- (void)headerRefreshing
{
    _isLoadMore = YES;
    _pageNum = 1;
    [self updateVehicleSource];
}

- (void)footerRefreshing
{
    if (_success == YES)
    {
        _pageNum ++;
    }
      _isLoadMore = NO;
   [self updateVehicleSource];
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HC_VEHICLE_LIST_ROW_HEIGHT+5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self nav:YES])
    {
        [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    }
    [HCAnalysis HCUserClick:@"collectionlist_click"];
    HCVehicleCell *vehicleCell = (HCVehicleCell *)[tableView cellForRowAtIndexPath:indexPath];
    Vehicle *vehicle = [vehicleCell getVehicle];
    [self pushToVehicelDetailandVehic:vehicle hadCom:YES vehicleChannel:@"收藏"];
}

#pragma mark -- UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vehicleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"hc_vehicle_cell";
    HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Vehicle *vehicle = [self.vehicleData HCObjectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[HCVehicleCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5) data:vehicle];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell setVehicleData:vehicle];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backBuyGoodCar:(UIButton *)sender
{
    [self pushToHCSectWidth:0];
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)mRefresh:(UIButton *)sender
{
    [self updateVehicleSource];
     _errorView.hidden = YES;
    
}

static float lastContentOffset;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
}

 




@end
