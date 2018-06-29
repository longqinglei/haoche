//
//  HCVehicleCell.m
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCVehicleCell.h"
#import "BizCity.h"
#import "UIImageView+WebCache.h"

#import "SDImageCache.h"
#import "UIImageView+AFNetworking.h"

#define HC_VEHICLE_CELL_HEIGHT_PADDING 0.25
#define HC_VEHICLE_CELL_WIDTH_PADDING 15

//文本区域与图片区域的间隔
#define HC_VEHICLE_CELL_TEXT_REGION_PADDING (HCSCREEN_WIDTH * 0.03f)

//标题跟里程label的间隔
#define HC_VEHICLE_TITLE_MILES_GAP 10

//@interface HCVehicleCell()
//
//@property (strong, nonatomic) Vehicle *vehicle;
//
//@property (nonatomic) NSInteger selectcityid;
//@property (strong, nonatomic) UILabel *vehicleTitleLabel;
//@property (strong, nonatomic) UILabel *vehicleTimeAndMilesLabel;
//@property (strong, nonatomic) UILabel *vehiclePriceLabel;
//@property (strong, nonatomic) UILabel *benifitInfoLabel;
//@property (strong, nonatomic) UIImageView *subsidyImgView;
//@property (strong, nonatomic) UIImageView *soldImageView;
//@property (strong,nonatomic)UIView *mView;
//@property (strong,nonatomic)UILabel *cityLabel;
//@property (strong, nonatomic) UIImageView *lowPriceIcon;
//@property (strong, nonatomic) UILabel *lowlabel;
//@property (strong, nonatomic) UILabel *otherlabel;
//
//
//@end

@implementation HCVehicleCell


- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vehicle = vehicle;
        CGFloat imageHeight = HCSCREEN_WIDTH*0.27;
        CGFloat imageWidth = HCSCREEN_WIDTH * 0.36;
        CGFloat left_top_width = 0.0;
        CGFloat left_bottom_width=0.0 ;
        CGFloat lowWidth= HCSCREEN_WIDTH*0.08;
        CGFloat lowHeight = HCSCREEN_WIDTH*0.043;
        
        CGFloat presellWidth= HCSCREEN_WIDTH*0.099;
        CGFloat presellHeight = HCSCREEN_WIDTH*0.051;
        
        //判断 rate 是否有值 有值的情况下判断是否为0 不为0方可进行除操作
        if ([vehicle.left_bottom_rate isEqualToString:@""]) {
            left_bottom_width = 0;
        }else{
            if ([vehicle.left_bottom_rate floatValue]!=0) {
                left_bottom_width = imageWidth / [vehicle.left_bottom_rate floatValue];
            }
          
        }
        if ([vehicle.left_top_rate isEqualToString:@""]) {
            left_bottom_width = 0;
        }else{
            if ([vehicle.left_top_rate floatValue]!=0) {
             left_top_width = imageWidth / [vehicle.left_top_rate floatValue];
            }
           
        }
        self.vehicleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HC_VEHICLE_CELL_WIDTH_PADDING,(HC_VEHICLE_LIST_ROW_HEIGHT- HCSCREEN_WIDTH*0.27f)/2, imageWidth, imageHeight)];
//        self.lowImageView = [[UIImageView alloc]init];
//        self.lowImageView.image = [UIImage imageNamed:@"buy_jiang"];
//        [self.vehicleImageView addSubview:self.lowImageView];
        
//        self.reducePriceLabel = [[UILabel alloc]init];
//        self.reducePriceLabel.text = @"直降5000";
//        self.reducePriceLabel.textColor = [UIColor darkGrayColor];
//        self.reducePriceLabel.font = [UIFont fontSize:13];
        
        self.presellView = [[UIImageView alloc]initWithFrame:CGRectMake(self.vehicleImageView.width-presellWidth, 0, presellWidth, presellHeight)];
        self.presellView.image = [UIImage imageNamed:@"presell"];
        [self.vehicleImageView addSubview:self.presellView];
        
        
        
        
        if (vehicle.left_bottom_rate) {
            self.left_bottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageHeight-left_bottom_width, left_bottom_width, left_bottom_width)];
            [self.left_bottom sd_setImageWithURL:[NSURL URLWithString:vehicle.left_bottom] placeholderImage:nil];
           
        }
        if (vehicle.left_top_rate) {
            self.left_top = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, left_top_width, left_top_width)];
            [self.left_top sd_setImageWithURL:[NSURL URLWithString:vehicle.left_top] placeholderImage:nil];
            
        }
        [self.vehicleImageView addSubview:self.left_bottom];
        [self.vehicleImageView addSubview:self.left_top];
       

        CGFloat textRegionX = HC_VEHICLE_CELL_WIDTH_PADDING + self.vehicleImageView.frame.size.width + HC_VEHICLE_CELL_TEXT_REGION_PADDING;
        CGFloat textRegionWidth = frame.size.width -  HC_VEHICLE_CELL_WIDTH_PADDING - imageWidth - HC_VEHICLE_CELL_TEXT_REGION_PADDING * 2;

        self.vehicleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(textRegionX, self.vehicleImageView.top, HCSCREEN_WIDTH-self.vehicleImageView.right-20, 35)];
        self.vehicleTitleLabel.font = [UIFont fontSize:14];
        self.vehicleTitleLabel.textColor = UIColorFromRGBValue(0x424242);
        self.vehicleTitleLabel.numberOfLines = 2;
        //self.vehicleTitleLabel.contentMode = UIViewContentModeTop;
       self.zhiyingdian = [[UIImageView alloc]init];
        self.zhiyingdian.image = [UIImage imageNamed:@"buy_baoyou"];
        self.zhiyingdian.frame = CGRectMake(0, 0.5, 42, 15);
        [self.vehicleTitleLabel addSubview:self.zhiyingdian];
        // mark_long 修改
//        self.vehicleTimeAndMilesLabel = [[UILabel alloc] initWithFrame:CGRectMake(textRegionX, self.vehicleTitleLabel.bottom+10, textRegionWidth, 12)];
//        self.vehicleTimeAndMilesLabel.font = [UIFont systemFontOfSize:12];
//        self.vehicleTimeAndMilesLabel.textColor = UIColorFromRGBValue(0x9f9f9f);
        self.vehicleTimeLabel =  [[UILabel alloc] init];
        self.vehicleTimeLabel.font = [UIFont systemFontOfSize:10];
        self.vehicleTimeLabel.layer.cornerRadius = Width(7);
        self.vehicleTimeLabel.layer.masksToBounds = YES;
        self.vehicleTimeLabel.backgroundColor = RGB(229, 229, 229);
        self.vehicleTimeLabel.textColor = [UIColor darkGrayColor];
        
        self.vehicleMilesLabel =  [[UILabel alloc] init];
        self.vehicleMilesLabel.font = [UIFont systemFontOfSize:10];
        self.vehicleMilesLabel.layer.cornerRadius = Width(7);
        self.vehicleMilesLabel.layer.masksToBounds = YES;
        self.vehicleMilesLabel.backgroundColor = RGB(229, 229, 229);
        self.vehicleMilesLabel.textColor = [UIColor darkGrayColor];
        
        self.hotImg = [[UIImageView alloc]init];
        self.hotImg.image = [UIImage imageNamed:@"buy_hot"];
        [self addSubview:self.hotImg];
        
        self.cityLabel = [[UILabel alloc]init];
        self.cityLabel.font = [UIFont fontSize:10];
        self.cityLabel.textColor = [UIColor hex:@"666666"];
        
        
        CGFloat vehiclePriceHeight = 16;
        self.vehiclePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(textRegionX, self.vehicleImageView.bottom-vehiclePriceHeight, 90, vehiclePriceHeight)];
        self.shoufuLabel = [[UILabel alloc]init];
        self.shoufuLabel.font = [UIFont systemFontOfSize:12];
        self.shoufuLabel.textColor = UIColorFromRGBValue(0x9f9f9f);
        self.shoufuLabel.frame = CGRectMake(self.vehiclePriceLabel.right, self.vehiclePriceLabel.top+4, 60, 12);
        CGFloat soldImgWidth = HCSCREEN_WIDTH * 0.156f;
        self.soldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - HCSCREEN_WIDTH * 0.03 - soldImgWidth, frame.size.height - HCSCREEN_WIDTH * 0.03 - soldImgWidth, soldImgWidth, soldImgWidth)];
        self.soldImageView.image = [UIImage imageNamed:@"sold_icon"];
//        self.zhibao = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width- HCSCREEN_WIDTH*0.14-15, self.vehicleImageView.bottom-HCSCREEN_WIDTH*0.04, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.04)];
//        self.zhibao.image = [UIImage imageNamed:@"zhibaocell"];
        self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(self.vehiclePriceLabel.left, self.vehicleImageView.bottom+10, HCSCREEN_WIDTH-self.vehiclePriceLabel.left-15, 0.5)];
        self.bottomLine.backgroundColor = UIColorFromRGBValue(0xf5f5f5);
        self.activitiView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bottomLine.left, self.bottomLine.bottom+10, HCSCREEN_WIDTH*0.12, HCSCREEN_WIDTH*0.048)];
        self.fenqiLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.activitiView.right+15, self.activitiView.top, HCSCREEN_WIDTH-self.activitiView.right-15, HCSCREEN_WIDTH*0.048)];
        self.fenqiLabel.textAlignment = NSTextAlignmentLeft;
        self.fenqiLabel.textColor = UIColorFromRGBValue(0x424242);
        self.fenqiLabel.font = [UIFont systemFontOfSize:12];
        self.firstLabel = [self createLabelWithFrame:CGRectMake(self.activitiView.right+15,self.activitiView.top , 0, HCSCREEN_WIDTH*0.048) backColor:[UIColor clearColor] textColor:UIColorFromRGBValue(0x424242)];
        self.secondLabel = [self createLabelWithFrame:CGRectMake(self.firstLabel.right,self.activitiView.top , 0, HCSCREEN_WIDTH*0.048) backColor:[UIColor blackColor] textColor:[UIColor whiteColor]];
        self.thirdLabel = [self createLabelWithFrame:CGRectMake(self.secondLabel.right,self.activitiView.top , 0, HCSCREEN_WIDTH*0.048) backColor:[UIColor clearColor] textColor:UIColorFromRGBValue(0x424242)];
        self.fourthLabel = [self createLabelWithFrame:CGRectMake(self.thirdLabel.right,self.activitiView.top , 0, HCSCREEN_WIDTH*0.048) backColor:[UIColor blackColor] textColor:[UIColor whiteColor]];
        self.fivthLabel = [self createLabelWithFrame:CGRectMake(self.fourthLabel.right,self.activitiView.top , 0, HCSCREEN_WIDTH*0.048) backColor:[UIColor clearColor] textColor:UIColorFromRGBValue(0x424242)];
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:self.thirdLabel];
        [self addSubview:self.fourthLabel];
        [self addSubview:self.fivthLabel];
        [self addSubview:self.fenqiLabel];
        [self addSubview:self.activitiView];
        [self addSubview:self.bottomLine];
        [self addSubview:self.shoufuLabel];
        [self addSubview:self.vehicleImageView];
        [self addSubview:self.vehiclePriceLabel];
        //mark_long 修改
        //        [self addSubview:self.zhibao];
//        [self addSubview:self.vehicleTimeAndMilesLabel];
//        [self addSubview:self.lowImageView];
//        [self addSubview:self.reducePriceLabel];
        [self addSubview:self.vehicleTimeLabel];
        [self addSubview:self.vehicleMilesLabel];
        [self addSubview:self.hotImg];
        
        [self addSubview:self.vehicleTitleLabel];
        self.slashLine = [[UIView alloc] initWithFrame:CGRectMake(0, HC_VEHICLE_LIST_ROW_HEIGHT, frame.size.width, 5)];
        self.slashLine.backgroundColor = MTABLEBACK;
        [self setVehicleData:self.vehicle];
        
        [self addSubview:self.slashLine];
        [self addSubview:self.cityLabel];
        
        
        [self.vehicleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vehicleTitleLabel.mas_bottom).offset(Width(10));
            make.left.equalTo(self.vehicleImageView.mas_right).offset(Width(10));
            make.height.mas_equalTo(Width(14));
        }];
        
        [self.vehicleMilesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.vehicleTimeLabel);
            make.left.equalTo(self.vehicleTimeLabel.mas_right).offset(Width(2));
            make.height.mas_equalTo(Width(14));
        }];
        
        [self.hotImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-Width(15));
            make.centerY.equalTo(self.vehicleTimeLabel);
            make.width.height.mas_equalTo(Width(17));
        }];
        
//        [self.reducePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.vehicleImageView.mas_right);
//            make.bottom.equalTo(self.vehicleImageView.mas_bottom).offset(-Width(10));
//        }];
//
//        [self.lowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.vehicleImageView.mas_right).offset(Width(2));
//            make.left.equalTo(self.reducePriceLabel.mas_left).offset(-Width(10));
//            make.top.equalTo(self.reducePriceLabel.mas_top).offset(-Width(3));
//            make.bottom.equalTo(self.reducePriceLabel.mas_bottom).offset(Width(4));
//        }];
        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-Width(15));
            make.centerY.equalTo(self.vehiclePriceLabel);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(UILabel *)createLabelWithFrame:(CGRect)frame backColor:(UIColor*)color textColor:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.backgroundColor = color;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
   // [self addSubview:label];
    return label;
}
- (CAShapeLayer*)createLayer:(CGRect)frame
{
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame, 0, 0) cornerRadius:1.0];
    CAShapeLayer *sublayer = [CAShapeLayer layer];
    sublayer.cornerRadius = 1;
    sublayer.path = bPath.CGPath;
    sublayer.strokeColor = UIColorFromRGBValue(0xff2626).CGColor;
    sublayer.fillColor = [UIColor clearColor].CGColor;
    sublayer.lineWidth = 0.8;
    return sublayer;
}

- (NSString *)reuseIdentifier {
    return @"hc_vehicle_cell";
}

- (Vehicle *)getVehicle
{
    return _vehicle;
}

- (NSMutableAttributedString*)setcityText:(NSString*)mStr{
    
    NSRange range = [mStr rangeOfString:@"["];
    NSRange range2 = [mStr rangeOfString:@"]"];
    NSRange range3 = NSMakeRange(range.location+range.length, range2.location-range.length-range.location);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    [str addAttribute:NSForegroundColorAttributeName value: UIColorFromRGBValue(0x212121) range:range];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR  range:range3];
    [str addAttribute:NSForegroundColorAttributeName value: UIColorFromRGBValue(0x212121) range:range2];
    return str;
}

- (NSString *)resoveTitleName:(NSString *)name{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",name];
    NSRange range = [name rangeOfString:@"["];
    NSRange range2 = [name rangeOfString:@"]"];
    NSRange range3 = NSMakeRange(range.location, range2.location - range.location + range2.length);
    [str deleteCharactersInRange:range3];
    return [NSString stringWithFormat:@"%@",str];
}

- (void)setVehicleData:(Vehicle *)vehicle
{
//    self.cityLabel.hidden = YES;
    _vehicle_source_id = vehicle.vehicle_id;
    self.vehicle = vehicle;
    if (vehicle.cover_pic == nil) {
        [self.vehicleImageView setImage:[UIImage imageNamed:@"default_vehicle"]];
    }else{
    
        [self.vehicleImageView sd_setImageWithURL:[NSURL URLWithString:vehicle.cover_pic]placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    }
    NSString *vehicleName;
    if ([vehicle.show_baoyou integerValue]) {
        self.zhiyingdian.hidden = NO;
       vehicleName  = [NSString stringWithFormat:@"            %@",vehicle.vehicle_name];
    }else{
        self.zhiyingdian.hidden = YES;
        vehicleName  = [NSString stringWithFormat:@"%@",vehicle.vehicle_name];
    }
    
    if ([vehicle.vehicle_name hasPrefix:@"["]) {
        self.vehicleTitleLabel.text = [self resoveTitleName:vehicleName];
    }else{
        self.vehicleTitleLabel.text = vehicleName;
    }
    
//  self.vehicleTitleLabel.backgroundColor = [UIColor cyanColor];
    [self.vehicleTitleLabel sizeToFit];
    CGFloat left_top_width = 0.0;
    CGFloat left_bottom_width=0.0 ;
    
     //判断 rate 是否有值 有值的情况下判断是否为0 不为0方可进行除操作
    if ([vehicle.left_bottom isEqualToString:@""]) {
        self.left_bottom.hidden = YES;
    }else{
        if (vehicle.left_bottom_rate&&[vehicle.left_bottom_rate floatValue]!=0) {
           left_bottom_width = self.vehicleImageView.width / [vehicle.left_bottom_rate floatValue];
        }
        
        self.left_bottom.frame = CGRectMake(0,  self.vehicleImageView.width-left_bottom_width, left_bottom_width, left_bottom_width);
        [self.left_bottom sd_setImageWithURL:[NSURL URLWithString:vehicle.left_bottom] placeholderImage:nil];
        self.left_bottom.hidden = NO;
    }
    if ([vehicle.left_top isEqualToString:@""]) {
        self.left_top.hidden = YES;
    }else{
        if (vehicle.left_top_rate&&[vehicle.left_top_rate floatValue]!=0) {
            left_top_width = self.vehicleImageView.width / [vehicle.left_top_rate floatValue];

        }
        self.left_top.frame = CGRectMake(0, 0, left_top_width, left_top_width);
        [self.left_top sd_setImageWithURL:[NSURL URLWithString:vehicle.left_top] placeholderImage:nil];
        self.left_top.hidden = NO;
        
    }
    
    self.cityLabel.text = vehicle.store_addr;
    
    self.vehicleTitleLabel.frame = CGRectMake(self.vehicleTitleLabel.left, self.vehicleTitleLabel.top,  HCSCREEN_WIDTH-self.vehicleImageView.right-20, self.vehicleTitleLabel.height);
    
   // NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:vehicle.registerDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM"];
    //mark_long 修改
//    self.vehicleTimeAndMilesLabel.text = [NSString stringWithFormat:@"%@上牌・%@万公里・%@",
//                                     vehicle.register_time, vehicle.miles, vehicle.geerbox_type];
//    //vehicleTitleLabel
//    CGRect labelFrame = self.vehicleTimeAndMilesLabel.frame;
//    labelFrame.origin.y =  self.vehicleTitleLabel.bottom + HC_VEHICLE_TITLE_MILES_GAP;
//    self.vehicleTimeAndMilesLabel.frame = labelFrame;
    self.vehicleTimeLabel.text = [NSString stringWithFormat:@" %@上牌 ",vehicle.register_time];
    self.vehicleMilesLabel.text = [NSString stringWithFormat:@" %@万公里 ",vehicle.miles];
    
    //addPrice
    NSString *priceText = [NSString stringWithFormat:@"%@万", vehicle.seller_price];

    self.vehiclePriceLabel.attributedText = [NSString setPriceText:priceText];
    
    [self.vehiclePriceLabel sizeToFit];
    [self.shoufuLabel setLeft:self.vehiclePriceLabel.right+5];
    if (vehicle.shoufu_price.length!=0) {
     self.shoufuLabel.text = [NSString stringWithFormat:@"首付%@万",vehicle.shoufu_price];
    }else{
     self.shoufuLabel.text =  @"";
    }
    [self.shoufuLabel sizeToFit];
//    if (HCSCREEN_WIDTH==320) {
//      self.zhibao.hidden = YES;
//    }else{
//        if (vehicle.zhibao==0) {
//            self.zhibao.hidden = YES;
//        }else{
//            self.zhibao.hidden = NO;
//        }
//    }
    if (vehicle.status == 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [self.soldImageView removeFromSuperview];
       
    } else {
        if (self.soldImageView.superview != self) {
            [self addSubview:self.soldImageView];
        }
    }
    NSInteger dataNow = [[NSDate date]timeIntervalSince1970];
   // vehicle.qianggou = 1474539960;
    if (vehicle.act_text.length!=0) {
        self.bottomLine.hidden =NO;
        self.activitiView.hidden= NO;
        self.fenqiLabel.hidden = NO;
        [self hideTime:YES];
        [self.activitiView sd_setImageWithURL:[NSURL URLWithString:vehicle.act_pic ] placeholderImage:nil];
        self.fenqiLabel.text = vehicle.act_text;
         self.slashLine.frame = CGRectMake(0, self.activitiView.bottom+15, HCSCREEN_WIDTH, 5);
    }else if (vehicle.qianggou!=0&&vehicle.qianggou >dataNow){
        self.bottomLine.hidden =NO;
        self.activitiView.hidden= NO;
        self.fenqiLabel.hidden = YES;
        [self hideTime:NO];
        self.activitiView.image = [UIImage imageNamed:@"qianggou"];
        [self changeTime:vehicle.qianggou];
         self.slashLine.frame = CGRectMake(0, self.activitiView.bottom+15, HCSCREEN_WIDTH, 5);
    }else if((vehicle.qianggou==0||vehicle.qianggou <=dataNow)&&vehicle.act_text.length==0){
        self.bottomLine.hidden =YES;
        self.activitiView.hidden= YES;
        self.fenqiLabel.hidden = YES;
        [self hideTime:YES];
        self.slashLine.frame = CGRectMake(0, HC_VEHICLE_LIST_ROW_HEIGHT, HCSCREEN_WIDTH, 5);
    }
    
    if (vehicle.qianggou!=0&&vehicle.qianggou >dataNow&&vehicle.act_text.length!=0) {
        self.bottomLine.hidden =NO;
        self.activitiView.hidden= NO;
        self.fenqiLabel.hidden = NO;
        [self hideTime:YES];
        [self.activitiView sd_setImageWithURL:[NSURL URLWithString:vehicle.act_pic ] placeholderImage:nil];
        self.fenqiLabel.text = vehicle.act_text;
        self.slashLine.frame = CGRectMake(0, self.activitiView.bottom+15, HCSCREEN_WIDTH, 5);
    }
    if (vehicle.suitable==1) {
//        self.lowImageView.hidden = NO;
        self.hotImg.hidden = NO;
    }else{
//        self.lowImageView.hidden = YES;
        self.hotImg.hidden = YES;
    }
    if (vehicle.yushou==1) {
        self.presellView.hidden = NO;
    }else{
        self.presellView.hidden = YES;
    }
   
}
- (void)hideTime:(BOOL)hide{
    self.firstLabel.hidden = hide;
    self.secondLabel.hidden = hide;
    self.thirdLabel.hidden = hide;
    self.fourthLabel.hidden = hide;
    self.fivthLabel.hidden = hide;
    
}
- (void)endtimeHide{
    self.firstLabel.hidden = YES;
    self.secondLabel.hidden = YES;
    self.thirdLabel.hidden = YES;
    self.fourthLabel.hidden = YES;
    self.fivthLabel.hidden = YES;
    self.activitiView.hidden= YES;
    self.bottomLine.hidden=YES;
    self.slashLine.frame = CGRectMake(0, HC_VEHICLE_LIST_ROW_HEIGHT, HCSCREEN_WIDTH, 5);
}
- (BOOL)endTime:(Vehicle*)vehicle{
    NSInteger i_nowTimeStamp = [NSDate date].timeIntervalSince1970;
    NSInteger remainTime = vehicle.qianggou - i_nowTimeStamp;
    if (remainTime<=0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)changeTime:(NSInteger)endTimeStamp{
    //NSInteger i_endTimeStamp = endTimeStamp;
    
//    NSInteger i_nowTimeStamp = [NSDate date].timeIntervalSince1970;
//    NSInteger remainTime = endTimeStamp - i_nowTimeStamp;
//    if (remainTime<=0) {
//        //倒计时到
//      //  return nil;
//    }else {
//        NSInteger remainDay = remainTime/(24*60*60); //剩余天数
//        remainTime = remainTime % (24*60*60);
//        NSInteger remainHour = remainTime / (60*60);//剩余小时
//        remainTime = remainTime % (60*60);
//        NSInteger remainMinute = remainTime / 60;//剩余分钟
//        NSInteger remainSecond = remainTime % 60; //剩余秒数
//         self.firstLabel.text = @"距结束";
//        [self.firstLabel sizeToFit];
//        self.firstLabel.height = HCSCREEN_WIDTH*0.048;
//        if (remainDay) {
//            //显示天、小时
//            self.remainDay = [NSString stringWithFormat:@"%02ld",(long)remainDay];
//            self.remainHour = [NSString stringWithFormat:@"%02ld",(long)remainHour];
//            self.secondLabel.text = self.remainDay;
//            self.thirdLabel.text = @"天";
//            self.fourthLabel.text = self.remainHour;
//            self.fivthLabel.text = @"时";
//           // return [NSString stringWithFormat:@"距结束%ld天%ld时",(long)remainDay,(long)remainHour];
//        }else {
//            if (remainHour) {
//                //显示小时、分
//                self.remainHour = [NSString stringWithFormat:@"%02ld",(long)remainHour];
//                self.remainMin = [NSString stringWithFormat:@"%02ld",(long)remainMinute];
//                self.secondLabel.text = self.remainHour;
//                self.thirdLabel.text = @"时";
//                self.fourthLabel.text = self.remainMin;
//                self.fivthLabel.text = @"分";
//               // return [NSString stringWithFormat:@"距结束%ld时%ld分",(long)remainHour,(long)remainMinute];
//            }else {
//                //显示分、秒
//                self.remainMin = [NSString stringWithFormat:@"%02ld",(long)remainMinute];
//                self.remainSec = [NSString stringWithFormat:@"%02ld",(long)remainSecond];
//                self.secondLabel.text = self.remainMin;
//                self.thirdLabel.text = @"分";
//                self.fourthLabel.text = self.remainSec;
//                self.fivthLabel.text = @"秒";
//                //return [NSString stringWithFormat:@"距结束%ld分%ld秒",(long)remainMinute,(long)remainSecond];
//            }
//        }
//        self.secondLabel.left = self.firstLabel.right+2;
//        [self.secondLabel sizeToFit];
//        self.secondLabel.height = HCSCREEN_WIDTH*0.048;
//        self.secondLabel.width = self.secondLabel.width+4;
//        self.secondLabel.layer.masksToBounds = YES;
//        self.secondLabel.layer.cornerRadius = 2;
//
//        self.thirdLabel.left = self.secondLabel.right+2;
//        [self.thirdLabel sizeToFit];
//         self.thirdLabel.height = HCSCREEN_WIDTH*0.048;
//
//        self.fourthLabel.left = self.thirdLabel.right+2;
//        [self.fourthLabel sizeToFit];
//        self.fourthLabel.width = self.fourthLabel.width+4;
//        self.fourthLabel.height = HCSCREEN_WIDTH*0.048;
//        self.fourthLabel.layer.masksToBounds = YES;
//        self.fourthLabel.layer.cornerRadius = 2;
//
//        self.fivthLabel.left = self.fourthLabel.right+2;
//        [self.fivthLabel sizeToFit];
////        self.fivthLabel.height = HCSCREEN_WIDTH*0.048;
//    }
}

//倒计时 到某个时间点还有多久 //时间戳
//- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
//{
//    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
//    dateString1=[timeArray1 HCObjectAtIndex:0];
//    
//    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
//    dateString2=[timeArray2 HCObjectAtIndex:0];
//    
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *d1=[date dateFromString:dateString1];
//    
//    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
//    
//    NSDate *d2=[date dateFromString:dateString2];
//    
//    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
//    
//    NSTimeInterval cha=late2-late1;
//    NSString *timeString=@"";
//    NSString *house=@"";
//    NSString *min=@"";
//    NSString *sen=@"";
//    
//    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
//    sen=[NSString stringWithFormat:@"%@", sen];
//    
//    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
//    min=[NSString stringWithFormat:@"%@", min];
//    
//    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
//    house=[NSString stringWithFormat:@"%@", house];
//    
//    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
//    
//    return timeString;
//}



@end
