    //
//  HCSelectVehicleViewController.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCSelectVehicleViewController.h"
#import "HCMySegmentView.h"
#import "City.h"
#import "CitySelectView.h"
#import "BizCity.h"
#import "CouponListViewController.h"
#import "SubscribeViewController.h"
#import "VehicleListViewController.h"
#import "DataFilter.h"
#import "LoginViewController.h"
#import "SearchController.h"
#import "HCVehicleListView.h"
#import "HCZhiyingdianController.h"
#import "CityViewController.h"
#import "HCCollectionViewController.h"
#import "HChomeViewController.h"
#import "NewVehicleController.h"
#import "HCZhibo.h"
#import "UIImageView+WebCache.h"
#import "HCSecForumController.h"

#import "HCZhibaoView.h"

#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
@interface HCSelectVehicleViewController ()<HCSegIndexDelegate,SearchControllerDelegate,VehicleListDelegate>
{
    int currentIndex;
    NSMutableArray *controllerArray;
    HCMySegmentView *barView; 
    DataFilter *dataFilter;
    HCZhiyingdianController *zhiyingView ;
    NewVehicleController *newVehicle;
    UIView *navview;
    NSString *name;
    UIButton *searchBtn;
}
@property (nonatomic,strong)VehicleListViewController *listView;
@property (nonatomic)NSInteger height;
@property (nonatomic,strong)CityViewController *cityViewController;
@property (nonatomic,strong)NSString *channelName;
@property (nonatomic,strong)UIView *viewback;
@property (nonatomic,strong)NSString *from;
@property (nonatomic,strong)UIImage *mViewImage;
@property (nonatomic)BOOL haszhiyingdian;
@property (nonatomic,strong)UIImageView *liveView;
@property (nonatomic,strong)HCZhibo *zhibo;

@property (nonatomic, strong) UIButton *zhibaoBtn;//质保入口

@end

@implementation HCSelectVehicleViewController
static  int offsetX;
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *haszhiying = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIYINGDIAN"];
    [self.view setFrame:CGRectMake(0, kNavHegith, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-kNavHegith-44)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slectUserVisit:) name:@"selectUserVisit" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subSucess:) name:@"subSucess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buyVehicleBtnClick:) name:@"HomeBuyClick" object:nil];
//    if (haszhiying==nil) {
//        _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"新上", nil];
//    }else{
//        if ([haszhiying isEqualToString:@"0"]) {
//            self.haszhiyingdian = NO;
//            _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"新上", nil];
//        }else{
//            self.haszhiyingdian = YES;
//            _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"直营店",@"新上", nil];
//            
//        }
//    }
   
    
    self.selectedCity = [[CityElem alloc]init];
    CityElem *userSelectedCity = [BizCity getCurCity];
    self.selectedCity.cityId = userSelectedCity.cityId;
    self.selectedCity.cityName = userSelectedCity.cityName;
    [self initNavBar];
    [self createMainScrollSeg];
    [self createSegment];
    [self addZhibaoView];
}
- (void)buyVehicleBtnClick:(NSNotification*)noti{
    _from = @"HomeBuy";
}

- (void)createSegment{

    if (barView) {
        [barView removeFromSuperview];
    }
    barView = [[HCMySegmentView alloc]initWithFrame:CGRectMake(60, 24, HCSCREEN_WIDTH-80, 40) andItems:_titleArray];
    barView.frame = CGRectMake((HCSCREEN_WIDTH-barView.width)/2, 24,barView.width, 40);
    barView.clickDelegate = self;
    barView.backgroundColor = [UIColor whiteColor];
    [navview addSubview:barView];
    if (_titleArray.count==2) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"todaynew"] isEqualToString:@"1"]) {
            [self barSelectedIndexChanged:1];
            [barView selectIndex:1];
        }else{
            [self barSelectedIndexChanged:0];
            [barView selectIndex:0];
        }
    }else{
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"todaynew"] isEqualToString:@"1"]) {
            [self barSelectedIndexChanged:2];
            [barView selectIndex:2];
        }else{
            [self barSelectedIndexChanged:0];
            [barView selectIndex:0];
        }
    }
    
}
- (void)initNavBar
{
    //2018-6-19修改
    /*
    self.citySelectView = [[CitySelectView alloc] initWithFrame:CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT - 104) forSuperView:self.view];
    navview = [[UIView alloc]init];
    navview.frame = CGRectMake(0, -20, HCSCREEN_WIDTH, 64);
    navview.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:navview];
   
    searchBtn = [UIButton buttonWithFrame:CGRectMake(0, 2, 60, 40) title:nil titleColor:nil bgColor:nil titleFont:nil image:[UIImage imageNamed:@"search"] selectImage:nil target:self action:@selector(searchClick:) tag:0];
    [self.navigationController.navigationBar addSubview:searchBtn];
    searchBtn.backgroundColor = [UIColor whiteColor];
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 44)];
    //图片
    UIImageView *iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, Width(130), 30)];
    iconimg.image = [UIImage imageNamed:@"home_top"];
    iconimg.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:iconimg];
    //标题
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 305, 10, 275, 30)];
    titleLab.text = @"连锁直营 ⋅ 全国直卖包邮";
    titleLab.textColor = [UIColor hex:@"212121"];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    [topView addSubview:titleLab];
    self.navigationItem.titleView = topView;
}

- (void)searchClick:(UIButton*)sender
{
    SearchController *searchViewController = [[SearchController alloc]init];
    [HCAnalysis HCUserClick:@"search_user_click"];
    searchViewController.hidesBottomBarWhenPushed = YES;
    searchViewController.delegate = self;
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (void)searchResult:(DataFilter *)datafilter{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SearchResult" object:datafilter userInfo:nil];
}
- (void)searchController:(NSDictionary *)searchDic
{
    NSDictionary *dic = searchDic;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"search" object:nil userInfo:dic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [HCAnalysis controllerBegin:@"HCSelectViewcontroller"];
     NSString *haszhiying = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZHIYINGDIAN"];
        self.tabBarController.delegate  =self;
    navview.hidden = NO;
    searchBtn.hidden = NO;
    barView.hidden = NO;
    ///工具栏
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"zhibo"]) {
        NSDictionary *zhibodic = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhibo"];
        self.liveView.hidden = NO;
        self.zhibo  = [[HCZhibo alloc]initWithZhiBoData:zhibodic];
        [self.liveView sd_setImageWithURL:[NSURL URLWithString:self.zhibo.pic_url] placeholderImage:nil];
    }else{
        self.liveView.hidden = YES;
    }
    [super viewWillAppear:animated];
    [self addZhibaoView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    if (self.haszhiyingdian == YES) {
//        if ([haszhiying isEqualToString:@"0"]) {
//            self.haszhiyingdian = NO;
//            if (zhiyingView.view.superview ==_mainView) {
//                [zhiyingView.view removeFromSuperview];
//            }
//            _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"新上", nil];
//            [self createMainScrollSeg];
//            [self createSegment];
//        }else{
//            int currentSeclectIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"select"]intValue];
//            [barView selectIndex:currentSeclectIndex];
//            [self barSelectedIndexChanged:currentSeclectIndex];
//            return;
//        }
//    }else{
//        if ([haszhiying isEqualToString:@"0"]) {
//            int currentSeclectIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"select"]intValue];
//                if (currentSeclectIndex==2) {
//                    [barView selectIndex:currentSeclectIndex-1];
//                    [self barSelectedIndexChanged:currentSeclectIndex-1];
//                }else{
//                    [barView selectIndex:currentSeclectIndex];
//                    [self barSelectedIndexChanged:currentSeclectIndex];
//                }
//            return;
//        }else{
//            if (newVehicle.view.superview ==_mainView) {
//                [newVehicle.view removeFromSuperview];
//            }
//            self.haszhiyingdian = YES;
//            _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"直营店",@"新上", nil];
//            [self createMainScrollSeg];
//            [self createSegment];
//        }
//    }
//    int currentSeclectIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"select"]intValue];
//    if (_titleArray.count==2) {
//        if (currentSeclectIndex==2) {
//            [barView selectIndex:currentSeclectIndex-1];
//            [self barSelectedIndexChanged:currentSeclectIndex-1];
//        }
//    }else{
//        [barView selectIndex:currentSeclectIndex];
//        [self barSelectedIndexChanged:currentSeclectIndex];
//    }
//    

}

- (void)setViewRect:(int)numberOne
{
    if (_titleArray.count==3) {
        switch (numberOne) {
            case 0:
                [_listView.mListTableView.mTableView  setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            case 1:
                [zhiyingView.vehcleTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            case 2:
                [ newVehicle.vehcleTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            default:
                break;
        }
    }else{
        switch (numberOne) {
            case 0:
                [_listView.mListTableView.mTableView  setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            case 1:
                [ newVehicle.vehcleTableView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            default:
                break;
        }
    }
   
}

- (void)selectIndex:(int)index
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [barView selectIndex:index];
    [self barSelectedIndexChanged:index];  
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selctcontroller"]integerValue]==1) {
          [self setViewRect:_mainView.contentOffset.x/HCSCREEN_WIDTH];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"selctcontroller"];
      [HCAnalysis HCclick:@"TabbarClick"WithProperties:@{@"TabName":@"BuyVehiclePage"}];
    _from = @"TabBuy";
}

- (void)slectUserVisit:(NSNotification*)notifi
{
     [barView selectIndex:[notifi.object intValue]];
}

//- (void)subSucess:(NSNotification*)noti
//{
//    if (subViewCon) {
//        [subViewCon AllRequest];
//        [subViewCon updateVehicleSource];
//        [subViewCon.detailVC removerView:nil];
//    }
//}
- (void)createMainScrollSeg
{
    if(!_mainView){
        _mainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
        _mainView.delegate = self;
        _mainView.pagingEnabled = YES;
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.scrollEnabled = NO;
        _mainView.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
        CGRect rect =  CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
        _listView = [[VehicleListViewController alloc]init];
        _listView.delegate = self;
        _listView.view.frame = rect;
        [self addChildViewController:_listView];
        [_mainView addSubview:_listView.view];
        [self.view addSubview:_mainView];
    }
    
    if (!self.liveView) {
        self.liveView = [[UIImageView alloc]init];
        self.liveView.userInteractionEnabled = YES;
        self.liveView.hidden = YES;
        self.liveView.frame = CGRectMake(HCSCREEN_WIDTH-10-HCSCREEN_WIDTH*0.25, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.25-75, HCSCREEN_WIDTH*0.25, HCSCREEN_WIDTH*0.25);
        UITapGestureRecognizer *bgPan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveViewtap:)];
        [self.liveView addGestureRecognizer:bgPan];
        [self.view addSubview:self.liveView];
    }
    [_mainView setContentSize:CGSizeMake(HCSCREEN_WIDTH*_titleArray.count, 0)];
    
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (scrollView == _mainView) {
        //int offsetX = [@(scrollView.contentOffset.x) intValue];
//        if (offsetX < 640 || offsetX >640) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Switch" object:nil userInfo:nil];
//        }
        CGPoint offset = scrollView.contentOffset;
        int page = (int)offset.x / HCSCREEN_WIDTH ;
        float radio = (float)((int)offset.x %(int)HCSCREEN_WIDTH)/HCSCREEN_WIDTH;
        [barView setLineOffsetWithPage:page andRatio:radio];
    } 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == _mainView) {
        offsetX = [@(scrollView.contentOffset.x) intValue];
        int selectIndex = offsetX/HCSCREEN_WIDTH;
        [barView selectIndex:selectIndex];
    }
}

- (void)UINavigationBarAndTabBarHidden
{
    [super.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.frame = CGRectMake(0, HCSCREEN_HEIGHT-self.tabBarController.tabBar.height, HCSCREEN_WIDTH, self.tabBarController.tabBar.height);
}

- (void)barSelectedIndexChanged:(int)newIndex
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"todaynew"];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        NSString *select = [NSString stringWithFormat:@"%d",newIndex];
        [[NSUserDefaults standardUserDefaults]setObject:select forKey:@"select"];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"Switch" object:nil userInfo:nil];
        [_mainView setContentOffset:CGPointMake(newIndex*HCSCREEN_WIDTH, 0)];
//        if (newIndex != 0 || newIndex != 1) {
//               [_listView.mListTableView.orderFilterView hide:YES];
//               _listView.mListTableView.isShowTab = NO;
//                // [lowView.orderFilterView hide:YES];
//               lowView.isShowTab = NO;
//        }
        if (newIndex == 0) {
            [HCAnalysis HCUserClick:@"SlideAllVeihicle"];
            _channelName = @"全部";
            if (Home_Thread_In) {
                [AppClient tongji:[NSString stringWithFormat:@"&page=list&entrance=%@",Home_Thread_In]];
            }else{
                [AppClient tongji:[NSString stringWithFormat:@"&page=list&entrance=%d",0]];
            }
        }
        if (_titleArray.count==2) {
            if (newIndex==1){
                [HCAnalysis HCUserClick:@"slidingNewVehicle"];
                if (!newVehicle) {
                    newVehicle = [[NewVehicleController alloc]init];
                }
                newVehicle.view.frame = CGRectMake(HCSCREEN_WIDTH*newIndex,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
                [self addChildViewController:newVehicle];
                [_mainView addSubview:newVehicle.view];
                
                _channelName = @"新上";
            }

        }else if (_titleArray.count==3) {
            
            if (newIndex==1) {
                if (!zhiyingView) {
                    zhiyingView = [[HCZhiyingdianController alloc]init];
                    
                }
                zhiyingView.view.frame = CGRectMake(HCSCREEN_WIDTH*newIndex,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
                [self addChildViewController:zhiyingView];
                [_mainView addSubview:zhiyingView.view];
                _channelName = @"直营店";
                //[lowView setdelegate];
            }else if (newIndex==2){
                [HCAnalysis HCUserClick:@"slidingNewVehicle"];
                if (!newVehicle) {
                    newVehicle = [[NewVehicleController alloc]init];
                }
                newVehicle.view.frame = CGRectMake(HCSCREEN_WIDTH*newIndex,0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
                [self addChildViewController:newVehicle];
                [_mainView addSubview:newVehicle.view];
                _channelName = @"新上";
            }
        }
    
}

-(void)contentSelectedIndexChanged:(int)newIndex
{
    [barView selectIndex:newIndex];
}

-(void)scrollOffsetChanged:(CGPoint)offset
{
    int page = (int)offset.x / HCSCREEN_WIDTH ;
    float radio = (float)((int)offset.x %(int)HCSCREEN_WIDTH)/HCSCREEN_WIDTH;
    [barView setLineOffsetWithPage:page andRatio:radio];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [HCAnalysis controllerEnd:@"HCSelectViewcontroller"];
    [super viewWillDisappear:animated];
    barView.hidden = YES;
    navview.hidden = YES;
    _from = @"Other";
    searchBtn.hidden = YES;
    [self.zhibaoBtn removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     int page = (int)_mainView.contentOffset.x / HCSCREEN_WIDTH ;
    if (page==0) {
        if (_channelName!=nil&&_from!=nil) {
            [HCAnalysis HCclick:@"BuyVehiclePage" WithProperties:@{@"VehicleChannel":_channelName,@"from":_from}];
        }
    }
    else{
        if (_channelName!=nil) {
            [HCAnalysis HCclick:@"BuyVehiclePage" WithProperties:@{@"VehicleChannel":_channelName}];
        }
       
    }
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)addZhibaoView{
    if (self.zhibaoBtn == nil) {
        self.zhibaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zhibaoBtn.frame = CGRectMake(kScreenWidth - Width(55) - Width(10), kScreenHeight - kTabbarHeight - Width(40) - Width(65), Width(55), Width(65));
        [self.zhibaoBtn setBackgroundImage:[UIImage imageNamed:@"buy_zhibao"] forState: UIControlStateNormal];
        [self.zhibaoBtn addTarget:self action:@selector(zhibaoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self.zhibaoBtn];
}

- (void)zhibaoAction{
    self.zhibaoBtn.hidden = YES;
    KWeakSelf(self);
    HCZhibaoView *zhibaoview = [[HCZhibaoView alloc]init];
    zhibaoview.cancle = ^{
        weakself.zhibaoBtn.hidden = NO;
    };
    [zhibaoview show];
    [HCAnalysis HCUserClick:@"ShowZhibaoView"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sende {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
