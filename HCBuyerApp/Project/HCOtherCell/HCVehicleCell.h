//
//  HCVehicleCell.h
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@interface HCVehicleCell : UITableViewCell

@property (strong, nonatomic) Vehicle *vehicle;

@property (nonatomic) NSInteger selectcityid;
@property (strong, nonatomic) UILabel *vehicleTitleLabel;

//2018-06-19 添加
//@property (strong, nonatomic) UILabel *vehicleTimeAndMilesLabel; //上牌,里程,变速箱
@property (strong, nonatomic) UILabel *vehicleTimeLabel; //上牌
@property (strong, nonatomic) UILabel *vehicleMilesLabel; //里程
@property (strong, nonatomic) UIImageView *hotImg;//hot标签
@property (nonatomic, strong) UILabel *reducePriceLabel;//降价

@property (strong, nonatomic) UILabel *vehiclePriceLabel;
@property (strong, nonatomic) UILabel *benifitInfoLabel;
@property (strong, nonatomic) UIImageView *subsidyImgView;
@property (strong, nonatomic) UIImageView *soldImageView;
@property (strong, nonatomic) UIView *mView;
@property (strong, nonatomic) UILabel *cityLabel;
@property (strong, nonatomic) UIImageView *lowImageView;//超值
@property (strong, nonatomic) UILabel *shoufuLabel;
@property (strong, nonatomic) UIImageView *lowPriceIcon;
@property (strong, nonatomic) UILabel *lowlabel;
@property (strong, nonatomic) UILabel *otherlabel;
@property (strong, nonatomic) UIImageView *left_top;
@property (strong, nonatomic) UIImageView *left_bottom;
@property (strong, nonatomic) UIImageView *right_top;
@property (strong, nonatomic) UIImageView *right_bottom;
@property (strong, nonatomic) UIImageView *zhiyingdian;
@property (strong, nonatomic) UIImageView *zhibao;
@property (strong, nonatomic) UIImageView *activitiView;
@property (strong, nonatomic) UILabel *fenqiLabel;
@property (strong, nonatomic) UILabel *qianggouLabel;
@property (strong, nonatomic) UILabel *bottomLine;
@property (strong, nonatomic) UIView *slashLine ;
//倒计时 天,时,分,秒
@property (strong, nonatomic) NSString *remainDay;
@property (strong, nonatomic) NSString *remainHour;
@property (strong, nonatomic) NSString *remainMin;
@property (strong, nonatomic) NSString *remainSec;
//倒计时显示
@property (strong, nonatomic) UILabel *firstLabel;

@property (strong, nonatomic) UILabel *secondLabel;

@property (strong, nonatomic) UILabel *thirdLabel;

@property (strong, nonatomic) UILabel *fourthLabel;

@property (strong, nonatomic) UILabel *fivthLabel;

- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle;

@property (strong, nonatomic) UIImageView *vehicleImageView;

@property (strong, nonatomic) UIImageView *presellView;
- (void)setVehicleData:(Vehicle *)vehicle;

- (Vehicle *)getVehicle;

@property (nonatomic)NSInteger vehicle_source_id;

- (CAShapeLayer*)createLayer:(CGRect)frame;
- (NSMutableAttributedString*)setcityText:(NSString*)mStr;
//- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
- (void)changeTime:(NSInteger)endTimeStamp;
- (BOOL)endTime:(Vehicle*)vehicle;

- (void)endtimeHide;
@end
