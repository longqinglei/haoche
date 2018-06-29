//
//  ComparedVehicleCellContentView.m
//  HCBuyerApp
//
//  Created by wj on 15/7/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ComparedVehicleCellContentView.h"
#import "UIImageView+AFNetworking.h"
#ifndef HC_VEHICLE_CELL_HEIGHT_PADDING
#define HC_VEHICLE_CELL_HEIGHT_PADDING 0.25
#endif

#ifndef HC_VEHICLE_CELL_WIDTH_PADDING
#define HC_VEHICLE_CELL_WIDTH_PADDING 0
#endif

#ifndef HC_VEHICLE_CELL_TEXT_REGION_PADDING
//文本区域与图片区域的间隔
#define HC_VEHICLE_CELL_TEXT_REGION_PADDING (HCSCREEN_WIDTH * 0.03f)
#endif

#ifndef HC_VEHICLE_TITLE_MILES_GAP
//标题跟里程label的间隔
#define HC_VEHICLE_TITLE_MILES_GAP 4
#endif

@interface ComparedVehicleCellContentView()

@property (strong, nonatomic) Vehicle *vehicle;
@property (strong, nonatomic) UIImageView *vehicleImageView;

@property (strong, nonatomic) UILabel *vehicleTitleLabel;
@property (strong, nonatomic) UILabel *vehicleTimeAndMilesLabel;
@property (strong, nonatomic) UILabel *vehiclePriceLabel;
@property (strong, nonatomic) UIImageView *soldImageView;
@property (strong, nonatomic) UIButton *selectBtn;

@end

@implementation ComparedVehicleCellContentView


-(id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vehicle = vehicle;
        
        CGRect selectBtnFrame = CGRectMake(0, 0, HCSCREEN_WIDTH * 0.13, frame.size.height);
        
        self.selectBtn = [UIButton buttonWithFrame:selectBtnFrame title:nil titleColor:nil bgColor:nil titleFont:nil image:[UIImage imageNamed:@"clickthepicture"] selectImage:[UIImage imageNamed:@"ImageAddSeber"] target:self action:@selector(selectComparedVehicle:) tag:0];
        [self addSubview:self.selectBtn];
        
        //初始化视图位置
        CGFloat imageHeight = HCSCREEN_WIDTH*0.27;
        CGFloat imageWidth = HCSCREEN_WIDTH * 0.36;//图片宽高比为4:3
        self.vehicleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectBtn.right ,(HC_VEHICLE_LIST_ROW_HEIGHT+5- HCSCREEN_WIDTH*0.27f)/2, imageWidth, imageHeight)];
        //文本区域大小
        CGFloat textRegionX = self.vehicleImageView.right + HC_VEHICLE_CELL_TEXT_REGION_PADDING;
        CGFloat textRegionY = self.vehicleImageView.top ;
        CGFloat textRegionWidth = frame.size.width - 2 * HC_VEHICLE_CELL_WIDTH_PADDING - self.selectBtn.width - imageWidth - HC_VEHICLE_CELL_TEXT_REGION_PADDING * 2;
        //CGFloat textRegionHeight = frame.size.height - 2 * HC_VEHICLE_CELL_HEIGHT_PADDING - 8;
        
        //此区域可动态改变
        self.vehicleTitleLabel = [UILabel labelWithFrame:CGRectMake(textRegionX, textRegionY, textRegionWidth, 18) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] tag:0 hasShadow:NO isCenter:NO];
        self.vehicleTimeAndMilesLabel = [UILabel labelWithFrame:CGRectMake(textRegionX, textRegionY + self.vehicleTitleLabel.height + HC_VEHICLE_TITLE_MILES_GAP, textRegionWidth, 18) text:nil textColor:ColorWithRGB(102, 102, 102) font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:NO];
        //CGFloat left2Bottom = 10;
        CGFloat vehiclePriceHeight = 22;
        self.vehiclePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(textRegionX, self.vehicleImageView.bottom-vehiclePriceHeight, 100, vehiclePriceHeight)];
        CGFloat soldImgWidth = HCSCREEN_WIDTH * 0.156f;
        self.soldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - HCSCREEN_WIDTH * 0.03 - soldImgWidth, frame.size.height - HCSCREEN_WIDTH * 0.03 - soldImgWidth, soldImgWidth, soldImgWidth)];
        self.soldImageView.image = [UIImage imageNamed:@"sold_icon"];
        [self addSubview:self.vehicleImageView];
        [self addSubview:self.vehiclePriceLabel];
        [self addSubview:self.vehicleTimeAndMilesLabel];
        [self addSubview:self.vehicleTitleLabel];
        if (self.vehicle != nil) {
            [self setVehicleData:self.vehicle];
        }
    }
    return self;
}

- (Vehicle *)getVehicle
{
    return _vehicle;
}


-(void)selectComparedVehicle:(id)sender
{
    NSLog(@"selected");
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        //如果是选中态，则通知主视图
        if (self.delegate) {
            [self.delegate selectedVehicle:self.vehicle];
        }
    } else {
        if (self.delegate) {
            [self.delegate unselectVehicle:self.vehicle];
        }
    }
}

- (void)setSelectedBtnSelectedAndDisable
{
    [self.selectBtn setImage:[UIImage imageNamed:@"ImageAddSeber"] forState:UIControlStateDisabled];
    [self.selectBtn setEnabled:NO];
}

- (void)setVehicleData:(Vehicle *)vehicle
{
    self.vehicle = vehicle;
    
    if (vehicle.isSelectedForCompare) {
        [self.selectBtn setSelected:YES];
    } else {
        [self.selectBtn setSelected:NO];
    }
    //先设置为默认图片，避免reused时候切换体验不佳
    //[self.vehicleImageView setImage:[UIImage imageNamed:@"default_vehicle.jpg"]];
    //添加图片
    [self.vehicleImageView setImageWithURL:[NSURL URLWithString:vehicle.cover_pic] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    //添加车款名称
    self.vehicleTitleLabel.text = vehicle.vehicle_name;
    //自适应高度
    //[self.vehicleTitleLabel sizeToFit];
    
    //NSLog(@"label height : %f", self.vehicleTitleLabel.frame.size.height);
    
    //添加上牌时间和行驶里程
    //NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:vehicle.registerDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM"];
    self.vehicleTimeAndMilesLabel.text = [NSString stringWithFormat:@"%@上牌・%@万公里",
                                          vehicle.register_time, vehicle.miles];
    //高度根据 vehicleTitleLabel 的高度变化
    CGRect labelFrame = self.vehicleTimeAndMilesLabel.frame;
    labelFrame.origin.y = self.vehicleTitleLabel.top + self.vehicleTitleLabel.height + HC_VEHICLE_TITLE_MILES_GAP;
    self.vehicleTimeAndMilesLabel.frame = labelFrame;
    
    //添加价格信息
    NSString *priceText = [NSString stringWithFormat:@"¥ %@万", vehicle.seller_price];

    self.vehiclePriceLabel.attributedText = [NSString setPriceText:priceText];
    
    if (vehicle.status == 1) {
        
        [self.soldImageView removeFromSuperview];
        
    } else {
        if (self.soldImageView.superview != self) {
            [self addSubview:self.soldImageView];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
