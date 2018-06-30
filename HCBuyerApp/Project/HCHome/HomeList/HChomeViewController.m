//
//  HChomeViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/29.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HChomeViewController.h"

#import "UIImageView+WebCache.h"
#import "BizHomeReuqest.h"
#import "HomePromoteModel.h"
#import "HChomeFixedPictureCell.h"
#import "OperationchartView.h"
#import "UIAlertView+ITTAdditions.h"
#import "VersionView.h"
#import "VehicleSellViewController.h"
#import "InterlocutionView.h"
#import "HCTestingTableView.h"
#import "SelectVehicleView.h"
#import "BizBrandSeries.h"
#import "DataFilter.h"
#import "HCTodayNewVehicleCell.h"
#import "UIView+ITTAdditions.h"
#import "UiTapView.h"
#import "HCHomeNavgation.h"
#import "ForumModel.h"
#import "HCHomeForumCell.h"
#import "HCSecForumController.h"
#import "HCZhibo.h"
@interface HChomeViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,HCBannerViewClickDelegate,CityViewControllerDelegate,UITabBarControllerDelegate,OperationchartViewDelegate,SearchControllerDelegate,HChomeFixedPictureCellDelegate,UIAlertViewDelegate,VersionViewDelegate,UiTapViewDeleate,HCTestingTableViewDelegate,SelectDelegate,HCTodayNewVehicleCellDelegate>
{
    int pageNum;
    BOOL _isSuccessLoadFinsh;
}
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong)NSString* today_count;
@property (strong, nonatomic)UITableView *mTableView;
@property (strong, nonatomic)HCTestingTableView *mTestView;
@property (strong, nonatomic)CLLocationManager *locManager;
@property (nonatomic)float lastSpace;
@property (nonatomic)float newSpace;
@property (strong, nonatomic)NSMutableDictionary *param;
@property (nonatomic,strong)NSArray *ForumData;
@property (strong, nonatomic)HCBannerView*bannerView;
@property (strong, nonatomic)NSArray *brandArray;
@property (strong, nonatomic)NSArray *arrayCity ;
@property (strong, nonatomic)NSArray *priceData;
@property (strong, nonatomic)NSArray *bannerData;
@property (nonatomic,strong) NSArray *activityData;
@property (strong, nonatomic)UIView *viewback;
@property (strong, nonatomic)VersionView *mVersionView;
@property (strong, nonatomic)InterlocutionView *mInterView;
@property (strong, nonatomic)NSDictionary *dictCheck;
@property (strong, nonatomic)UiTapView *tapView;
@property (nonatomic)BOOL isReloadSelectView;
@property (nonatomic)CGFloat  height;
@property (nonatomic)NSInteger cityId;
@property (nonatomic,strong)NSString *accident_check_count;
@property (nonatomic)BOOL isReloadCheckCount;
@property (nonatomic)CityElem *selectedCity;
@property (nonatomic)CityElem *cityElem;
@property (nonatomic)BOOL isChangePosition;
@property (nonatomic,strong)UIBezierPath *bezierPath;
@property (nonatomic,strong)HCHomeNavgation *homeNavView;
@property (nonatomic,strong)NSArray *evaluateData;
@property (nonatomic,strong)NSArray *mQuestionArray;
@property (nonatomic,strong)UIImageView *liveView;
@property (nonatomic,strong)NSString *contentText;
@property (nonatomic,strong)HCZhibo *zhibo;
@property (nonatomic,strong)SelectVehicleView *selectView;
@end

@implementation HChomeViewController

//- (void)searchController:(NSDictionary *)searchDic
//{
//    NSDictionary *dic = searchDic;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"search" object:nil userInfo:dic];
//}
- (void)searchResult:(DataFilter *)datafilter{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchResult" object:datafilter userInfo:nil];
    
}
#pragma mark - TipCoupons
- (void)jumoptomycoupons
{
    [HCAnalysis HCUserClick:@"MyCoupons"];
    if ([[HCLogin standLog]isLog]){
        CouponListViewController *viewController = [[CouponListViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self pushToLoginView:0];
    }
}


#pragma mark - Question and answer layer
//首页问答模块
- (void)loadInterlocutionView
{
    [BizVehicleSource HomeInterlocutionRequestParam:^(NSInteger code, int i,NSArray *arrayTitle,NSString *title) {
        if (code == 0) {
            if (i == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:@"noclose" forKey:@"StatUser"];
                [self CreateInterlocutionViewWith:arrayTitle isShowClose:NO InterlocutionTitle:title];
            }else if (i == 2){
                [[NSUserDefaults standardUserDefaults] setObject:@"hasclose" forKey:@"StatUser"];
                [self CreateInterlocutionViewWith:arrayTitle isShowClose:YES InterlocutionTitle:title];
            }//-1不作处理
        }
    }];
}

- (void)pushApptore
{
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/er-shou-che-hao-che-wu-you/id946843913?mt=8"]]];
}

#pragma mark - requestFigure

- (void)CreateInterlocutionViewWith:(NSArray *)arrayTitle isShowClose:(BOOL)isShow InterlocutionTitle:(NSString *)title
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"firstLaunch"]) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"firstLaunch"] isKindOfClass:[NSString class]]) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"firstLaunch"] isEqualToString:@"1"]) {
                return;
            }
        }

    }
    _mQuestionArray = arrayTitle;
    _mInterView = [[InterlocutionView alloc]initInterframeRec:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) dataArray:arrayTitle title:title b:isShow];
    [[UIApplication sharedApplication].keyWindow addSubview:_mInterView];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLaunch"];
}

#pragma mark - 记录点击tabbar以及Delegate
- (void)setObject:(id)object Forkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selctcontroller"]integerValue]==0)
    {
        [self.mTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [self setObject:@0 Forkey:@"selctcontroller"];
    [HCAnalysis HCclick:@"TabbarClick"WithProperties:@{@"TabName":@"HomePage"}];
}

- (void)creatHCHomeNavgation
{
    self.homeNavView  = [[HCHomeNavgation alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    [self.homeNavView.searchBtn addTarget:self action:@selector(searchBarbtnCilcik:) forControlEvents:UIControlEventTouchUpInside];
    [self.homeNavView.cityBtn addTarget:self action:@selector(cityViewShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.homeNavView.cityBtn setTitle:self.selectedCity.cityName  forState:UIControlStateNormal];
    [self.view addSubview:self.homeNavView];
    self.homeNavView.alpha = 0;
}
- (void)CityElem
{
    self.selectedCity = [[CityElem alloc] init];
    CityElem *userSelectedCity = [BizCity getCurCity];
    self.selectedCity.cityId = userSelectedCity.cityId;
    self.selectedCity.cityName = userSelectedCity.cityName;
}

- (void)viewbackAddSuperView
{
    self.viewback = [UIView viewbackAddSuperVIew:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    [self.view addSubview:self.viewback];
    _tapView = [[UiTapView alloc]initWithFrame:self.viewback];
    _tapView.tapdelegate = self;

}

#pragma mark - 先例
- (void)viewThread
{
    [self CityElem];
    [self creatHCHomeNavgation];
    [self viewbackAddSuperView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])//可以注释了 6.0和7.0的区分,不支持7以下了
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([BizCity getRecommendCity] == nil)
    {
        [self getRecommendCity];
    }
}

#pragma mark -- 获取数据
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];

    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
         //   NSLog(@"receiveDic%@",receiveDic);
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] HCObjectAtIndex:0] valueForKey:@"version"]forKey:@"version"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] HCObjectAtIndex:0] valueForKey:@"releaseNotes"]forKey:@"releaseNotes"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
    
}
-(void)receiveData:(id)sender
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *receiveDict = (NSDictionary*)sender;
    NSString *version = [receiveDict objectForKey:@"version"];
    self.contentText = [receiveDict objectForKey:@"releaseNotes"];
    NSString *version1 = app_Version;
    //NSLog(@"ver=%f",ver);
    if ([version1 compare:version options:NSNumericSearch] ==NSOrderedDescending||[version1 compare:version options:NSNumericSearch] ==NSOrderedSame)
    {
        NSLog(@"%@ is bigger",version1);
    }
    else{
        _mVersionView = [[VersionView alloc]initWithFrameRect:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) urlArray:self.contentText];
        _mVersionView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_mVersionView];
        NSLog(@"%@ is bigger",version);
    }
}
- (void)checkoutAppStoreVersion{
    [self Postpath:APP_url];
}
- (void)createOperationchartViewWith:(Promotion*)promote{
    
    if (promote.type==0||promote==nil) {
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)promote.type]]){
        return ;
    }else{
        OperationchartView *operation = [[OperationchartView alloc]initWithframeRec:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) urlImage:nil];
        operation.delegate = self;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)promote.type] forKey:@"type"];
        if (promote.url.length!=0) {
            operation.webUrl = promote.url;
        }
        [operation.operationChartImage sd_setImageWithURL:[NSURL URLWithString:[NSString getFixedSolutionImageAllurl:promote.image_url w:operation.operationChartImage.width*2 h:operation.operationChartImage.height*2]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[UIApplication sharedApplication].keyWindow addSubview:operation];
        }];

    }
    
}
#pragma mark - request
// 跟城市相关数据
- (void)requestAll
{
    [BizHomeReuqest getHomeCityData:[BizCity getCurCity].cityId byfinish:^(NSInteger code,NSArray* cityArray,NSArray *brandArray,NSString *vehicle_count ,NSString*today_count,NSString*accident_check_count,NSArray*sliderList,NSArray*bannerList,NSArray*postsList,Promotion *promote,NSDictionary * zhibodict,int has_zhiyingdian) {
        if (code == 0) {
            self.mTableView.tableFooterView =nil;
            _isReloadSelectView = YES;
            _isReloadCheckCount = YES;
            NSString *zhiyingdian = [NSString stringWithFormat:@"%d",has_zhiyingdian];
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"ZHIYINGDIAN" object:[NSString stringWithFormat:@"%d",has_zhiyingdian]];
             [[NSUserDefaults standardUserDefaults]setObject:zhiyingdian forKey:@"ZHIYINGDIAN"];
            [self createOperationchartViewWith:promote];
           
            self.bannerData = bannerList;
            [self.bannerView setBannersData:self.bannerData];
            self.accident_check_count = accident_check_count;
            [self.mTestView resetSliderView:sliderList];
            self.today_count = today_count;
            if (zhibodict.count!=0) {
                self.liveView.hidden = NO;
                self.zhibo  = [[HCZhibo alloc]initWithZhiBoData:zhibodict];
                [[NSUserDefaults standardUserDefaults] setObject: zhibodict forKey:@"zhibo"];
                [self.liveView sd_setImageWithURL:[NSURL URLWithString:self.zhibo.pic_url] placeholderImage:nil];
            }else{
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"zhibo"];
                self.liveView.hidden = YES;

            }
            [self.mTestView resetVehicleNum:vehicle_count];
            [[NSUserDefaults standardUserDefaults]setObject:vehicle_count forKey:@"HomeVehicleNum"];
            [[NSUserDefaults standardUserDefaults]setObject:accident_check_count forKey:@"HomeVehicleCheckNum"];
            self.ForumData = postsList;
            if (_arrayCity.count == 0){
                [self updateCityData];
            }
            self.brandArray = brandArray;
        }else{
            [self.mTestView networkerror];
            [self.bannerView setBannersData:self.bannerData];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"HomeVehicleNum"]!=nil) {
                [self.mTestView resetVehicleNum:[[NSUserDefaults standardUserDefaults]objectForKey:@"HomeVehicleNum"]];
            }else{
                self.mTestView.vehicleNumLabel.hidden = YES;
            }
             _isReloadCheckCount = YES;
           
            self.mTableView.tableFooterView = [self createErrorlabel];
          //[self showMsg:@"网络不给力" type:FVAlertTypeError];
        }
        [_mTableView headerEndRefreshing];
        [_mTableView reloadData];
    }];
}
- (UILabel *)createErrorlabel{
    UILabel *errorlabel  = [[UILabel alloc]init];
    errorlabel.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, 50);
    errorlabel.text = @"网络不给力,请检查网络设置!";
    errorlabel.textColor = [UIColor lightGrayColor];
    errorlabel.font = [UIFont systemFontOfSize:15];
    errorlabel.textAlignment = NSTextAlignmentCenter;
    return errorlabel;
}
- (void)updateCityData
{
    _arrayCity = [City getCityList];
    CGFloat x = _arrayCity.count%3;
    if (x == 0) {
        _height =  HCSCREEN_HEIGHT/10*(_arrayCity.count/3);
    }else{
        _height = HCSCREEN_HEIGHT/10*(1+_arrayCity.count/3);
    }
    _mCityViewController.arrayData = _arrayCity;
    _mCityViewController.arrayHeight = _height;
    
    [_mCityViewController reloadVIew];
}
#pragma mark - hiddenCityView
- (void)tapGestureView
{
    [UIView animateWithDuration:0.2 animations:^{
        _viewback.hidden = YES;
        [self heightCityView:HCSCREEN_HEIGHT];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - CityH
- (void)heightCityView:(CGFloat)h
{
   self.mCityViewController.view.frame = CGRectMake(0, h, HCSCREEN_WIDTH, _height+110);
}

#pragma mark - addVIew
- (void)addView:(UIView *)view
{
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:view];
}

#pragma mark - cityShow
- (void)cityViewShow:(UIButton*)btn
{
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"城市切换"}];
    [AppClient tongji:Home_city];
    [HCAnalysis HCUserClick:@"home_city_click"];
    _viewback.hidden = NO;
    [self heightCityView:HCSCREEN_HEIGHT];
    [self addView:_mCityViewController.view];
    [UIView animateWithDuration:0.2 animations:^{
    [self heightCityView:HCSCREEN_HEIGHT-_height-110];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 点击切换城市
- (void)pushViewController:(NSInteger)ID CityName:(NSString *)name CityId:(NSInteger)cityId
{
     self.cityId = cityId;
    [self tapGestureView];
    [self.homeNavView.cityBtn setTitle:name forState:UIControlStateNormal];
    [self.mTestView.cityButton setTitle:self.selectedCity.cityName forState:UIControlStateNormal];
  //[self requestAll];
}

#pragma mark - Lifecycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          [self viewThread];
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppClient tongji:@"&page=home"];
//    if (self.ForumData == nil) {
//        self.ForumData = [[NSMutableArray alloc]init];
//    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.tabBarController.delegate = self;
   // dispatch_async(DefaultQueue, ^{
        [HCAnalysis controllerBegin:@"HomePage"];
   // });
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (_mCityViewController){
        _mCityViewController.delegate = self;
    }
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkoutAppStoreVersion];
    pageNum = 2;
    _isSuccessLoadFinsh = YES;
    //[self VersionDetection];
    _isReloadSelectView = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:@"CityChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNewCoupons) name:@"checkNewCoupon" object:nil];
    [self TableView];
    [self headerRefreshing];
    [self CityViewInitDelegate];
    if ([BizUser getUserId]==0) {
        [self loadInterlocutionView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mTableView headerEndRefreshing];
    if (self.lastSpace!=self.newSpace) {
        self.newSpace = self.lastSpace;
        int inSpace =   (int)self.newSpace;
        NSString *space = [NSString stringWithFormat:@"&st=%d",inSpace];
        [AppClient tongji:space finish:^(BOOL success) {}];
    }
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [HCAnalysis controllerEnd:@"HomePage"];
    
}
- (void)pushToSellOrBuyVehicle:(UIButton *)btn{
    if (btn.tag ==100) {
        [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"买车"}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HomeBuyClick" object:nil];
        [self setObject:@"0" Forkey:@"select"];
        [self selectTabarTwo];
    }else{
         [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"卖车"}];
        VehicleSellViewController *sellCon = [[VehicleSellViewController alloc]init];
        sellCon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sellCon animated:YES];
    }
}
- (void)cityChanged:(NSNotification*)noti
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"todaynew"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"select"];
    self.selectedCity = [[noti userInfo] objectForKey:@"city"];
    self.cityId = self.selectedCity.cityId;
    [self.homeNavView.cityBtn setTitle:self.selectedCity.cityName forState:UIControlStateNormal];
    [self.mTestView.cityButton setTitle:self.selectedCity.cityName forState:UIControlStateNormal];
    [self requestAll];
}

#pragma mark - TableView
- (UITableView *)TableView
{
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-49)];
    self.mTableView.backgroundColor = MTABLEBACK;
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.mTableView.showsVerticalScrollIndicator = NO;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self setupRefresh:self.mTableView];
    [self.mTableView removeFooter];
   
    self.liveView = [[UIImageView alloc]init];
    self.liveView.userInteractionEnabled = YES;
    self.liveView.hidden = YES;
    self.liveView.frame = CGRectMake(HCSCREEN_WIDTH-10-HCSCREEN_WIDTH*0.25, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.25-75, HCSCREEN_WIDTH*0.25, HCSCREEN_WIDTH*0.25);
    UITapGestureRecognizer *bgPan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveViewtap:)];
    [self.liveView addGestureRecognizer:bgPan];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.liveView];
    return self.mTableView;
}

- (void)liveViewtap:(UITapGestureRecognizer*)gesture{
    if (self.zhibo.link_url.length!=0) {
        HCSecForumController *secForum = [[HCSecForumController alloc]init];
        secForum.requestUrl = self.zhibo.link_url;
        secForum.isHaveRight=NO;
        secForum.titleType = 2;
        secForum.hidesBottomBarWhenPushed = YES;
        [self.navigationController  pushViewController:secForum animated:YES];
        [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"直播"}];
    }

}

//- (void)footerRefreshing
//{
//    NSLog(@"11111111");
//    //[self addForumData];
//}

#pragma mark - cityViewController
- (void)CityViewInitDelegate
{
    _mCityViewController = [CityViewController shareCity];
    _mCityViewController.delegate = self;
}
//检测新优惠劵
- (void)checkNewCoupons
{
    [self mCoupon];
}

- (void)headerRefreshing  //可以写一个
{
    pageNum = 2;
    //[self rquestHome_other_data];
    if (_currentLocation!=nil) {
        [self getCitylocationByLocation:_currentLocation];
    }
    [self requestAll];
   //[self performSelector:@selector(pushSecondController) withObject:nil afterDelay:2.0f];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return HCSCREEN_WIDTH*0.933+55;
    }
    else if (indexPath.section == 3){
        if (self.bannerData.count==0) {
            return 0;
        }else{
            return HCSCREEN_WIDTH*0.24+10;
        }
    }
    else if (indexPath.section == 1){
        if (self.brandArray.count==0) {
            return 91+(HCSCREEN_WIDTH - 43)/4*0.48;
        }else{
           return  HCSCREEN_WIDTH*0.165+(HCSCREEN_WIDTH - 43)/4*0.96+117;
        }

    }else if (indexPath.section ==4){
        if (indexPath.row == 0) {
            return HCSCREEN_WIDTH *0.13;
        }else{
            if (indexPath.row==self.ForumData.count) {
                return HCSCREEN_WIDTH*0.23+30;
            }else{
              return ForumCellHeight;
            }
        }
    }
    else if (indexPath.section == 2){
        return  (HCSCREEN_WIDTH-40)*0.49+76;
    }
        return 0;
}

#pragma mark - UITableViewData
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.ForumData.count == 0) {
         return 5;
    }else if (_isSuccessLoadFinsh == YES && self.ForumData.count != 0){
        return 5 ;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        if (self.ForumData.count!=0) {
            return self.ForumData.count+1;
        }else{
            return 0;
        }
    }else{
       return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3){
         NSString *mSlideViewCell = @"UITableViewCell";
        UITableViewCell *SlideCell = [tableView dequeueReusableCellWithIdentifier:mSlideViewCell];
        if (SlideCell==nil) {
            SlideCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mSlideViewCell];
            self.bannerView = [[HCBannerView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.24) data:self.bannerData controlStyle:0];

            SlideCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.bannerView.delegate = self;
            [SlideCell addSubview:self.bannerView];
            return SlideCell;
        }
        return SlideCell;
    }else if (indexPath.section == 0){
        NSString *mTestingViewCell = @"TestingTableViewCell";
        UITableViewCell *testingCell = [tableView dequeueReusableCellWithIdentifier:mTestingViewCell];
        if (testingCell==nil) {
            testingCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mTestingViewCell];
            self.mTestView = [[HCTestingTableView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.933+55) data:nil];
            testingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.mTestView.cityButton setTitle:self.selectedCity.cityName forState:UIControlStateNormal];
            self.mTestView.delegate = self;
            [testingCell addSubview:self.mTestView];
            return testingCell;
        }
        return testingCell;
    }else if (indexPath.section == 1){
         NSString *vehicelSelect = @"vehicelSelect";
         UITableViewCell *SelectCell = [tableView dequeueReusableCellWithIdentifier:vehicelSelect];
        if (SelectCell == nil) {
            SelectCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vehicelSelect];
            SelectCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.selectView = [[SelectVehicleView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, (HCSCREEN_WIDTH - 43)/4*0.48+91)];
            self.selectView.delegate = self;
            [SelectCell addSubview:self.selectView];
            return SelectCell;
        }
        if (_isReloadSelectView ==YES) {
            [self.selectView setHeight: HCSCREEN_WIDTH*0.165+(HCSCREEN_WIDTH - 43)/4*0.96+117];
           // [self.selectView createnoCityViewWithDataArray:self.priceData];
            [self.selectView createCityViewWithBrand:self.brandArray];
            [self.selectView createBottomViewWith:self.today_count];
            _isReloadSelectView = NO;
        }
         return SelectCell;
    }else if (indexPath.section == 4){
        if (indexPath.row==0) {
            NSString *NewTopCell = @"NewTopCell";
            HCTodayNewVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:NewTopCell];
            if (cell==nil) {
                cell = [[HCTodayNewVehicleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewTopCell];
                cell.isHaveLine = NO;
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
        if (indexPath.row>0&&indexPath.row<=self.ForumData.count) {
            NSString * cellIdentifier = @"forumCellReuse";
            HCHomeForumCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            ForumModel *model = [self.ForumData HCObjectAtIndex:indexPath.row-1];
            if (!cell) {
                CGFloat cellHeight ;
                if (indexPath.row == self.ForumData.count) {
                    cellHeight = HCSCREEN_WIDTH*0.23+30;
                }else{
                    
                    cellHeight =  ForumCellHeight;
                }
                cell = [[HCHomeForumCell alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, cellHeight) WithForumData:model];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == self.ForumData.count) {
                [cell showBottom];
            }else{
                [cell hideBottom];
            }
            [cell setdataWithForumData:model];
            return cell;
        }
    }else if (indexPath.section ==2){
        NSString *strID = @"HChomeFixedPictureCell";
        HChomeFixedPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if (cell == nil) {
            cell = [[HChomeFixedPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if (_isReloadCheckCount ==YES) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"HomeVehicleCheckNum"]!=nil) {
                self.accident_check_count =[[NSUserDefaults standardUserDefaults]objectForKey:@"HomeVehicleCheckNum"];
                [cell resetBadVehicleNum:self.accident_check_count];
            }else{
                [cell resetBadVehicleNum:@"00"];
            }
            
            _isReloadCheckCount=NO;
        }
        return cell;
    }
    return nil;
}

#pragma mark - searchViewController
- (void)searchBarbtnCilcik:(UIButton *)btn
{
    [AppClient tongji:Home_search];
      [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"搜索点击"}];
    SearchController *searchViewController = [[SearchController alloc]init];
    searchViewController.type = 1;
    searchViewController.hidesBottomBarWhenPushed = YES;
    searchViewController.delegate = self;
    [self.navigationController pushViewController:searchViewController animated:YES];
}
- (void)searchBtnClick{
    [self searchBarbtnCilcik:nil];
   //[self.mTestView resetCityName:@"山西" AndVehicleCount:@"0729738"];
}
- (void)cityBtnClick{
    [self cityViewShow:nil];
    
}
//论坛点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==4) {
        if (indexPath.row>0&&indexPath.row<=self.ForumData.count) {
            ForumModel *forum = [self.ForumData HCObjectAtIndex:indexPath.row-1];
            if (forum.link_url==nil||forum.link_url.length==0) {
                return;
            }
            HCSecForumController *secForum = [[HCSecForumController alloc]init];
            secForum.requestUrl = forum.link_url;
             secForum.isHaveRight=YES;
            secForum.titleType = 2;
            secForum.hidesBottomBarWhenPushed = YES;
            [self.navigationController  pushViewController:secForum animated:YES];
            [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":forum.title}];
        }
    }
}
- (void)clickMoreShare{
    [HCAnalysis HCUserClick:@"HomeServiceClick"];
    HCSecForumController *secForum = [[HCSecForumController alloc]init];
    secForum.requestUrl = MORESHARE;
    secForum.isHaveRight=NO;
    secForum.titleType = 2;
    secForum.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:secForum animated:YES];
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"买家分享"}];
    
}
//首页服务保障点击
- (void)ServiceGuarantee
{
    [HCAnalysis HCUserClick:@"HomeServiceClick"];
    HCSecForumController *secForum = [[HCSecForumController alloc]init];
    secForum.requestUrl = FUWUBAOZHANG;
    secForum.isHaveRight=NO;
    secForum.titleType = 2;
    secForum.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:secForum animated:YES];
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"服务保障"}];
}
//首页顶部图片点击
- (void)topBrannerClick:(Banner *)banner
{
    if (banner.link_url==nil||banner.link_url.length==0) {
        return;
    }
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":banner.title}];
    HCSecForumController *secForum = [[HCSecForumController alloc]init];
    secForum.requestUrl = banner.link_url;
    secForum.isHaveRight=NO;
    secForum.titleType = 2;
    secForum.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:secForum animated:YES];
}
//banner点击
- (void)bannerClick:(Banner *)banner
{
    if (banner.link_url==nil||banner.link_url.length==0) {
        return;
    }
    VehicleDetailViewController *nextViewController =[[VehicleDetailViewController alloc]init];
    nextViewController.title = banner.title;
    nextViewController.hidesBottomBarWhenPushed = YES;
    [nextViewController setSharedBtnByContentTpye:1 sharedObj:banner];
    nextViewController.url =banner.link_url ;
    [self.navigationController pushViewController:nextViewController animated:YES];
     [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":banner.title}];
}
//运营跳转
- (void)pushActivitiDetail:(NSString*)weburl
{
    if (weburl==nil||weburl.length==0) {
        return;
    }
    [self.tabBarController setSelectedIndex:0];
    VehicleDetailViewController *nextViewController =[[VehicleDetailViewController alloc]init];
    nextViewController.url  = weburl;
    nextViewController.mSharedType = 1;
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}
//今日新上
- (void)jumpNewVehiclePage{
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":@"今日新上"}];
    [self setObject:@"2" Forkey:@"select"];
    [self setObject:@"1" Forkey:@"todaynew"];
    [self selectTabarTwo];
}
//跳到买车界面
- (void)selectTabarTwo
{
    [self.tabBarController setSelectedIndex:1];
    [self setObject:@1 Forkey:@"selctcontroller"];
}
//优惠券
- (void)mCoupon
{
    [HCAnalysis HCUserClick:@"MyCoupons"];

    if ([[HCLogin standLog]isLog]){
        CouponListViewController *viewController = [[CouponListViewController alloc]init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        [self pushToLoginView:0];
    }
}
//快速选车 活动点击
- (void)activityBtnClick:(CondBtn *)btn{
    
    VehicleDetailViewController *nextViewController =[[VehicleDetailViewController alloc]init];
    nextViewController.url  = btn.activity.url;
    nextViewController.mSharedType = 1;
    nextViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
    [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":btn.activity.title}];
}

//快速选车 价格点击
- (void)priceBtnClick:(CondBtn *)btn{
       [HCAnalysis HCUserClick:@"home_hot_price_click"];
        DataFilter *dataFilter = [[DataFilter alloc] init];
        dataFilter.city = self.selectedCity;
        dataFilter.priceCond = btn.priceCond;
    
        [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":btn.priceCond.desc}];
        if ([VehicleListViewController isInit] == NO)
        {
            [VehicleListViewController setPredefinedDataFilter:dataFilter];
        }
        else
        {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:dataFilter forKey:@"dataFilter"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFilterSelected" object:nil userInfo: param];
        }
    
    [self setObject:@"0" Forkey:@"select"];
    [self setObject:@"0" Forkey:@"todaynew"];
    [self selectTabarTwo];
}
//快速选车 品牌点击
- (void)brandBtnClick:(CondBtn *)btn{
    [HCAnalysis HCUserClick:@"home_hot_brand_click"];
    DataFilter *dataFilter = [[DataFilter alloc] init];
    dataFilter.city = self.selectedCity;
    dataFilter.brandSeriesCond = [[BrandSeriesCond alloc] init];
    dataFilter.brandSeriesCond.brandId = btn.brandCond.brandId;
    dataFilter.brandSeriesCond.brandName = btn.brandCond.brandName;
    dataFilter.brandSeriesCond.seriesId = -1;
    dataFilter.brandSeriesCond.seriesName = @"";
    if ([VehicleListViewController isInit] == NO){
        [VehicleListViewController setPredefinedDataFilter:dataFilter];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:dataFilter forKey:@"dataFilter"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeFilterSelected" object:nil userInfo: param];
    }
      [HCAnalysis HCclick:@"HomePageClick" WithProperties:@{@"BtnName":btn.brandCond.brandName}];
    [self setObject:@"0" Forkey:@"select"];
    [self setObject:@"0" Forkey:@"todaynew"];
    [self selectTabarTwo];
}

#pragma mark - Location
- (void)getRecommendCity
{
    self.locManager = [[CLLocationManager alloc]init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 1000.0f;
    [self.locManager startUpdatingLocation];  //用户拒绝 不断打开提示不合理,去掉了
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
}}


- (void)getCitylocationByLocation:(CLLocation*)cllocation{
    [BizCity getRecommendCityByLat:cllocation.coordinate.latitude andLng:cllocation.coordinate.longitude byfinish:^(CityElem *elem) {
        //1: 当用户关闭的定位   点击可以定位  走这里  第一次进入程序
        self.isChangePosition = NO;
        if (elem != nil) {
            _param = [[NSMutableDictionary alloc] init];
            [_param setObject:elem forKey:@"city"];
            NSString *positionElemName = [[NSUserDefaults standardUserDefaults]objectForKey:@"positionElem"];
            if (![elem.cityName isEqualToString:positionElemName ]) {
                self.isChangePosition =YES;
            }else{
                self.isChangePosition = NO;
            }
            [self.mCityViewController getRecommendCity];
            [[NSUserDefaults standardUserDefaults]setObject:elem.cityName forKey:@"positionElem"];
            if (![BizCity isCitySelected]) {
               CityElem *curCity = [BizCity getCurCity];
                if (curCity.cityId!=elem.cityId) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:_param];
                }
            }else{
                [self City];
            }
        }
    }];
}
#pragma mark -- requestLocation

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations lastObject];
    [self getCitylocationByLocation:_currentLocation];
    
//    [BizCity getRecommendCityByLat:_currentLocation.coordinate.latitude andLng:_currentLocation.coordinate.longitude byfinish:^(CityElem *elem) {
//        //1: 当用户关闭的定位   点击可以定位  走这里  第一次进入程序
//        self.isChangePosition = NO;
//        if (elem != nil) {
//            _param = [[NSMutableDictionary alloc] init];
//            [_param setObject:elem forKey:@"city"];
//            NSString *positionElemName = [[NSUserDefaults standardUserDefaults]objectForKey:@"positionElem"];
//            if (![elem.cityName isEqualToString:positionElemName ]) {
//                self.isChangePosition =YES;
//            }else{
//                self.isChangePosition = NO;
//            }
//             [self.mCityViewController getRecommendCity];
//             [[NSUserDefaults standardUserDefaults]setObject:elem.cityName forKey:@"positionElem"];
//            if (![BizCity isCitySelected]) {
//                CityElem *curCity = [BizCity getCurCity];
//                if (curCity.cityId!=elem.cityId) {
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:_param];
//                }
//            }else{
//                [self City];
//            }
//        }
//    }];
      [manager stopUpdatingLocation];
}

- (void)City
{
    if ([BizCity getCurCity]) {
        _cityElem = [_param objectForKey:@"city"];
        if ([BizCity getCurCity].cityId != _cityElem.cityId) {
            if (self.isChangePosition == YES) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"检测到您的访问城市发生变化,推荐您切换到[%@]",_cityElem.cityName] message:nil delegate:self cancelButtonTitle:@"切换" otherButtonTitles:@"不切换", nil];
                [alertView show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {  //
        self.cityElem = [_param objectForKey:@"city"];
        CityViewController *cityController = [CityViewController shareCity];
        [cityController resetCityColor:self.cityElem.cityId];
        [BizCity saveSelectedCity:self.cityElem];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:_param];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    CGFloat BeginY = HCSCREEN_WIDTH*0.933+22;
    self.lastSpace = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y >=BeginY-20) {
         self.homeNavView.alpha = 1;
    }else{
        self.homeNavView.alpha = 0;
    }
}

@end
