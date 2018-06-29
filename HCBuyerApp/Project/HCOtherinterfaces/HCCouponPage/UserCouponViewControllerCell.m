//
//  CouponListViewControllerCell.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "UserCouponViewControllerCell.h"

@implementation UserCouponViewControllerCell

- (void)awakeFromNib {
    [_mViewBack.layer setCornerRadius:6.0];
    [_mViewBack.layer setMasksToBounds:YES];
    [_mViewBack.layer setBorderWidth:0.1];
    [super awakeFromNib];
}

- (void)initCellWith:(Coupon*)coupon
{
    
    self.coupon_id = coupon.couponId;
    self.trans_id = coupon.enumId;
    self.strURL = coupon.url;
    
    NSInteger  nowTime;
    nowTime = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSString *startTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:coupon.startTime]];
    NSString *expireTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:coupon.endTime]];
    self.timelabel.text = [NSString stringWithFormat:@"有效期:%@-%@",startTime,expireTime];

    //self.writtenWordslabel.text = coupon.couponTitle;

    
    
    NSString*string;
    if ([coupon.couponTitle length] > 8) {
        string = [coupon.couponTitle substringToIndex:7];
        self.writtenWordslabel.text = [NSString stringWithFormat:@"%@...",string];
    }else{
        self.writtenWordslabel.text = coupon.couponTitle;
    }
    

    self.priceLabel.text = coupon.cashValue;
    if (coupon.status ==1) {
        self.cellView.image = [UIImage imageNamed:@"curve"];
        self.imageViewStact.hidden = YES;
    }else if(coupon.status == 2){
        self.imageViewStact.image = [UIImage imageNamed:@""];
        self.cellView.image = [UIImage imageNamed:@"curve"];
    }else{
        self.imageViewStact.hidden = YES;
        self.cellView.image = [UIImage imageNamed:@"curveClock"];
    }
    if (nowTime - coupon.endTime<=0) {
        self.imageViewStact.image = [UIImage imageNamed:@"invalid_icon"];
        self.cellView.image = [UIImage imageNamed:@"curveClock"];
    }
    
}

- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        _imageBtnclick.image = [UIImage imageNamed:@"ImageAddSeber"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        _imageBtnclick.image = [UIImage imageNamed:@"clickthepicture"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    _m_checked = checked;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
