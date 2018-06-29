//
//  CouponListViewControllerCell.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
@interface UserCouponViewControllerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mViewBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStact;
@property (weak, nonatomic) IBOutlet UILabel *writtenWordslabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *imageBtnclick;
@property (nonatomic,strong)NSString *strURL;
@property (nonatomic,strong)NSString *coupon_id;
@property (nonatomic)NSInteger trans_id;
@property (nonatomic)  BOOL	m_checked;
- (void)initCellWith:(Coupon*)coupon;
- (void)setChecked:(BOOL)checked;
@end
