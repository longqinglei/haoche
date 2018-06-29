//
//  MyHaveSeenTheCarViewCell.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHaveSeenVehicle.h"
#import "OHAttributedLabel.h"
@interface MyHaveSeenTheCarViewCell : UITableViewCell<OHAttributedLabelDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSString *teleNum;
@property (weak, nonatomic) IBOutlet UILabel *textLabelie;

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *adressView;
@property (weak, nonatomic) IBOutlet UIView *commissionerView;
//@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *characterLabel;
@property (weak, nonatomic) IBOutlet UIButton *useCoupon;
@property (weak, nonatomic) IBOutlet UIImageView *vehicleImage;
@property (weak, nonatomic) IBOutlet UILabel *vehicleName;
@property (weak, nonatomic) IBOutlet UILabel *vehicleInfo;
@property (weak, nonatomic) IBOutlet UILabel *vehiclePrice;
@property (weak, nonatomic) IBOutlet UILabel *timeStr;
@property (weak, nonatomic) IBOutlet UILabel *addressStr;
@property (weak, nonatomic) IBOutlet UILabel *commissioner;
//@property (weak, nonatomic) IBOutlet UILabel *telephoneNum;
@property (weak, nonatomic) IBOutlet UILabel *statusStr;
@property (weak, nonatomic) IBOutlet UIButton *telephoneNum;
@property (weak, nonatomic) IBOutlet UIButton *servicePhone;
//@property (nonatomic)MyOrderStatus *myOrder;
@property (weak, nonatomic) IBOutlet UILabel *soldState;
@property (nonatomic)NSInteger mID;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
- (void)initCellWithRet :(MyHaveSeenVehicle *)coupon;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;


@end
