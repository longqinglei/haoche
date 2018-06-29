//
//  CouponListViewControllerCell.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "CouponListViewControllerCell.h"
#import "Coupon.h"
@implementation CouponListViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_mViewBack.layer setCornerRadius:6.0];
    [_mViewBack.layer setMasksToBounds:YES];
    [_mViewBack.layer setBorderWidth:0.1];
}

- (void)initCellWith:(Coupon*)coupon{  
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
    self.strUrl = coupon.url;
    self.timelabel.text = [NSString stringWithFormat:@"有效期:%@-%@",startTime,expireTime];
    
    
    NSString*string;
    if ([coupon.couponTitle length] > 8) {
     string = [coupon.couponTitle substringToIndex:7];
      self.writtenWordslabel.text = [NSString stringWithFormat:@"%@...",string];
    }else{
    self.writtenWordslabel.text = coupon.couponTitle;
    }
    self.priceLabel.text = coupon.cashValue;
    
    if (coupon.status==0) {
        if (nowTime - coupon.endTime > 0){
            self.imageViewStact.hidden = NO;
            self.imageViewStact.image = [UIImage imageNamed:@"invalid_icon"];
            self.cellview.image = [UIImage imageNamed:@"curve"];
        }else{
            self.imageViewStact.hidden = YES;
            self.cellview.image = [UIImage imageNamed:@"curveClock"];
        }
    }else{
        self.imageViewStact.hidden = NO;
        self.imageViewStact.image = [UIImage imageNamed:@"haveUse"];
        self.cellview.image = [UIImage imageNamed:@"curve"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
