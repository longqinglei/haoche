//
//  HCHomeVC.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/19.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCHomeVC.h"
#import "HCHomePicCell.h"
#import "HCHomeButtonCell.h"
#import <CoreLocation/CoreLocation.h>
#import "SSKeychainQuery.h"
#import "BizHomeReuqest.h"

@interface HCHomeVC ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
//页面图片集合
@property (nonatomic, strong) NSMutableArray *imgarr;
//经纬度
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,assign) CGFloat lng;
//请求图片数据
@property (nonatomic, strong) NSDictionary *picData;

@end

@implementation HCHomeVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [HCAnalysis controllerBegin:@"HCHomeVC"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [HCAnalysis controllerEnd:@"HCHomeVC"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
    self.imgarr = [NSMutableArray arrayWithObjects:@"home_1.jpg",@"home_2.jpg",@"home_3.jpg",@"home_4.jpg",nil];
    [self makeNavBar];
}
//导航栏
- (void)makeNavBar{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.imgarr.count == 4) {
        return self.imgarr.count + 2;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 5) {
        HCHomeButtonCell *cell = [HCHomeButtonCell creatTableViewCellWithTableView:tableView];
        return cell;
    }else{
        HCHomePicCell *cell = [HCHomePicCell creatTableViewCellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.imgname = self.imgarr[indexPath.row];
        }else{
            cell.imgname = self.imgarr[indexPath.row - 1];
        }
        return cell;
    }
}

- (void)loadData{
    KWeakSelf(self);
    [BizHomeReuqest getHomeCityData:self.lat lng:(CGFloat)self.lng finish:^(BOOL result, id data) {
        if (result) {
            weakself.picData = data;
            NSString *img2 = [data[@"mid_promote"] firstObject];
            if (img2.length != 0) {
                dispatch_async(dispatch_get_global_queue(1, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img2]]];
                    [weakself.imgarr replaceObjectAtIndex:1 withObject:image];
                    [weakself reloadTableView];
                });
            }
            NSString *img1 = [data[@"top_promote"] firstObject];
            if (img1.length != 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img1]]];
                    [weakself.imgarr replaceObjectAtIndex:0 withObject:image];
                    [weakself reloadTableView];
                });
            }
        }
    }];
}

#pragma mark 获取位置信息
- (void)getLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] && (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusNotDetermined)) {
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 总是授权
        //        [locationManager requestAlwaysAuthorization];
        locationManager.distanceFilter = 10.0f;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }else{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"您未开启获取位置的权限" message:@"请前往设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self loadData];
        }];
        [vc addAction:cancle];
        [vc addAction:okaction];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * currentLocation = [locations lastObject];
    self.lat = currentLocation.coordinate.latitude;
    self.lng = currentLocation.coordinate.longitude;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.lat] forKey:@"selflat"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.lng] forKey:@"selflng"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadData];
    [manager stopUpdatingLocation];
}


@end
