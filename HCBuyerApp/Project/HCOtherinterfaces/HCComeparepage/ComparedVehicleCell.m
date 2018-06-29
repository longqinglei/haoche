//
//  ComparedVehicleCell.m
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ComparedVehicleCell.h"
#import "ComparedVehicleCellContentView.h"


@interface ComparedVehicleCell()

@end

@implementation ComparedVehicleCell

-(id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.comparedContentView = [[ComparedVehicleCellContentView alloc] initWithFrame:frame data:vehicle];
        [self addSubview:self.comparedContentView];
        UIView *slashLine = [[UIView alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH * 0.13f, frame.size.height-0.5, frame.size.width, 0.5f)];
        slashLine.backgroundColor = ColorWithRGB(232, 232, 232);
        [self addSubview:slashLine];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setVehicleData:(Vehicle *)vehicle
{
    [self.comparedContentView setVehicleData:vehicle];
}

- (Vehicle *)getVehicle
{
    return [self.comparedContentView getVehicle];
}


- (NSString *)reuseIdentifier {
    return @"hc_compared_vehicle";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
