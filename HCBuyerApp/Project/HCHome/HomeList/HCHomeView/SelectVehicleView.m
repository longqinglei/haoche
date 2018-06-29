//
//  SelectVehicleView.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "SelectVehicleView.h"
#import "CondBtn.h"

#define BtnHeight (HCSCREEN_WIDTH - 43)/4*0.48
@interface SelectVehicleView ()

@property (nonatomic,strong)UIView *cityView;
@property (nonatomic,strong)UIView *noCityView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UILabel *vehicleNum;
@property (nonatomic,strong)UILabel *spaceLabel;
@end


@implementation SelectVehicleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = [UIColor whiteColor];
            [self createTwoBtnWithInfo];
            [self createPriceBtn];
    }
    return self;
}

- (void)createTwoBtnWithInfo{
    NSArray *titleArray =[NSArray arrayWithObjects:@"买车",@"卖车" ,nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"buyVehicle",@"sellVehicle", nil];
    CGFloat BtnWidth = (HCSCREEN_WIDTH-47)/2;
    for (int i = 0 ; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn  addTarget:self action:@selector(topbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn  setTitle:[titleArray HCObjectAtIndex:i] forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGBValue(0xff2626)];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xe52222) andSize:CGSizeMake(BtnWidth, 44)] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        btn.layer.cornerRadius = 2;
        [btn.layer setMasksToBounds:YES];
        btn.tag = 100+i;
        btn.frame = CGRectMake(20+(i*(BtnWidth+7)), 15, BtnWidth, 44);
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame  = CGRectMake(0, 13, 32, 31);
        imageview.image = [UIImage imageNamed:[imageArray HCObjectAtIndex:i]];
        [btn addSubview:imageview];
        [self addSubview:btn];
    }
    UIImageView *icon = [[UIImageView alloc]init];
    icon.frame = CGRectMake(20, 69, 9, 12);
    icon.image = [UIImage imageNamed:@"selecticon"];
    [self addSubview:icon];
    UILabel *xuanche = [[UILabel alloc]init];
    xuanche.text = @"热门";
    xuanche.font = [UIFont systemFontOfSize:12];
    xuanche.textColor = UIColorFromRGBValue(0x929292);
    xuanche.frame = CGRectMake(icon.right+3, icon.top, 60, 12);
    [self addSubview:xuanche];
}

- (void)topbtnClick:(UIButton *)btn{
  
    if (self.delegate) {
        [self.delegate pushToSellOrBuyVehicle:btn];
    }
}

- (void)createnoCityViewWithDataArray:(NSArray*)cityArray{
    if (cityArray.count==0) {
        [self  setHeight: HCSCREEN_WIDTH*0.165+191];
        [self reloadCityFrame];
        return;
    }
    if (self.noCityView ) {
        [self.noCityView removeFromSuperview];
    }
    CGFloat buttwidth =( HCSCREEN_WIDTH - 43)/4;
    self.noCityView = [[UIView alloc]init];
    self.noCityView.frame = CGRectMake(0, 91, HCSCREEN_WIDTH, buttwidth*0.48);
    for (int i = 0; i < cityArray.count ; i++) {
        CondBtn *condbtn =[[CondBtn alloc]initWithPriceCond:[cityArray HCObjectAtIndex:i]];
        [condbtn addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
        condbtn.frame = CGRectMake(20+(i* (buttwidth+1)), 0, buttwidth, buttwidth*0.48);
        [self.noCityView addSubview:condbtn];
    }
    [self reloadCityFrame];
    [self addSubview:self.noCityView];
}

- (void)priceClick:(CondBtn*)btn{
    if (self.delegate) {
        [self.delegate priceBtnClick:btn];
    }
}

- (void)brandClick:(CondBtn*)btn{
    if (self.delegate) {
        [self.delegate brandBtnClick:btn];
    }
}

- (void)activityClick:(CondBtn*)btn{
    [HCAnalysis HCUserClick:btn.activity.title];
    if (self.delegate) {
        [self.delegate activityBtnClick:btn];
    }
}
- (void)GesturebrandClick:(UITapGestureRecognizer *)gesture{
    CondBtn *cond = (CondBtn* )[gesture.view superview];
    if (self.delegate) {
        [self.delegate brandBtnClick:cond];
    }
}

- (void)createCityViewWithBrand:(NSArray *)brandArray{
    CGFloat buttwidth =( HCSCREEN_WIDTH - 43)/4;
    if (brandArray.count==0) {
        return;
    }
    if (self.cityView ) {
        [self.cityView removeFromSuperview];
    }
     self.cityView = [[UIView alloc]init];
    if (self.noCityView==nil) {
        self.cityView.frame = CGRectMake(0,91, HCSCREEN_WIDTH,buttwidth*0.48);
    }else{
        self.cityView.frame = CGRectMake(0, self.noCityView.bottom+1, HCSCREEN_WIDTH,buttwidth*0.48);
    }
    for (int  i = 0; i<brandArray.count; i++) {
        id arrayocond = [brandArray objectAtIndex:i];
        if ([arrayocond isKindOfClass:[BrandSeriesCond class]]) {
            CondBtn *condbtn = [[CondBtn alloc]initWithBrandCond:[brandArray HCObjectAtIndex:i]WithTaget:self WithSelector:@selector(GesturebrandClick:)];
            [condbtn addTarget:self action:@selector(brandClick:) forControlEvents:UIControlEventTouchUpInside];
            condbtn.frame = CGRectMake(20+(i* (buttwidth+1)), 0, buttwidth, buttwidth*0.48);
            [self.cityView addSubview:condbtn];
        }else{
            CondBtn *condbtn = [[CondBtn alloc]initWithActivity:[brandArray HCObjectAtIndex:i]];
            
            [condbtn addTarget:self action:@selector(activityClick:) forControlEvents:UIControlEventTouchUpInside];
            condbtn.frame = CGRectMake(20+(i* (buttwidth+1)), 0, buttwidth, buttwidth*0.48);
            [self.cityView addSubview:condbtn];
        }
    }
    
    [self reloadBottomFrame];
    [self addSubview:self.cityView];
    
    
}
- (void)newVehicleClick{
    [HCAnalysis HCUserClick:@"TodayNew"];
    if (self.delegate) {
        [self.delegate jumpNewVehiclePage];
    }
}
- (void)createPriceBtn{
    PriceCond *price1 = [[PriceCond alloc]initByPriceFrom:3 to:5 desc:@"3~5万"];
    PriceCond *price2 = [[PriceCond alloc]initByPriceFrom:5 to:7 desc:@"5~7万"];
    PriceCond *price3 = [[PriceCond alloc]initByPriceFrom:7 to:9 desc:@"7~9万"];
    PriceCond *price4 = [[PriceCond alloc]initByPriceFrom:9 to:12 desc:@"9~12万"];
    NSArray *priceCondArr = [NSArray arrayWithObjects:price1,price2,price3,price4, nil];
    [self createnoCityViewWithDataArray:priceCondArr];
}

- (void)createBottomViewWith:(NSString*)vehicelCount{
    
    if (vehicelCount==nil) {
        return;
    }
    NSString *vehicleNum = [NSString stringWithFormat:@"%@辆",vehicelCount];
    
    if (self.bottomBtn) {
        self.vehicleNum.attributedText = [NSString setHomePrice:vehicleNum];
    }else{
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomBtn.frame = CGRectMake(0, self.noCityView.bottom+15, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.165);
    [self.bottomBtn addTarget:self action:@selector(newVehicleClick) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"lineBG"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:image];
    self.bottomBtn.backgroundColor = backgroundColor;
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.frame = CGRectMake(20, (HCSCREEN_WIDTH*0.165- HCSCREEN_WIDTH*0.069)/2, HCSCREEN_WIDTH*0.085, HCSCREEN_WIDTH*0.069);
    iconImage.image = [UIImage imageNamed:@"newVehicle"];
   
    self.vehicleNum = [[UILabel alloc]initWithFrame:CGRectZero];
    self.vehicleNum.font  = GetFontWithSize(40);
    self.vehicleNum.textColor = UIColorFromRGBValue(0xff2626);
    self.vehicleNum.frame = CGRectMake(iconImage.right+25, 0, 100,self.bottomBtn.height);
    self.vehicleNum.attributedText = [NSString setHomePrice:vehicleNum];
  //  [self.vehicleNum sizeToFit];
    self.vehicleNum.frame = CGRectMake(iconImage.right+25, (HCSCREEN_WIDTH*0.165-self.vehicleNum.height)/2, self.vehicleNum.width, self.vehicleNum.height);
    
    UIImageView *allImageView = [[UIImageView alloc]init];
    allImageView.frame = CGRectMake(self.bottomBtn.width-HCSCREEN_WIDTH*0.053 -20,( self.bottomBtn.height-HCSCREEN_WIDTH*0.053)/2, HCSCREEN_WIDTH*0.053, HCSCREEN_WIDTH*0.053);
    allImageView.image = [UIImage imageNamed:@"allvehicle"];
    
    UILabel *allLabel = [[UILabel alloc]init];
    allLabel.frame = CGRectMake(self.bottomBtn.width-30-HCSCREEN_WIDTH*0.053 -20, (self.bottomBtn.height-20)/2, 30, 20);
    allLabel.textAlignment = NSTextAlignmentCenter;
    allLabel.text  = @"查看";
    allLabel.textColor = UIColorFromRGBValue(0x424242);
    allLabel.font = GetFontWithSize(12);
    self.spaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bottomBtn.bottom, HCSCREEN_WIDTH, 10)];
    self.spaceLabel.backgroundColor = MTABLEBACK;
    [self addSubview:self.spaceLabel];
        
    [self reloadBottomFrame];
    [self.bottomBtn addSubview:allLabel];
    [self.bottomBtn addSubview:allImageView];
    [self.bottomBtn addSubview:iconImage];
    [self.bottomBtn addSubview:self.vehicleNum];
    [self addSubview:self.bottomBtn];
    }
}
- (void)reloadCityFrame{
    if (self.noCityView==nil) {
        self.cityView.frame = CGRectMake(0, 91, HCSCREEN_WIDTH,BtnHeight);
    }else{
        self.cityView.frame = CGRectMake(0, self.noCityView.bottom+1, HCSCREEN_WIDTH,BtnHeight);
    }
}
-(void)reloadBottomFrame{
    self.bottomBtn.frame = CGRectMake(0, self.cityView.bottom+15, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.165);
    self.spaceLabel.frame = CGRectMake(0, self.bottomBtn.bottom, HCSCREEN_WIDTH, 10);
}

@end
