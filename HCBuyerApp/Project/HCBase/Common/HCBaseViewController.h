//
//  HCBaseViewController.h
//  HCBey51
//
//  Created by 张熙 on 15/8/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Vehicle.h"
#import "FVCustomAlertView.h"

@interface HCBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITabBarControllerDelegate>

@property (strong,nonatomic)UITableView *vehMTabelView;



//+ (HCBaseViewController *)sharGet;

//-(BOOL)isLog;
- (void)showInfo:(NSString*)title type:(FVAlertType)type;

- (void)addTitleViewWithTitle:(NSString *)title;

- (void)showMsg:(NSString *)title type:(FVAlertType)type;

- (void)addItemWithImageName:(NSString *)imageName frame:(CGRect)frame selector:(SEL)selector location:(BOOL)isLeft;

- (void)addItemWithImageName:(NSString *)imageName frame:(CGRect)frame title:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft ;

- (UIButton *)setItemWithTitle:(NSString *)title selector:(SEL)selector;

- (UILabel* )createMylabeWithText:(NSString *)text font:(UIFont*)myfont frame:(CGRect)frame touch:(BOOL)touch;

- (UIButton*)createMyButtonWithTitle:(NSString *)title font:(UIFont *)font frame:(CGRect)frame action:(SEL)selector;

- (void)creatBackButton;

//- (void)creatScan:(BOOL)isHome;

- (void)creatConsultBtn;

- (UIButton*)createMyConsultBtn;

- (UIImageView*)ImageViewFrame:(CGRect)frame imageName:(NSString*)imageName;

- (void)pushToLoginView:(int)type;

- (void)pushToVehicelDetailandVehic:(Vehicle *)vehicle hadCom:(BOOL)isCmp vehicleChannel:(NSString*)channel;

- (UIButton*)createLocationButtionWithTitle:(NSString *)title selector:(SEL)selector;

- (void)pushToHCSectWidth:(int)index;

- (void)showSubSuccess;



@end
