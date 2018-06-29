//
//  CouponListViewControllerCell.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
@interface CouponListViewControllerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mViewBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStact;
@property (weak, nonatomic) IBOutlet UILabel *writtenWordslabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellview;
@property (nonatomic,strong)NSString *strUrl;

- (void)initCellWith:(Coupon*)coupon;

@end
