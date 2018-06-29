//
//  subSettingCellTableViewCell.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "subCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MyVehicle.h"
#import "AutoSeries.h"
#import "BizBrandSeries.h"
#import "BrandSeries.h"
#import "City.h"
#import "AutoSeries.h"
#import "BizCity.h"
#import "DataFilter.h"
@implementation subCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getBrandNameFrom:(NSInteger)brand_id;
{
    NSString *strName;
    NSArray *arrr = [BrandSeries getBrandSeriesList:[BizCity getCurCity].cityId];
    for (BrandSeries *seee in arrr) {
        if (seee.brandId == brand_id) {
            strName = seee.brandName;
           // NSLog(@"brand Name %@",seee.brandName);
        }
    }
    return strName;
    
}

//- (void)drawRect:(CGRect)rect{
//    
//    
//    
//}
- (NSString*)geerbox:(NSString*)gearbox
{
    switch ([gearbox intValue]) {
        case 0: return @"不限";
        case 1: return @"手动";
        case 2: return @"自动";
        case 3: return @"双离合";
        case 4: return @"手自一体";
        case 5: return @"无级变速";
    }
    return @"...";
}
- (void)initCellWithRet :(SubscriptionModelCar *)coupone
{
    NSString *strGeerbox;
    NSString *strprice;
    NSString *CityName;
    NSString *strMiles;
    NSString *strYear;
    NSString *em_stander;
    NSString *strCountry;
    NSString *strColor;
    if (self.selectBtn==nil) {
        self.selectBtn = [[UIImageView alloc]init];
        self.selectBtn.frame = CGRectMake(HCSCREEN_WIDTH - 42, 13, 20 , 20);
        self.selectBtn.image = [UIImage imageNamed:@"ImageAddSeber"];
        [self.contentView addSubview:self.selectBtn];
    }
    self.selectBtn.hidden = YES;
    self.priceLabel.textColor = UIColorFromRGBValue(0x424242);
    self.carName.textColor = UIColorFromRGBValue(0x424242);
    if ([coupone.year_high isEqualToString:@"0"]&&[coupone.year_low isEqualToString:@"0"]) {
        strYear = [NSString stringWithFormat:@"车龄不限・"];
    }else{
        if ([coupone.year_high isEqualToString:@"0"]&&![coupone.year_low isEqualToString:@"0"]) {
            strYear = [NSString stringWithFormat:@"%@年以上",coupone.year_low];
            
        }else{
            if([coupone.year_low isEqualToString:@"8"]){
                strYear = [NSString stringWithFormat:@"%@年以上",coupone.year_low];
            }else{
                strYear = [NSString stringWithFormat:@"%@～%@年",coupone.year_low,coupone.year_high];}
        }
    }
    
    if ([coupone.price_high isEqualToString:@"0"] && [coupone.price_low isEqualToString:@"0"]) {
        strprice = [NSString stringWithFormat:@"价格不限"];
    }else{
        
        if ([coupone.price_high isEqualToString:@"0"]&&![coupone.price_low isEqualToString:@"0"]) {
            strprice = [NSString stringWithFormat:@"%@万元以上",coupone.price_low];
        }else{
            if ([coupone.price_low isEqualToString:@"1000"]) {
                strprice = [NSString stringWithFormat:@"%@万元以上",coupone.price_low];
            }else{
            
                strprice = [NSString stringWithFormat:@"%@～%@万元",coupone.price_low,coupone.price_high];
            }
        }
    }
    if (coupone.country.length!=0) {
        strCountry = [CountryCond getDescByPInyin:coupone.country];
    }else{
        strCountry = @"国别不限";
    }
    if (coupone.color.length!=0) {
        strColor = coupone.color;
    }else{
        strColor = @"颜色不限";
    }
    CityName = [City getCityNameById:[coupone.city_id  integerValue]];
    if ([coupone.miles_high isEqualToString:@"0"]&&[coupone.miles_low isEqualToString:@"0"]) {
        strMiles = @"公里不限";
    }else{
        if ([coupone.miles_high isEqualToString:@"0"]&&![coupone.miles_low isEqualToString:@"0"]) {
      strMiles = [NSString stringWithFormat:@"%@万公里以上",coupone.miles_low];
        }else{
            if ([coupone.miles_low isEqualToString:@"8"]) {
                 strMiles = [NSString stringWithFormat:@"%@万公里以上",coupone.miles_low];
            }else{
                strMiles = [NSString stringWithFormat:@"%@~%@万公里",coupone.miles_low,coupone.miles_high];
            }
        }
    }
    if ([coupone.geerbox isEqualToString:@"0"]) {
        strGeerbox = @"挡位不限";
    }else{
        
        strGeerbox = [NSString stringWithFormat:@"%@",coupone.geerbox];
    }
    NSString *strEmission;
    if ([coupone.emission_low isEqualToString:@"0"] && [coupone.emission_high isEqualToString:@"0"]) {
        strEmission = @"排量不限";
    }else{
        
        if ([coupone.emission_high isEqualToString:@"0"] && ![coupone.emission_low isEqualToString:@"0"]) {
            strEmission = [NSString stringWithFormat:@"%@升以上",coupone.emission_low];
        }else{
            if ([coupone.emission_low isEqualToString:@"4.1"]) {
                strEmission = [NSString stringWithFormat:@"%@升以上",coupone.emission_low];
            }else{
            
                strEmission = [NSString stringWithFormat:@"%@~%@升",coupone.emission_low,coupone.emission_high];}
        }
    }
    NSString *strture;
    if ([coupone.structure isEqualToString:@"1"]) {
        strture = @"两箱车";
    }else if ([coupone.structure isEqualToString:@"0"]){
        strture = @"车身构造不限";
    }else if ([coupone.structure isEqualToString:@"2"]){
        strture = @"三箱车";
    }else if ([coupone.structure isEqualToString:@"3"]){
        strture = @"SUV";
    }else if ([coupone.structure isEqualToString:@"4"]){
        strture = @"MVP";
    }else if ([coupone.structure isEqualToString:@"5"]){
        strture = @"旅行车";
    }else if ([coupone.structure isEqualToString:@"8"]){
        strture = @"面包车";
    }else {
        strture = @"其他车辆";
    }
    if ([coupone.es_standard isEqualToString:@"-1"]) {
        em_stander =@"排放不限";
    }else  if ([coupone.es_standard isEqualToString:@"1"]) {
        em_stander = @"国三";
    }else  if ([coupone.es_standard isEqualToString:@"2"]) {
        em_stander =@"国四";
    }else  if ([coupone.es_standard isEqualToString:@"3"]) {
        em_stander = @"国五";
    }
     NSMutableArray *allStrArray = [[NSMutableArray alloc]initWithObjects:CityName,strprice,strMiles,strGeerbox,strEmission,strture,strYear,em_stander,strCountry,strColor,nil];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    for (NSString *Cstr in allStrArray) {
        if ([Cstr rangeOfString:@"不限"].location== NSNotFound) {
            [arr1 addObject:Cstr];
        }
    }
    
    NSString *myladStr = @"";
    for (NSString *str in arr1) {
        
        if ([str isEqualToString: [arr1 HCObjectAtIndex:0]]) {
            myladStr = [myladStr stringByAppendingString:str];
        }else{
            myladStr = [myladStr stringByAppendingString:[NSString stringWithFormat:@"・%@",str]];
        }
    }
    if (arr1.count <= 1) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@・%@・%@・%@·%@·%@",myladStr,strprice,strMiles,strGeerbox,strColor,strCountry];
    }else{
         self.priceLabel.text = myladStr;
    }
    
    self.subid.text = [NSString stringWithFormat:@"%@",coupone.ID];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", coupone.brand_id];
   
    UIImage *brandImage = [UIImage imageNamed:imageName];
    if (brandImage == nil) {
        UIImageView *imagePrture = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noState"]];
        imagePrture.frame =CGRectMake(15, 9, 33, 33);
        self.carName.text = @"品牌不限";
        [self.contentView addSubview:imagePrture];
    }else{
        if ([coupone.class_id isEqualToString:@"0"]) {
            self.carName.text = [self getBrandNameFrom:[coupone.brand_id integerValue]];

        }else{
            self.carName.text = [AutoSeries getSeriesNamesByseries_id:[coupone.class_id integerValue]];
        }
        [self.imageViewCar setImage:brandImage];
    }
    
}


@end
