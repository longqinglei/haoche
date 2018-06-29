//
//  VehicleSellViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/5/5.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehicleSellViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CustomURLCache.h"
#import "HCNodataView.h"
#import "OperationchartView.h"
#import "BizUser.h"
#import "HCSaleStatusViewController.h"
#import "HCtheSaleOftheCarView.h"
#import "Submit SaleInterfaceView.h"
#import "UIAlertView+ITTAdditions.h"
#import "BizSubmitTel.h"
#import "NavView.h"
@interface VehicleSellViewController () <UIGestureRecognizerDelegate,UITabBarControllerDelegate,Submit_SaleInterfaceViewDelegate,HCtheSaleOftheCarViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic,strong)Submit_SaleInterfaceView*saleInterface;
@property (nonatomic,strong)NSString *peopleNum;
@property (nonatomic,strong)NSString *coverurl;
@property (nonatomic,strong)NSString *telNum;
@property (nonatomic,strong)HCtheSaleOftheCarView*topView;
@property (nonatomic,strong)UILabel *bottomPhone;
@property (nonatomic,strong)UIView *mPromptBg;
@property (nonatomic,strong)UILabel *midTel;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic, strong) NavView *mNavView;
@end

@implementation VehicleSellViewController


- (void)createMyNaView
{
    self.navigationItem.title = @"出售爱车";
    [self createRightBtn];
    _mPromptBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
    _mPromptBg.backgroundColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.60f];
     [[UIApplication sharedApplication].keyWindow addSubview:_mPromptBg];
    _mPromptBg.hidden = YES;
}



- (void)removeFromSuperView
{
    _mPromptBg.hidden = YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"selctcontroller"]integerValue]==2) {
        [self.mScrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@2 forKey:@"selctcontroller"];
    //[HCAnalysis HCClick:@"sellVehicle" WithName:@"出售爱车"];
    [HCAnalysis HCUserClick:@"sellVehicle"];
}

- (void)createRightBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(0, 0, 80, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(mMyLoveCar:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"我的爱车" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
     [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.navigationItem setLeftBarButtonItem:nil];
}
- (void)pushViewcontroller
{
    _mPromptBg.hidden = YES;
    if ([[HCLogin standLog]isLog]) {
        HCSaleStatusViewController *saleStatus = [[HCSaleStatusViewController alloc]init];
       [HCAnalysis HCUserClick:@"mySaleVehicle"];
        [self.navigationController pushViewController:saleStatus animated:YES];
    }else{
        [self pushToLoginView:0];
    }
}


- (void)subMit
{
    [self pushViewcontroller];
}

- (void)mMyLoveCar:(UIButton*)get
{
   [self pushViewcontroller];
}

//提交电话后回调代理
- (void)submitTelephoneNum:(NSString *)errMge and:(NSString *)service
{
    _mPromptBg.hidden = NO;
    _saleInterface = [[Submit_SaleInterfaceView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) and:errMge and:service];
    _saleInterface.delegate = self;
    [_mPromptBg addSubview:_saleInterface];
}

//获取当前界面的数据
- (void)getViewData
{
    [BizSubmitTel getSaleDataByFinish:^(NSDictionary * data, NSInteger num) {
        if (num!=0) {
            self.telNum = @"400-696-8390";
            [self reloadViewdata];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"saleNum"]) {
                self.peopleNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"saleNum"];
                
            }else{
                self.peopleNum = @"19973";
            }
            [self.topView reloadViewData:self.telNum PeoNum:self.peopleNum coverurl:self.coverurl];
        }else{
            self.telNum = [data objectForKey:@"sell_phone"];
            self.coverurl = [data objectForKey:@"cover_img"];
            self.peopleNum = [[data objectForKey:@"seller_num"]stringValue];
            [[NSUserDefaults standardUserDefaults]setObject:self.peopleNum forKey:@"saleNum"];
            [self reloadViewdata];
            [self.topView reloadViewData:self.telNum PeoNum:self.peopleNum coverurl:self.coverurl];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setTitle:@"出售爱车"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
         [self getViewData];
    });
    [self creatBackButton];
    _mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 64)];
    _mNavView.labelText.text = self.title;
    _mNavView.hidden = YES;
    [self.view addSubview:self.mNavView];
    _mScrollView.delegate = self;
    _mScrollView.scrollEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = YES;
    _mScrollView.directionalLockEnabled = YES;
    _mScrollView.userInteractionEnabled = YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:@"CityChanged" object:nil];
    self.topView = [[HCtheSaleOftheCarView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT*0.63) peopleNum:self.peopleNum coverImage:self.coverurl phoneNum:self.telNum];
    self.topView.delegate = self;
    [self.mScrollView addSubview: self.topView];
    UIImageView *mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HCSCREEN_HEIGHT*0.63, HCSCREEN_WIDTH, HCSCREEN_WIDTH*4.35)];
    mImageView.image =[UIImage getImageFromLocalNamed:@"WAP-出售爱车1080_01" Type:@"jpg"];
    UITapGestureRecognizer *tapmImageView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    tapmImageView.delegate = self;
    [tapmImageView setNumberOfTapsRequired:1];
    mImageView.userInteractionEnabled = YES;
    [mImageView addGestureRecognizer:tapmImageView];
    [_mScrollView addSubview:mImageView];
    UIView *midview = [[UIView alloc]initWithFrame:CGRectMake(0, mImageView.bottom, HCSCREEN_WIDTH, 40)];
    midview.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
   // UIButton *writeInfo = [UIButton buttonWithFrame:CGRectZero title:@"填写出售信息" titleColor:PRICE_STY_CORLOR bgColor:nil titleFont:[UIFont systemFontOfSize:12] image:nil selectImage:nil target:self action:@selector(writeInfo) tag:0];
    UILabel *writeInfo = [UILabel labelWithFrame:CGRectZero text:@"填写出售信息" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    UITapGestureRecognizer *tapmwriteInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(writeInfo:)];
    writeInfo.userInteractionEnabled = YES;
    tapmwriteInfo.delegate = self;
    [tapmwriteInfo setNumberOfTapsRequired:1];
    [writeInfo addGestureRecognizer:tapmwriteInfo];
    [writeInfo sizeToFit];
    UILabel *midlabel = [UILabel labelWithFrame:CGRectZero text:@"或者直接咨询:" textColor:nil font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    [midlabel sizeToFit];
   
    self.midTel = [UILabel labelWithFrame:CGRectZero text:@"000-000-0000" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    self.midTel.userInteractionEnabled =  YES;
    [self.midTel sizeToFit];
    self.midTel.text = @"400-696-8390";
    UITapGestureRecognizer *tapmmidTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makePhoneCall:)];
    tapmmidTel.delegate = self;
    [tapmmidTel setNumberOfTapsRequired:1];
    [self.midTel addGestureRecognizer:tapmmidTel];
    writeInfo.frame = CGRectMake((HCSCREEN_WIDTH-midlabel.width-self.midTel.width-writeInfo.width)/2, 15, writeInfo.width, 22);
    midlabel.frame = CGRectMake(writeInfo.right, writeInfo.top, midlabel.width, 22);
    self.midTel.frame = CGRectMake(midlabel.right, writeInfo.top, self.midTel.width+3, 22);
    [midview addSubview:writeInfo];
    [midview addSubview:self.midTel];
    [midview addSubview:midlabel];
    
    [_mScrollView addSubview:midview];
    UIImageView *mImageViewPiture = [[UIImageView alloc]initWithFrame:CGRectMake(0, midview.bottom, HCSCREEN_WIDTH, HCSCREEN_WIDTH*1.42)];
    mImageViewPiture.image = [UIImage getImageFromLocalNamed:@"WAP-出售爱车1080_02" Type:@"jpg"];
    [_mScrollView addSubview:mImageViewPiture];
    
    [self createBottomView:mImageViewPiture.bottom];
    _mScrollView.contentSize = CGSizeMake(HCSCREEN_WIDTH,  self.topView.height+mImageView.height+49+mImageViewPiture.height+40);
    [self createMyNaView];
}

-(void)cityChanged:(NSNotification *)notify
{
    [self getViewData];
}

- (void)createBottomView:(CGFloat)y
{
    _bottomView = [[UIView alloc]init];
    _bottomView.userInteractionEnabled = YES;
    _bottomView.frame = CGRectMake(0, y, HCSCREEN_WIDTH, 49);
    [self.mScrollView addSubview:_bottomView];
   _leftLabel = [UILabel labelWithFrame:CGRectZero text:@"或者直接咨询: " textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] tag:0 hasShadow:0 isCenter:YES];
     [_leftLabel sizeToFit];
    self.bottomPhone = [UILabel labelWithFrame:CGRectZero text:@"000-000-0000" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    self.bottomPhone.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapbottomPhone = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makePhoneCall:)];
    tapbottomPhone.delegate = self;
    [tapbottomPhone setNumberOfTapsRequired:1];
    [self.bottomPhone addGestureRecognizer:tapbottomPhone];
    [self.bottomPhone sizeToFit];
    self.bottomPhone.text = @"400-696-8390";
    _leftLabel.frame = CGRectMake((HCSCREEN_WIDTH-_leftLabel.width-self.bottomPhone.width)/2, 15, _leftLabel.width+3, 22);
    self.bottomPhone.frame = CGRectMake(_leftLabel.right, 15, self.bottomPhone.width, 22);
    [_bottomView addSubview:self.bottomPhone];
   
    [_bottomView addSubview:_leftLabel];
}
- (void)writeInfo:(UITapGestureRecognizer*)ger
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.mScrollView setContentOffset:CGPointMake(0, -64)];
    }];
}

- (void)hideKeyboard:(UITapGestureRecognizer*)ger
{
    [self.topView.telTextFleld resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>HCSCREEN_HEIGHT*0.53) {
        [self.topView.telTextFleld resignFirstResponder]; 
    }
}

- (void)reloadViewdata
{
    self.midTel.text = self.telNum;
    self.bottomPhone.text = self.telNum;
}

- (void)makePhoneCall:(UITapGestureRecognizer*)ger{
    [HCAnalysis HCUserClick:@"VehicleSale_phone_click"];
    [UIAlertView popupAlertByDelegate:self title:self.telNum message:@"" cancel:@"取消" others:@"确定"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telNum]]];
    }
}

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.tabBarController.delegate  =self;
    [HCAnalysis controllerBegin:@"SellVehicleController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.topView.telTextFleld resignFirstResponder];
    _mNavView.hidden = NO;
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"SellVehicleController"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
