//
//  subCellTableViewCell.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscriptionModelCar.h"

@interface subCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

 
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCar;
@property (weak, nonatomic) IBOutlet UILabel *subid;
@property (strong,nonatomic)UIImageView *selectBtn;


- (void)initCellWithRet :(SubscriptionModelCar *)coupon;

@end
