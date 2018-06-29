//
//  HCSaleStatusViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCSaleStatusViewController.h"

#import "VehiceSaleStatusView.h"
#import "VehiceSaleConsultation.h"
#import "SubSettViewController.h"
#import "UIAlertView+ITTAdditions.h"
#import "BizMySaleVehicle.h"
#import "MySaleVehicles.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MySaleVehicleCell.h"
#import "User.h"
#import "VehicleDetailViewController.h"
#import "BizUser.h"
#import "HCSaleStatusView.h"
#import "UiTapView.h"


@interface HCSaleStatusViewController ()<VehiceSaleStatusViewDelegate,UITableViewDataSource,UITableViewDelegate,VehiceSaleConsultationDelegate,HCSaleStatusViewDelegate,UiTapViewDeleate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UIView *offlineView;
@property (weak, nonatomic) IBOutlet UIImageView *offlineLmage;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIView *noLineView;
@property (weak, nonatomic) IBOutlet UIButton *mPhoneoff;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIView *offLineView;
@property (weak, nonatomic) IBOutlet UILabel *phoneCarName;
@property (weak, nonatomic) IBOutlet UILabel *carStatusText;
@property (weak, nonatomic) IBOutlet UIButton *offLinePhone;
@property (weak, nonatomic) IBOutlet UIButton *clickSaleBack;
@property (weak, nonatomic) IBOutlet UIView *offlinePhoneView;
@property (weak, nonatomic) IBOutlet UIView *errNetworkView;
@property (weak, nonatomic) IBOutlet UIButton *saleCar;

@property (weak, nonatomic) IBOutlet UIView *mArrayCountView;
@property (weak, nonatomic) IBOutlet UILabel *carLabelText;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCarId;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *offCarLabel;

@property (nonatomic,strong)VehiceSaleStatusView *mSaleStatusView;
@property (nonatomic,strong)VehiceSaleConsultation *mSaleConsultation;
@property (nonatomic,strong)SubSettViewController *detailVC;
@property (nonatomic,strong)NSString *mConsultingPhone;
@property (nonatomic,strong)UITableView *mTableView;
@property (nonatomic,strong)HCSaleStatusView *mViewBackgroud;
@property (nonatomic,assign)SaleStatus mSaleStatus;
@property (nonatomic,strong)MySaleVehicles *vehicle;
@property (nonatomic,strong)UIView *Sview ;
@property (nonatomic,strong)UIButton *mConsultingSales;
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)UIImageView * imageBtnclick ;
@property (nonatomic,strong)UiTapView*tap;


@property (nonatomic)NSInteger selectIndex;
@property (nonatomic)CGFloat heightView;
@property (nonatomic)CGFloat floatHight;

@end

@implementation HCSaleStatusViewController


#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mTableView = [[UITableView alloc]init];
  //  _vehicle = [[Vehicle alloc]init];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_mTableView];
    [HCAnalysis controllerBegin:@"MySoldVehiclePage"];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"MySoldVehiclePage"];
    [_mTableView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewSuccees];
    _mViewBackgroud = [[HCSaleStatusView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) and:self.view];
    _mViewBackgroud.delegate = self;
    
    _mArrayCountView.hidden = YES;
    _tap = [[UiTapView alloc]initWithFrame:_mArrayCountView];
    _tap.tapdelegate = self;
}


- (void)requestData
{
    [BizMySaleVehicle getMySaleVehicleDataWithPhoneNum:IPHONE Finish:^(NSArray *ret, NSInteger code)
     {
        if (code!=0) {
            _errNetworkView.hidden = NO;
            _mConsultingSales.hidden = YES;
            _mArrayCountView.hidden = YES;
        }else{
            if(ret.count!=0){
                _arrayData = ret;
                _mArrayCountView.hidden = NO;
                MySaleVehicles *vehicle = [_arrayData HCObjectAtIndex:0];
                _vehicle = vehicle;
               [self createScrollviewByVehicles:vehicle];
                if (_arrayData.count == 1) {
                    _mArrayCountView.userInteractionEnabled=NO;
                    self.selectImage.hidden = YES;
                }else{
                    self.selectImage.hidden = NO;
                    _mArrayCountView.userInteractionEnabled= YES;
                }
            }
        }
        [_mTableView reloadData];
    }];
}
- (void)dealloc{
    NSLog(@"走");
    
}

- (void)vehicleDetailsLable:(MySaleVehicles *)vehicle
{
    if (vehicle.vehicle_name==nil) {
        _offCarLabel.text= vehicle.status_text;
        _offCarLabel.hidden = NO;
        self.carLabelText.hidden = YES;
        _lineView.hidden = YES;
    }else{
         _mConsultingPhone = vehicle.ask_seller_phone;
        NSString *imageName = [NSString stringWithFormat:@"%@", vehicle.brand_id];
        self.imageViewCarId.image = LOADIMAGE(imageName, @"png");
        //[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", vehicle.brand_id]];
        self.carLabelText.hidden = NO;
        self.carLabelText.text = vehicle.vehicle_name;
        _offCarLabel.hidden = YES;
        _lineView.hidden = NO;
    }
}

- (void)createScrollviewByVehicles:(MySaleVehicles*)vehicle
{
    _vehicle = vehicle;
    [self vehicleDetailsLable:vehicle];
    [self farmeStatusView:vehicle and:HCSCREEN_HEIGHT];
    [self farmeConsultation:vehicle and:HCSCREEN_WIDTH];
    [self createMscrollview];
    [self viewBackCloc:vehicle];
    [_mSaleConsultation reloadViewDataWithMySaleVehicles:vehicle];
    [_mSaleStatusView updateViewData:vehicle];
    
   // [self changeMyvehicleToVehicle:vehicle];
    self.offLineView.hidden = YES;
    if (vehicle.status==2) {
        _mConsultingSales.hidden = YES;
    }else{
        _mConsultingSales.hidden = NO;
    }
    if (vehicle.status==1||vehicle.status==-1)
    {
        [self offlineornotsubmit:vehicle];
    }
}

- (void)tapGestureView
{
    _mViewBackgroud.hidden = NO;
    _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, 44*_arrayData.count);
    [UIView animateWithDuration:0.2 animations:^{
        _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT-44*_arrayData.count, HCSCREEN_WIDTH, 44*_arrayData.count);
        [UIView animateWithDuration:0.2 animations:^{
            
        }];
    } completion:^(BOOL finished) {
    }];
}


- (void)mViewHeight:(CGFloat)height
{
    _heightView = height;
}

- (void)createMscrollview
{
    [_mScrollView addSubview:self.mSaleStatusView];
    _mScrollView.userInteractionEnabled = YES;
    _mScrollView.showsVerticalScrollIndicator = FALSE;
    [_mScrollView addSubview:self.mSaleConsultation];
    _mScrollView.contentSize = CGSizeMake(HCSCREEN_WIDTH, self.mSaleStatusView.height+self.mSaleConsultation.height);
    _mScrollView.delegate = self;
}

- (NSMutableString*)replacephonenum
{
    NSMutableString *temp = [NSMutableString stringWithString:IPHONE];
    NSRange range;
    range.length = 4;
    range.location = 3;
    [temp replaceCharactersInRange:range withString:@"****"];
    return temp;
}

- (void)offlineornotsubmit:(MySaleVehicles*)vehicle
{
    _offLineView.hidden = NO;
    self.phoneCarName.text = [NSString stringWithFormat:@"您好,%@车主",[self replacephonenum]];
    if (vehicle.status==1) {
         _carStatusText.text = @"您还未提交爱车出售信息 请先提交出售爱车信息";
        self.saleCar.hidden = NO;
    }else{
        self.carStatusText.text = @"应您要求，您的车辆已做下线不显示";
        self.saleCar.hidden = YES;
    }
    _clickSaleBack.hidden = NO;
    _offLinePhone.titleLabel.text = @"4000-696-8390";
     _mConsultingSales.hidden = YES;
}

- (void)farmeStatusView:(MySaleVehicles *)vehicle and:(int)hight
{
    self.mSaleStatusView = [[VehiceSaleStatusView alloc]initWithFrame:CGRectMake(0, 66, HCSCREEN_WIDTH, hight) MySaleVehicles:vehicle andSatus:vehicle.status];
    self.mSaleStatusView.delegate = self;
}

- (void)farmeConsultation:(MySaleVehicles *)vehicle and:(int)hight
{
   self.mSaleConsultation = [[VehiceSaleConsultation alloc]initWithFrame:CGRectMake(0,_mSaleStatusView.bottom, HCSCREEN_WIDTH, hight) andSatus:vehicle.status MySaleVehicles:vehicle];
    self.mSaleConsultation.delegate = self;
}

- (void)viewSuccees
{
    self.title = @"我的爱车";
    [self requestData];
    [self creatBackButton];
}

- (void)viewBackCloc:(MySaleVehicles*)vehicle
{
    if (!_mConsultingSales) {
        _mConsultingSales = [UIButton buttonWithFrame:CGRectMake(0,HCSCREEN_HEIGHT-HCSCREEN_HEIGHT/13, HCSCREEN_WIDTH, HCSCREEN_HEIGHT/13) title:vehicle.ask_seller_text titleColor:[UIColor whiteColor] bgColor:[UIColor colorWithRed:0.87f green:0.01f blue:0.01f alpha:1.00f] titleFont:[UIFont boldSystemFontOfSize:16] image:nil selectImage:nil target:self action:@selector(mConsulting:) tag:9];
        _mConsultingSales.tag = 1005;
        _mConsultingSales.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.view addSubview:_mConsultingSales];
    if (vehicle.status ==3||vehicle.status==4) {
        
        self.mConsultingSales.hidden =NO;
    }else{
         self.mConsultingSales.hidden =YES;
    }
}

- (void)mConsulting:(UIButton *)btn
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:_mConsultingPhone message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1111;
    [alert show];
    alert.delegate= self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [HCAnalysis HCUserClick:@"mConsultingSales"];
    if (alertView.tag == 1112) {
        if (buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://4000-696-8390"]]];}}
    if (alertView.tag == 1111) {
        if (buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mConsultingPhone]]];}
    }else{
        if (buttonIndex == 1){
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mConsultingPhone]]];
      }
    }
}


- (void)tapRecognizer
{
    [UIView animateWithDuration:0.2 animations:^{
        _mViewBackgroud.hidden = YES;
        _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, 44*_arrayData.count);
    } completion:^(BOOL finished) {
    }];
}


- (void)vehicleDetails
{
    [self vehicleDetails:_vehicle];
}

- (void)vehicleDetails:(MySaleVehicles *)myvehicle
{
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    //nextViewController.vehicle = myvehicle;
    nextViewController.title = [NSString stringWithFormat:@"%@-%@",myvehicle.brandName,myvehicle.className];
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.source_id = myvehicle.vehicle_source_id;
    nextViewController.url = [NSString stringWithFormat:DETAIL_URL, (long)myvehicle.vehicle_source_id,(long)[BizUser getUserId],[BizUser getUserType]];
    [nextViewController setSharedBtnByContentTpye:0 sharedObj:myvehicle];
    [nextViewController setVehicleCompareBtn];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)priceSaleStatus
{
     _mViewBackgroud.hidden = NO;
    _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, 44*_arrayData.count);
    [UIView animateWithDuration:0.2 animations:^{
    _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT-44*_arrayData.count, HCSCREEN_WIDTH, 44*_arrayData.count);
      [UIView animateWithDuration:0.2 animations:^{
      }];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpletableidentifier=@"simpletableitem";
    MySaleVehicleCell *cell=[tableView dequeueReusableCellWithIdentifier:simpletableidentifier];
     MySaleVehicles *saleModel = [_arrayData HCObjectAtIndex:indexPath.row];
    if(cell==nil) {
        cell=[[MySaleVehicleCell alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 44)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    };
    if (indexPath.row == self.selectIndex) {
        cell.labelTtext.textColor = PRICE_STY_CORLOR;
        cell.selectImage.hidden = NO;
    }else{
        cell.selectImage.hidden = YES;
         cell.labelTtext.textColor = [UIColor blackColor];
    }
    cell.labelTtext.text = saleModel.vehicle_name;
    if (cell.labelTtext.text == nil) {
        cell.labelTtext.text = saleModel.status_text;
    }
    cell.labelTtext.font = [UIFont systemFontOfSize:14];
    return cell;
}

//- (void)changeMyvehicleToVehicle:(MySaleVehicles*)myvehicle
//{
//    if (myvehicle.vehicle_source_id) {
//        _vehicle.vehicle_id = [myvehicle.vehicle_source_id stringValue] ;
//        _vehicle.vehicleName = myvehicle.vehicle_name;
//        _vehicle.brandName = myvehicle.brandName;
//        _vehicle.className =myvehicle.className;
//        _vehicle.vehicleMiles = myvehicle.Miles;
//        _vehicle.vehiclePrice = [myvehicle.seller_price floatValue];
//        _vehicle.gearboxType = [myvehicle.gearbox intValue];
//        _vehicle.registerDate = (int)[self convertTimestamp:myvehicle.registerYear andMonth:myvehicle.registerMonth];
//        _vehicle.vehicleImage = myvehicle.cover_image;
//        _mConsultingPhone = myvehicle.ask_seller_phone;
//    }
//}

-(NSInteger)convertTimestamp:(NSInteger)year andMonth:(NSInteger)month
{
    NSString *dateStr = [[NSString alloc] initWithFormat:@"%4ld-%2ld-01 00:00:00", (long)year, (long)month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    return [date timeIntervalSince1970];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _vehicle = [_arrayData HCObjectAtIndex:indexPath.row];
    [self viewBackCloc:_vehicle];
    _mConsultingPhone = _vehicle.ask_seller_phone;
    self.imageViewCarId.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _vehicle.brand_id]];
    [self vehicleDetailsLable:_vehicle];
    [ self.mConsultingSales setTitle:_vehicle.ask_seller_text forState:UIControlStateNormal];
   // [self changeMyvehicleToVehicle:myvehicle];
    [_mSaleConsultation reloadViewDataWithMySaleVehicles:[_arrayData HCObjectAtIndex:indexPath.row]];
    [_mSaleStatusView updateViewData:[_arrayData HCObjectAtIndex:indexPath.row]];
    
    [UIView animateWithDuration:0.2 animations:^{
         _mTableView.frame = CGRectMake(0, HCSCREEN_HEIGHT, HCSCREEN_WIDTH, 44*_arrayData.count);
        _mViewBackgroud.hidden = YES;
    }];
    self.selectIndex = indexPath.row;
      [_mTableView reloadData];
}

- (void)setBool:(BOOL)LineView and:(BOOL)ConsultingSales and:(BOOL)scrollEnabled
{
    _noLineView.hidden = LineView;
    _mConsultingSales.hidden = ConsultingSales;
    _mScrollView.scrollEnabled = scrollEnabled;
}

- (void)updateViewHeight:(CGFloat)height and:(int)status
{
    if (status == 2) {
        self.mSaleStatusView.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, height);
        [_mPhoneoff bringSubviewToFront:_mScrollView];
        self.labelPhone.text = [NSString stringWithFormat:@"您好,%@车主",[self replacephonenum]];
        [self setBool:NO and:YES and:NO];
        _offLineView.hidden = YES;
        _mConsultingSales.hidden = YES;
    }else
    {
        [self setBool:YES and:NO and:YES];
    }
    if (status == 4 || status == 3) {
        self.mSaleStatusView.frame = CGRectMake(0, 66, HCSCREEN_WIDTH, height);
        self.mSaleConsultation.frame = CGRectMake(0, _mSaleStatusView.bottom, HCSCREEN_WIDTH,_floatHight);
        [self setBool:YES and:NO and:YES];
        self.mScrollView.hidden = NO;
        _offLineView.hidden = YES;
    }
    if (status == -1) {
        self.mSaleStatusView.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, height);
        self.phoneCarName.text = [NSString stringWithFormat:@"您好,%@车主",[self replacephonenum]];
        self.mScrollView.hidden = YES;
        _offLineView.hidden = NO;
        _noLineView.hidden = YES;
        [self setBool:YES and:YES and:NO];
    }else{
        _offLineView.hidden = YES;
        self.mSaleStatusView.hidden = NO;
    }
    if (status==1) {
        self.mScrollView.hidden = YES;
        _offLineView.hidden = NO;
        _noLineView.hidden = YES;
    }
      _mScrollView.contentSize = CGSizeMake(HCSCREEN_WIDTH, self.mSaleStatusView.height+10+self.mSaleConsultation.height+66+44);
    
}

- (void)AlerViewPhone
{
    [UIAlertView popupAlertByDelegate:self title:_mConsultingPhone message:@"" cancel:@"取消" others:@"确定"];
}

- (void)updateHeight:(CGFloat)height
{
    _floatHight = height;
}

- (void)AlerView
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"4000-696-8390" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1112;
    [alert show];
}

- (IBAction)btnclick:(UIButton *)sender
{
       [self AlerView];
}

- (IBAction)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
