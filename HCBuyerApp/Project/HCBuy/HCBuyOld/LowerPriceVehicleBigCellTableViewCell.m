//
//  LowerPriceVehicleBigCellTableViewCell.m
//  HCBuyerApp
//
//  Created by wj on 15/6/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "LowerPriceVehicleBigCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

//图片布局之间的间隙
#define LPV_IMAGE_GAP 0.5f

#define LPV_CELL_BOTTOM_PADDING 5

//文本区域与左右边界的间隔
#define LPV_CELL_TEXT_REGION_PADDING (HCSCREEN_WIDTH * 0.03f)

//文件label的间隔
#define LPV_TITLE_MILES_GAP 4





@interface LowerPriceVehicleBigCellTableViewCell()

@property (strong, nonatomic) Vehicle *vehicle;

@property (strong, nonatomic) UILabel *lowlabel;
@property (strong, nonatomic) UILabel *otherlabel;
@property (strong, nonatomic) UILabel *thirdlabel;
@property (strong, nonatomic) UILabel *forthlabel;
@property (strong, nonatomic) UILabel *vehicleTitleLabel;
@property (strong, nonatomic) UILabel *vehicleTimeAndMilesLabel;
@property (strong, nonatomic) UILabel *vehiclePriceLabel;

@property (strong, nonatomic) UILabel *dealerPriceLabel;
@property (strong, nonatomic) UILabel *quotedPriceLabel;

@property (strong, nonatomic) UILabel *lowPriceLabel;
//@property (strong, nonatomic) UIImageView *lowPriceIcon;

@property (strong, nonatomic) UILabel *bottomLine;

@end

@implementation LowerPriceVehicleBigCellTableViewCell

- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat bigImgWidth = frame.size.width * 2 / 3.0f;
        CGFloat bigImgHeight = bigImgWidth * 3.0f / 4.0f;
        CGFloat smallImgWidth = frame.size.width / 3.0f;
        CGFloat smallImagHeight = smallImgWidth * 3.0f / 4.0f;
        
        self.leftBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bigImgWidth, bigImgHeight)];
        self.rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigImgWidth + LPV_IMAGE_GAP, 0, smallImgWidth - LPV_IMAGE_GAP, smallImagHeight - LPV_IMAGE_GAP / 2.0f)];
        self.rightBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigImgWidth + LPV_IMAGE_GAP, self.rightTopImageView.top + self.rightTopImageView.height + LPV_IMAGE_GAP, smallImgWidth - LPV_IMAGE_GAP, smallImagHeight - LPV_IMAGE_GAP / 2.0f)];
        
        CGFloat textRegionWidth = (frame.size.width - 2 * LPV_CELL_TEXT_REGION_PADDING) * 4.0f / 5.0f;
        self.vehicleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LPV_CELL_TEXT_REGION_PADDING, self.leftBigImageView.top + self.leftBigImageView.height + LPV_CELL_TEXT_REGION_PADDING, textRegionWidth, 18)];
        self.vehicleTitleLabel.font = [UIFont systemFontOfSize:15];
        self.vehicleTitleLabel.textColor = [UIColor blackColor];
        self.vehicleTimeAndMilesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.vehicleTitleLabel.left, self.vehicleTitleLabel.top + self.vehicleTitleLabel.height + LPV_TITLE_MILES_GAP, textRegionWidth, 18)];
        self.vehicleTimeAndMilesLabel.font = [UIFont systemFontOfSize:12];
        self.vehicleTimeAndMilesLabel.textColor =[UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        self.vehiclePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.vehicleTimeAndMilesLabel.left, self.vehicleTimeAndMilesLabel.bottom+3 + LPV_TITLE_MILES_GAP, 90, 22)];
        
        //self.lowPriceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.8*HCSCREEN_WIDTH-15+ 10, self.vehiclePriceLabel.top+3, HCSCREEN_WIDTH*0.18, HCSCREEN_WIDTH*0.05)];
      //  [self.lowPriceIcon setImage:[UIImage imageNamed:@"low_price_pic"]];
       // self.lowPriceIcon.center = CGPointMake(self.lowPriceIcon.center.x, self.vehiclePriceLabel.center.y);
        self.lowlabel =[self createlabelbyframe:CGRectMake(self.vehiclePriceLabel.right+5, self.vehiclePriceLabel.top, 52, 22)];
        self.otherlabel = [self createlabelbyframe:CGRectMake(self.lowlabel.right+5, self.vehiclePriceLabel.top, 52, 22)];
        self.thirdlabel = [self createlabelbyframe:CGRectMake(self.otherlabel.right+5, self.vehiclePriceLabel.top, 52, 22)];
        self.forthlabel = [self createlabelbyframe:CGRectMake(self.thirdlabel.right+5, self.vehiclePriceLabel.top, 52, 22)];
        [self setVehicleData:self.vehicle];
//
//        CGFloat lowPriceViewWidth = frame.size.width - 2 * LPV_CELL_TEXT_REGION_PADDING - textRegionWidth;
//        UIImageView *lowPriceView = [[UIImageView alloc] initWithFrame:CGRectMake(LPV_CELL_TEXT_REGION_PADDING + textRegionWidth, self.vehicleTitleLabel.top + self.vehicleTitleLabel.height + LPV_TITLE_MILES_GAP, lowPriceViewWidth, lowPriceViewWidth / 2.0f)];
//        [lowPriceView setImage:[UIImage imageNamed:@"low_price"]];
//        CGFloat lowPriceLabelHeight = lowPriceView.frame.size.height - 10;
//        UILabel *lowPriceTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(lowPriceView.left + lowPriceView.width * 2.0f/ 12.0f, lowPriceView.top + 5, lowPriceView.width * 10.0f / 12.0f, lowPriceLabelHeight / 2)];
//        lowPriceTipsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:9];
//        if (HCSCREEN_WIDTH <= 320) {
//            lowPriceTipsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
//        }
//        lowPriceTipsLabel.text = UsedLow;
//        [lowPriceTipsLabel setTextAlignment:NSTextAlignmentCenter];


        if (!self.bottomLine) {
            self.bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - LPV_CELL_BOTTOM_PADDING, frame.size.width, LPV_CELL_BOTTOM_PADDING)];
            self.bottomLine.backgroundColor = MTABLEBACK;
        }
        [self addSubview:self.leftBigImageView];
      //  [self addSubview:self.lowPriceIcon];
        [self addSubview:self.rightTopImageView];
        [self addSubview:self.rightBottomImageView];
        [self addSubview:self.vehicleTitleLabel];
        [self addSubview:self.vehicleTimeAndMilesLabel];
        [self addSubview:self.vehiclePriceLabel];
        [self addSubview:self.bottomLine];
        
        [self setVehicleData:vehicle];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UILabel*)createlabelbyframe:(CGRect)frame{
    UILabel *label =[[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor =UIColorFromRGBValue(0xff2626);
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = frame;
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(label.bounds, 0, 0) cornerRadius:1.0];
    CAShapeLayer *sublayer = [CAShapeLayer layer];
    sublayer.cornerRadius = 1;
    sublayer.path = bPath.CGPath;
    sublayer.strokeColor = UIColorFromRGBValue(0xff2626).CGColor;
    sublayer.fillColor = [UIColor clearColor].CGColor;
    sublayer.lineWidth = 0.5;
    [label.layer addSublayer:sublayer];
    return label;
}


- (NSMutableAttributedString*)setcityText:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSInteger length = mStr.length ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    [str addAttribute:NSForegroundColorAttributeName value: UIColorFromRGBValue(0x212121) range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR  range:NSMakeRange(1, 2)];
    [str addAttribute:NSForegroundColorAttributeName value: UIColorFromRGBValue(0x212121) range:NSMakeRange(3,length-3)];
    return str;
}
- (void)setVehicleData:(Vehicle *)vehicle
{
    self.vehicle = vehicle;
    if ([self.vehicle.coverImgUrls count] >=3 ) {
        [self.leftBigImageView sd_setImageWithURL:[self.vehicle.coverImgUrls HCObjectAtIndex:0]placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
        [self.rightTopImageView sd_setImageWithURL:[self.vehicle.coverImgUrls HCObjectAtIndex:1] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
        [self.rightBottomImageView sd_setImageWithURL:[self.vehicle.coverImgUrls HCObjectAtIndex:2]placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    }else{
        [self.leftBigImageView setImage:[UIImage imageNamed:@"default_vehicle"]];
        [self.rightTopImageView setImage:[UIImage imageNamed:@"default_vehicle"]];
        [self.rightBottomImageView setImage:[UIImage imageNamed:@"default_vehicle"]];
    }
    
    
    //添加车款名称
    self.vehicleTitleLabel.text = vehicle.vehicle_name;
    if ([vehicle.vehicle_name hasPrefix:@"["]) {
        self.vehicleTitleLabel.attributedText = [self setcityText:vehicle.vehicle_name];
    }
   
    
    //添加上牌时间和行驶里程
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:vehicle.registerDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM"];
    self.vehicleTimeAndMilesLabel.text = [NSString stringWithFormat:@"%@上牌・%@万公里・%@",
                                          [formatter stringFromDate:confromTimesp], vehicle.strMiles, vehicle.geerbox];
    
    //添加价格信息
    NSString *priceText = [NSString stringWithFormat:@"%@万", vehicle.seller_price];
   // NSInteger priceLength = [priceText length] - 1;
    self.vehiclePriceLabel.attributedText = [NSString setPriceText:priceText];
    if (vehicle.labelArray.count==0) {
        [self.lowlabel removeFromSuperview];
        [self.otherlabel removeFromSuperview];
        [self.thirdlabel removeFromSuperview];
        [self.forthlabel removeFromSuperview];
    }else{
        if (vehicle.labelArray.count==1) {
            self.lowlabel.text = [vehicle.labelArray HCObjectAtIndex:0];
            [self.contentView addSubview:self.lowlabel];
            [self.otherlabel removeFromSuperview];
            [self.thirdlabel removeFromSuperview];
            [self.forthlabel removeFromSuperview];
        }else{
            if (vehicle.labelArray.count==2) {
                [self.thirdlabel removeFromSuperview];
                [self.forthlabel removeFromSuperview];
            }else if(vehicle.labelArray.count==3){
                self.thirdlabel.text = [vehicle.labelArray HCObjectAtIndex:2];
                [self.contentView addSubview:self.thirdlabel];
                [self.forthlabel removeFromSuperview];
            }else if(vehicle.labelArray.count==4){
                if (HCSCREEN_WIDTH>320) {
                    self.forthlabel.text = [vehicle.labelArray HCObjectAtIndex:3];
                    [self.contentView addSubview:self.forthlabel];
                }
                self.thirdlabel.text = [vehicle.labelArray HCObjectAtIndex:2];
                [self.contentView addSubview:self.thirdlabel];
            }
            self.otherlabel.text = [vehicle.labelArray HCObjectAtIndex:1];
            [self.contentView addSubview:self.otherlabel];
            self.lowlabel.text = [vehicle.labelArray HCObjectAtIndex:0];
            [self.contentView addSubview:self.lowlabel];
            
        }
        
    }


}

-(void)setSeperator:(BOOL)isNeed
{
    if (isNeed) {
        if (self.bottomLine.superview != self) {
            [self addSubview:self.bottomLine];
        }
    } else {
        if (self.bottomLine.superview == self) {
            [self.bottomLine removeFromSuperview];
        }
    }
}

- (NSString *)reuseIdentifier {
    return @"hc_low_price_vehicle_big_cell";
}

- (Vehicle *)getVehicle
{
    return _vehicle;
}


@end
