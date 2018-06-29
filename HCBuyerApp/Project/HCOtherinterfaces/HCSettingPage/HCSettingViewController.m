//
//  HCSettingViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/8/3.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCSettingViewController.h"
#import "UIImage+RTTint.h"
#import "User.h"
#import "NavView.h"
#import "UMFeedback.h"
#import "UIAlertView+ITTAdditions.h"
#import "SensorsAnalyticsSDK.h"
@interface HCSettingViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NavView * mNavView;
@property (nonatomic, strong) NSArray * array;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) UIButton * myNewLabelBtn;

@property (nonatomic)BOOL isFeedbackNew;

@end

@implementation HCSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    [HCAnalysis controllerBegin:@"settingPage"];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: animated];
    [HCAnalysis controllerEnd:@"settingPage"];
}

- (UIButton *)button:(UIButton *)btn
{
    btn = [[UIButton alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH - 60, 29 / 2, 25, 15)];
    btn.backgroundColor= PRICE_STY_CORLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
    [btn.layer setCornerRadius:7.5];
    [btn.layer setMasksToBounds:YES];
    return btn;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isFeedbackNew = NO;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.view.backgroundColor =[UIColor colorWithRed:0.96f green:0.95f blue:0.95f alpha:1.00f];
    _dataArr = [NSArray arrayWithObjects:@"意见反馈",@"评价我们", nil];
    _array = [NSArray arrayWithObjects:@"",@"给好车无忧点赞",version, nil];
    [self dataView];
    [self createButton];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self syscSeverData];
}

- (void)setFeedbackNew
{
    self.myNewLabelBtn = [self button:self.myNewLabelBtn];
    UIButton *but  = (UIButton*)[self.view viewWithTag:100];
    [but addSubview:self.myNewLabelBtn];
    [self.myNewLabelBtn setTitle:@"新" forState:UIControlStateNormal];
    self.isFeedbackNew = YES;
}

- (void)setFeedbackReaded
{
    [self.myNewLabelBtn removeFromSuperview];
    self.isFeedbackNew = NO;
}

- (void)syscSeverData
{
    [[UMFeedback sharedInstance] get:^(NSError *error)
     {
         if (error == nil) {
             NSMutableArray *array = [UMFeedback sharedInstance].theNewReplies;
             if ([array count] > 0) {
                 NSDictionary *dataDic = [array HCObjectAtIndex:[array count] - 1];
                 NSInteger createTime = [[dataDic objectForKey:@"created_at"] integerValue];
                 NSInteger lastTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"HC_Feedback_Lasttime"];
                 if (lastTime < createTime) {
                     lastTime = createTime;
                     [[NSUserDefaults standardUserDefaults] setInteger:lastTime forKey:@"HC_Feedback_Lasttime"];
                     [self setFeedbackNew];
                 }
             }
         }
     }];
}

- (void)createButton
{
    for (int i= 0; i<_dataArr.count; i++) {
        UIButton *button = [UIButton buttonWithFrame:CGRectMake(0, 10+i*44, HCSCREEN_WIDTH, 44) title:nil titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor] titleFont:nil image:nil selectImage:nil target:self action:@selector(buttonClick:) tag:i+100];
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.frame = CGRectMake(10, 0, 90, 44);
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textColor = UIColorFromRGBValue(0x424242);
        leftLabel.text =[_dataArr HCObjectAtIndex:i];
        [button addSubview:leftLabel];
        [button addSubview:[self createlinelabel:0]];
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.frame= CGRectMake(HCSCREEN_WIDTH-140, 0, 110, 44);
        rightLabel.text = [_array HCObjectAtIndex:i];
        rightLabel.textColor = [UIColor lightGrayColor];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:14];
         [button addSubview:rightLabel];
        if (i!=2) {
            UIImageView *image = [[UIImageView alloc]init];
            image.frame = CGRectMake(HCSCREEN_WIDTH-20, 15, 8, 14);
            UIImage *img = [UIImage imageNamed:@"openImage"];
            image.image = img;
            [button addSubview:image];
        }
        
        if (i ==_dataArr.count-1) {
            [button addSubview:[self createlinelabel:44]];
        }
        [self.view addSubview:button];
    }
}

- (UILabel*)createlinelabel:(CGFloat)y
{
    UILabel *linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, HCSCREEN_WIDTH, 0.5)];
    linelabel.backgroundColor = [UIColor colorWithRed:0.90f green:0.89f blue:0.89f alpha:1.00f];
    return linelabel;
}

- (void)buttonClick:(UIButton*)sender
{
    if (sender.tag == 100) {
        [self setFeedbackReaded];
        [self feedback];
    }else if (sender.tag == 101){
        [self openAppstore:@"946843913"];
    }else if(sender.tag == 102){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)feedback
{
    [HCAnalysis HCUserClick:@"my_feedback_submit"];
     [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"反馈"}];
    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
}

- (void)openAppstore:(NSString*)appid
{
    [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"评价"}];
    NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (void)mExitSign
{
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, _dataArr.count*44+20, HCSCREEN_WIDTH, 44);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor whiteColor]];
    [logoutBtn.layer setCornerRadius:3.0f];
    [logoutBtn addSubview:[self createlinelabel:0]];
    [logoutBtn addSubview:[self createlinelabel:44]];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

- (void)logout:(UIButton *)btn
{
     [HCAnalysis HCclick:@"MyPageClick" WithProperties:@{@"BtnName":@"退出登录"}];
    [UIAlertView popupAlertByDelegate:self title:@"确定退出" message:@"" cancel:@"取消" others:@"确定"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([[HCLogin standLog] isLog]) {
            [User addUserPhone:nil];
            //[[[SensorsAnalyticsSDK sharedInstance] people] unset:@"MobliePhone"];
            [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsLogin" :@"false"}];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDefaultsUid"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hc_user_phone"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil userInfo:nil];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"checkCoupon"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"myhaveSeen"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"subNum"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"recordNum"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"couponNum"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - Public
- (void)dataView
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _mNavView = [[NavView alloc]initWithFrame:CGRectMake(0, -64, HCSCREEN_WIDTH, 64)];
    _mNavView.labelText.text = @"设置";
    [self.view addSubview:self.mNavView];
    [self creatBackButton];
    if ([[HCLogin standLog]isLog]) {
       [self mExitSign];
    }
    
}

@end
