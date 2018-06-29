//
//  VehiceSaleStatusView.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehiceSaleStatusView.h"
#import "UILabel+ITTAdditions.h"
#import "UIButton+ITTAdditions.h"
#import "MySaleVehicles.h"
#import "UIImageView+WebCache.h"

@interface VehiceSaleStatusView()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *arrayPriceData;
@property (strong,nonatomic)NSArray *arrayWrittenWords;
@property (strong,nonatomic)UIScrollView *mScrollView;
@property (strong,nonatomic)UIButton *btn;
@property (strong,nonatomic)UILabel *mNumberText;
@property (nonatomic,strong)UIView *mView;
@property (nonatomic,strong)UIView *mViewCar;
@property (nonatomic,strong)UIView *mAdjustment;
@property (nonatomic,strong)UIImageView *vehicleBrandImage;
@property (nonatomic,strong)UILabel *vehicle_name;
@property (nonatomic,strong)UIImageView *vehicleImage;
@property (nonatomic,strong)UILabel *correct_text;
@property (nonatomic,strong)UILabel *vehicle_id;
@property (nonatomic,strong)UILabel *suggest_text;
@property (nonatomic,strong)UILabel *eval_price;
@property (nonatomic,strong)UIButton *adjustBtn;
@property (nonatomic,strong)UILabel *seller_price;
@property (nonatomic,strong) UIView *mViewMin;
@property (nonatomic,strong)UIView *mViewMy;
@property (nonatomic,strong)UILabel *correct_phone;
@property (nonatomic,strong)NSString *strPhone;
@property (nonatomic,strong)NSString *adjusPhone;
@property (nonatomic,strong) UIImageView *imaegViewPiture;
@property (nonatomic,strong)UIView *verticalLine;
@property (nonatomic,strong)UILabel *mOwnerText;


@end

@implementation VehiceSaleStatusView

#define  STATUS  vehicle.status

#pragma mark - Life cycle
- (id) initWithFrame:(CGRect)frame MySaleVehicles:(MySaleVehicles *)mySaleVehicle andSatus:(NSInteger)status
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_arrayPriceData == nil) {
            _arrayPriceData = [[NSArray alloc]init];
        }
         [self initView:mySaleVehicle andShow:status];
    }
    return self;
}

- (void)initView:(MySaleVehicles *)mySaleVehicle andShow:(NSInteger)status
{
    
    _mView = [[UIView alloc]init];
    _mView.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, self.height);

    self.vehicleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*480/640)];
    [_mView addSubview:self.vehicleImage];
    
    UITapGestureRecognizer *tapPiture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiture:)];
    self.vehicleImage.userInteractionEnabled = YES;
    tapPiture.delegate = self;
    tapPiture.numberOfTapsRequired = 1;
    [self.vehicleImage addGestureRecognizer:tapPiture];
    
    _mViewMin = [[UIView alloc]initWithFrame:CGRectMake(0,self.vehicleImage.bottom-self.vehicleImage.height/6, HCSCREEN_WIDTH, self.vehicleImage.height/6)];
    _mViewMin.backgroundColor = [UIColor blackColor];
    _mViewMin.alpha = 0.6;
    [self.vehicleImage addSubview:_mViewMin];
    
    _mViewMy = [[UIView alloc]initWithFrame:CGRectMake(0, self.vehicleImage.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT/12.6)];
    _mViewMy.backgroundColor = [UIColor colorWithRed:0.96f green:0.95f blue:0.95f alpha:1.00f];
    [_mView addSubview:_mViewMy];
    
    self.correct_text = [UILabel labelWithFrame:CGRectMake(10, 0, HCSCREEN_WIDTH-110, HCSCREEN_HEIGHT/12.6) text:@"" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13] tag:101 hasShadow:NO isCenter:NO];
    [_mViewMy addSubview:self.correct_text];
    
    self.correct_phone = [UILabel labelWithFrame:CGRectMake(HCSCREEN_WIDTH-100, 0, 100, HCSCREEN_HEIGHT/12.6) text:@"" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:13] tag:101 hasShadow:NO isCenter:NO];
    [_mViewMy addSubview:self.correct_phone];
    _strPhone = self.correct_phone.text;
    
    UITapGestureRecognizer *tapButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhone:)];
    self.mViewChoice.userInteractionEnabled = YES;
    tapButton.delegate = self;
    tapButton.numberOfTapsRequired = 1;
    [_mViewMy addGestureRecognizer:tapButton];
    

   self.vehicle_id = [UILabel labelWithFrame:CGRectMake(10, 0, 100, self.vehicleImage.height/6) text:@"编号:0" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] tag:101 hasShadow:NO isCenter:NO];
    [_mViewMin addSubview:self.vehicle_id];
    
    UILabel *mViewDetails = [UILabel labelWithFrame:CGRectMake(self.vehicle_id.right, 0, HCSCREEN_WIDTH-self.vehicle_id.right-10, self.vehicleImage.height/6) text:@"点击图片查看详情" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] tag:101 hasShadow:NO isCenter:NO];
    mViewDetails.textAlignment = NSTextAlignmentRight;
    [_mViewMin addSubview:mViewDetails];

    [self viewCar:CGRectMake(0, _mViewMy.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT/9) MySaleVehicles:mySaleVehicle];
    [self viewPrice:CGRectMake(0, _mViewCar.bottom, HCSCREEN_WIDTH, HCSCREEN_HEIGHT/6) MySaleVehicles:mySaleVehicle];
    [self addSubview:_mView];
}

- (NSString*)apeendimageurl:(NSString*)imageurl{
    NSString *Imageurl = [NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",imageurl,(int)HCSCREEN_WIDTH,(int)HCSCREEN_WIDTH*480/640];
    return Imageurl;
}

- (void)tapPiture:(UIGestureRecognizer *)ger
{
    [HCAnalysis HCUserClick:@"myvehicle_sale_detail"];
    if (self.delegate) {
        [self.delegate vehicleDetails];
    }
}

- (void)tap:(UIGestureRecognizer *)ger
{
    if (self.delegate) {
        [self.delegate priceSaleStatus];
    }
}

- (void)viewCar:(CGRect)rect MySaleVehicles:(MySaleVehicles *)mySaleVehicle
{
    _mViewCar = [[UIView alloc]initWithFrame:rect];
    _imaegViewPiture = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH*0.8, -5, HCSCREEN_WIDTH/7, HCSCREEN_WIDTH/7)];
    _imaegViewPiture.image = [UIImage imageNamed:@"sold_icon"];
    [_mViewCar addSubview:_imaegViewPiture];
   _mOwnerText = [UILabel labelWithFrame:CGRectMake(0, 5, HCSCREEN_WIDTH, _mViewCar.height/3) text:@"成交价格" textColor:nil font:[UIFont systemFontOfSize:17] tag:101 hasShadow:NO isCenter:YES];
    self.seller_price = [[UILabel alloc]initWithFrame:CGRectMake(0, _mOwnerText.bottom+10, HCSCREEN_WIDTH, _mViewCar.height/3)];
    self.seller_price.textAlignment = NSTextAlignmentCenter;
     NSString *priceText = [NSString stringWithFormat:@"%@万", mySaleVehicle.seller_price];
    self.seller_price.attributedText = [NSString setPriceFormat:priceText];

    [_mViewCar addSubview:self.seller_price];
    
    [_mViewCar addSubview:_mOwnerText];
    [_mView addSubview:_mViewCar];
}

- (void)viewPrice:(CGRect)rect MySaleVehicles:(MySaleVehicles *)mySaleVehicle
{
  
    _mAdjustment = [[UIView alloc]initWithFrame:rect];
    UIView *mViewLone = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 0.5)];
    mViewLone.alpha = 0.4;
    self.suggest_text = [UILabel labelWithFrame:CGRectMake(0, 8, HCSCREEN_WIDTH, 25) text:@" " textColor:nil font:[UIFont systemFontOfSize:12] tag:101 hasShadow:NO isCenter:YES];
    [self.suggest_text sizeToFit];
    self.eval_price = [UILabel labelWithFrame:CGRectMake(self.suggest_text.right, 8, HCSCREEN_WIDTH, 25) text:@"0" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:12] tag:101 hasShadow:NO isCenter:YES];
    [self setAttribute:mySaleVehicle boolShow:NO];
    self.adjustBtn =[UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH/3, self.suggest_text.bottom+8, HCSCREEN_WIDTH/3,_mAdjustment.height/2.8) title:@"111" titleColor: PRICE_STY_CORLOR titleHighlightColor:nil titleFont:[UIFont systemFontOfSize:13] image:nil tappedImage:nil target:self action:@selector(cityBtnClick:) tag:102];
    [self.adjustBtn.layer setCornerRadius:3.0];
    [self.adjustBtn.layer setMasksToBounds:YES];
    [self.adjustBtn.layer setBorderWidth:1.0];
    [self.adjustBtn.layer setBorderColor:[PRICE_STY_CORLOR CGColor]];
    [_mAdjustment addSubview:mViewLone];
    [_mAdjustment addSubview:self.adjustBtn];
    [_mAdjustment addSubview:self.suggest_text];
    [_mAdjustment addSubview:self.eval_price];
    [_mView addSubview:_mAdjustment];
    
}

- (void)setAttribute:(MySaleVehicles *)vehicle boolShow:(BOOL)yes
{
    if (yes == YES)
    {
    _mAdjustment.hidden = NO;
    self.suggest_text.hidden = YES;
    self.eval_price.hidden = NO;
    self.correct_text.text= vehicle.correct_text;
        NSString *priceText = [NSString stringWithFormat:@"%@万", vehicle.seller_price];
        self.seller_price.attributedText = [NSString setPriceFormat:priceText];
    self.eval_price.text =vehicle.eval_price;
    [self.eval_price sizeToFit];
    [self.adjustBtn setTitle:vehicle.adjust_text forState:UIControlStateNormal];
    _adjusPhone = vehicle.adjust_phone;
    self.suggest_text.text = vehicle.suggest_text;
   }
        [self.suggest_text sizeToFit];
        if ([vehicle.eval_price isEqualToString:@"0"]) {
            self.eval_price.hidden= YES;
            self.suggest_text.frame = CGRectMake((HCSCREEN_WIDTH-self.suggest_text.width)/2, 8, self.suggest_text.width, 25);
        }else{
            self.eval_price.hidden= NO;
            self.suggest_text.frame = CGRectMake((HCSCREEN_WIDTH-self.suggest_text.width-self.eval_price.width)/2, 8, self.suggest_text.width, 25);
            self.eval_price.frame = CGRectMake(self.suggest_text.right, 8, self.eval_price.width, 25);
        }
}

- (void)vehicle:(MySaleVehicles *)vehicle
{
    if (vehicle.vehicle_name == nil || vehicle.brand_id == nil) {
        self.vehicle_name.textAlignment = NSTextAlignmentCenter;
        self.vehicle_name.text = @"您的爱车暂未上线";
        self.vehicle_name.textAlignment = NSTextAlignmentCenter;
        [self.vehicleBrandImage setImage:nil];
        [self reloadInputViews];
    }else{
        self.vehicle_name.textAlignment = NSTextAlignmentLeft;
    }
}


- (void)saleStatus:(MySaleVehicles*)vehicle
{
    if (STATUS == SaleStatusOffTheShelf) {
        [self setFrame:0 and:-1];
    }else if (STATUS == SaleStatusNotSubmitted){
        [self hidden:YES];
         _verticalLine.hidden = YES;
        [self setFrame:0 and:2];
    }else if (STATUS == SaleStatusOffline){
        [self setAttribute:vehicle boolShow:YES];
        if (iPhone4s) {
            [self setFrame:HCSCREEN_HEIGHT/2.36+self.vehicleImage.height/6+HCSCREEN_HEIGHT/9+HCSCREEN_HEIGHT/6+40 and:3];
        }else{
        [self setFrame:HCSCREEN_HEIGHT/2.36+self.vehicleImage.height/6+HCSCREEN_HEIGHT/9+HCSCREEN_HEIGHT/6 and:3];
        }
        self.suggest_text.hidden = NO;
        [self hidden:NO];
         _verticalLine.hidden = NO;
        _imaegViewPiture.hidden = YES;
        [self setName:vehicle];
    }else if (STATUS == SaleStatusNotShown){
        [self hidden:NO];
        self.vehicleImage.hidden = NO;
         _imaegViewPiture.hidden = NO;
         _verticalLine.hidden = NO;
        if (iPhone4s) {
            [self setFrame:HCSCREEN_HEIGHT/2.36+self.vehicleImage.height/6+HCSCREEN_HEIGHT/8+40 and:4];
        }else{
            [self setFrame:HCSCREEN_HEIGHT/2.36+self.vehicleImage.height/6+HCSCREEN_HEIGHT/8 and:4];
 
        }
    self.suggest_text.hidden = YES;
        _mAdjustment.hidden = YES;
        [self setName:vehicle];
    }else if (STATUS == SaleStatusSucceess){
        [self setFrame:0 and:1];
    }
}

- (void)updateViewData:(MySaleVehicles*)vehicle
{
    [self saleStatus:vehicle];
    
}

- (void)updateHeight:(CGFloat)heigit and:(int)status
{
    if (self.delegate) {
        [self.delegate updateViewHeight:heigit and:status];
    }
}

#pragma mark - PrivateVariable
- (void)setName:(MySaleVehicles *)vehicle
{
    self.vehicle_name.text = vehicle.vehicle_name;
    [self.vehicleBrandImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",vehicle.brand_id]]];
    [self.adjustBtn setTitle:vehicle.adjust_text forState:UIControlStateNormal];
    self.vehicle_id.text = [NSString stringWithFormat:@"编号:%ld",(long)vehicle.vehicle_source_id];
    [self.vehicleImage sd_setImageWithURL:[NSURL URLWithString:[self apeendimageurl:vehicle.cover_image]] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    if (vehicle.status==3) {
        _mOwnerText.text = @"您的报价";
    }else if(vehicle.status==4){
        _mOwnerText.text = @"成交价格";
    }
    self.correct_phone.text = vehicle.correct_phone;
    
    self.correct_text.text = vehicle.correct_text;
    _strPhone = self.correct_phone.text;
    NSString *priceText = [NSString stringWithFormat:@"%@万", vehicle.seller_price];
    self.seller_price.attributedText = [NSString setPriceFormat:priceText];
    _strPhone = vehicle.adjust_phone;
    self.correct_phone.text = vehicle.correct_phone;
    _adjusPhone = vehicle.adjust_phone;
}

- (void)setFrame:(int)height and:(int)status
{
    self.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, height);
    _mView.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, height);
    [self updateHeight:height and:status];
}

- (void)hidden:(BOOL)show
{
    _mViewCar.hidden = show;
    _mAdjustment.hidden = show;
    _mViewMin.hidden = show;
    _mViewMy.hidden = show;
    self.vehicleImage.hidden = show;
}

- (void)cityBtnClick:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:_strPhone message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [HCAnalysis HCUserClick:@"mAdjustPrice"];
    if (alertView.tag != 1001) {
        if (buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.correct_phone.text]]];
        }
    }else{
        if (buttonIndex == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_adjusPhone]]];
        }
    }
    
}

- (void)tapPhone:(UIGestureRecognizer *)gest
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:self.correct_phone.text message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1002;
    [alertView show];
}



@end
