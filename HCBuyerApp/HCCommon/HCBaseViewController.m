//
//  HCBaseViewController.m
//  HCBey51
//
//  Created by 张熙 on 15/8/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCBaseViewController.h"
#import "UIImage+RTTint.h"
#import "VehicleDetailViewController.h"
#import "UserVisitRecordViewController.h"

#import "MyViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "LoginViewController.h"
#import "BizUser.h"
#import "User.h"

//static HCBaseViewController *baseView = nil;
@interface HCBaseViewController ()<UITabBarDelegate>

@end

@implementation HCBaseViewController

//+ (HCBaseViewController *)sharGet
//{
//    if (baseView == nil) {
//        baseView  =[[self alloc]init];
//    }
//  
//    return baseView;
//}

//-(BOOL)isLog
//{
//    
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hc_user_phone"]) {
//        return YES;
//    }else{
//        return NO;
//    }
////    UID;
////    User *user = [User getUserInfo];
////    if (uid  == 0) {
////        return NO;
////    }
////    if (user && user.userPhone && uid) {
////        return YES;
////    }else{
////        return NO;
////    }
//}


#pragma mark - Navigation bar
- (void)createNavImageView{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationController.navigationBar setBarTintColor:PAGE_STYLE_COLOR];
    }

    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

#pragma mark - Create title
- (void)addTitleViewWithTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
  //  titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:19];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - Return effect
- (void)onGoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Add text to the button
- (void)addItemWithImageName:(NSString *)imageName frame:(CGRect)frame selector:(SEL)selector location:(BOOL)isLeft {
    [self addItemWithImageName:imageName frame:frame title:nil  selector:selector location:isLeft];
}

#pragma mark - Add text to the button
- (void)addItemWithImageName:(NSString *)imageName frame:(CGRect)frame title:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  frame;
    button.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    if(HCSCREEN_WIDTH >320){
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }else{
        button.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    if (imageName!=nil) {
         [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (isLeft == YES){
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    }else {
         [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    }
}

#pragma mark - UIButton
- (UIButton*)createLocationButtionWithTitle:(NSString *)title selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(0, 0, 70, 40);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 55);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    if(HCSCREEN_WIDTH >320){
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }else{
        button.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    UIImage *img = [UIImage imageNamed:@"location"];
    img = [img rt_tintedImageWithColor:[UIColor blackColor]];
    [button setImage:img forState:UIControlStateNormal];
    return button;
}
- (UIButton *)setItemWithTitle:(NSString *)title selector:(SEL)selector{
    UIButton *button = [self createLocationButtionWithTitle:title selector:selector];
//    button.frame =  CGRectMake(0, 0, 80, 40);
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
//    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    UIImage *img = [UIImage imageNamed:@"location"];
//    img = [img rt_tintedImageWithColor:[UIColor blackColor]];
//    [button setImage:img forState:UIControlStateNormal];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    return button;
}

#pragma mark - UITableViewDataSource 子类需要重写此方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (void)creatBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =  CGRectMake(0, 0, 40, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:@"back"];
    img = [img rt_tintedImageWithColor:[UIColor blackColor]];
    [button setImage:img forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}


- (void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life cycle
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark - List interface
- (void)scanjmpsetList{
    //[HCAnalysis HCclick:@"list_record_click"];
    [self jumpToUserVisit];
}

- (void)viewDidLoad{
    [super viewDidLoad];

   // self.tabBarController.tabBar.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavImageView];
    
    _vehMTabelView = [[UITableView alloc] init];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColorFromRGBValue(0x424242),                                                                    NSFontAttributeName : [UIFont systemFontOfSize:18]};
    [self.view addSubview:_vehMTabelView];
}

#pragma mark - Browse record
//- (void)scanjmpsetHome{
//    [HCAnalysis HCClick:@"home_record_click" WithName:@"首页浏览记录点击"];
//    [HCAnalysis HCclick:@"home_record_click"];
//    [self jumpToUserVisit];
//}

- (void)jumpToUserVisit{//呆会添加plist文件的名称
    UserVisitRecordViewController *viewController = [[UserVisitRecordViewController alloc]init];
    viewController.title = @"浏览记录";
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - phone
-(void)consult:(UIButton*)sender
{
    if (sender.tag==1232) {
//        [TalkingDataAppCpa onCustEvent3];
         [HCAnalysis HCUserClick:@"compareDetail_consult_phone_click"];
    }else{
//        [TalkingDataAppCpa onCustEvent2];
        [HCAnalysis HCUserClick:@"mypage_consult_phone_click"];
    }
   
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006968390"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (UIButton *)createMyConsultBtn{
    UIImage *consultImg = [UIImage imageNamed:@"consult"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1232;
    button.frame =  CGRectMake(HCSCREEN_WIDTH - 10 - 70, 30, 70, 30);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [button setImage:consultImg forState:UIControlStateNormal];
    [button setTitle:@"咨询" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button.layer setCornerRadius:15.0f];
    [button addTarget:self action:@selector(consult:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
#pragma mark - method browsing records and jump
- (void)creatConsultBtn{
    UIImage *consultImg = [UIImage imageNamed:@"consult"];
    consultImg = [consultImg rt_tintedImageWithColor:[UIColor blackColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1233;
    button.frame =  CGRectMake(0, 0, 50, 40);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [button setImage:consultImg forState:UIControlStateNormal];
    [button setTitle:@"咨询" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(consult:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *consultItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:consultItem];
}

#pragma mark - Different access interface
//- (void)creatScan:(BOOL)isHome{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 80, 40);
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    if (isHome == YES)
//    {
//        [button addTarget:self action:@selector(scanjmpsetHome) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [button addTarget:self action:@selector(scanjmpsetList) forControlEvents:UIControlEventTouchUpInside];
//    }
//    [button setTitle:@"看过的车" forState:UIControlStateNormal];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
//}

#pragma mark - label
-(UILabel *)createMylabeWithText:(NSString *)text font:(UIFont *)myfont frame:(CGRect)frame touch:(BOOL)touch{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.frame = frame;
    label.userInteractionEnabled = touch;
    label.font = myfont;
    return label;
}
#pragma mark Button
- (UIButton *)createMyButtonWithTitle:(NSString *)title font:(UIFont *)font frame:(CGRect)frame action:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    [button.titleLabel setFont:font];
    return button;
}

- (UIImageView*)ImageViewFrame:(CGRect)frame imageName:(NSString*)imageName{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

- (void)pushToLoginView:(int)type{
    LoginViewController *viewController =  [[LoginViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.title = @"登 录";
    viewController.type = type;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self  pushToController:viewController];

}
- (void)pushToController:(UIViewController*)viewController{
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)pushToVehicelDetailandVehic:(Vehicle *)vehicle hadCom:(BOOL)isCmp vehicleChannel:(NSString*)channel
{
    VehicleDetailViewController *nextViewController = [[VehicleDetailViewController alloc]init];
    // nextViewController.vehicle = vehicle;
    nextViewController.source_id = vehicle.vehicle_id ;
    nextViewController.VehicleChannel = channel;
    //nextViewController.title = vehicle.detailTitle;
    nextViewController.hidesBottomBarWhenPushed = YES;
    nextViewController.url = [NSString stringWithFormat:DETAIL_URL, (long)vehicle.vehicle_id,(long)[BizUser getUserId],[BizUser getUserType]];
  //   [nextViewController setSharedBtnByContentTpye:0 sharedObj:vehicle];
    [nextViewController setVehicleCompareBtn];
    [self.navigationController pushViewController:nextViewController animated:YES];
}
- (void)showInfo:(NSString*)title type:(FVAlertType)type{
    [FVCustomAlertView showAlertOnView:self.view
                             withTitle:title
                            titleColor:[UIColor whiteColor]
                                 width:180.0
                                height:100.0
                       backgroundImage:nil
                       backgroundColor:[UIColor blackColor]
                          cornerRadius:10.0
                           shadowAlpha:0.1
                                 alpha:0.8
                           contentView:nil
                                  type:type];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    });
    
    
    
}
- (void)showSubSuccess{
        [FVCustomAlertView showSubVehicleSuccess:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    });
    
}
- (void)showMsg:(NSString *)title type:(FVAlertType)type
{
    [FVCustomAlertView showAlertOnView:self.view
                             withTitle:title
                            titleColor:[UIColor whiteColor]
                                 width:120.0
                                height:100.0
                       backgroundImage:nil
                       backgroundColor:[UIColor blackColor]
                          cornerRadius:10.0
                           shadowAlpha:0.1
                                 alpha:0.8
                           contentView:nil
                                  type:type];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    });
}

- (void)pushToHCSectWidth:(int)index{
    [self.tabBarController setSelectedIndex:1];
    NSString *indexStr = [NSString stringWithFormat:@"%d",index];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectUserVisit" object:indexStr];
    
}



@end
