//
//  VehiceSaleConsultationCell.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehiceSaleConsultationCell.h"

@implementation VehiceSaleConsultationCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_mViewPoint.layer setCornerRadius:5.0];
    [_mViewPoint.layer setMasksToBounds:YES];
//    [_mViewPoint.layer setBorderWidth:1.0];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
