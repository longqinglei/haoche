//
//  HCTestingTableView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCTestingTableView.h"
#import "UIImageView+WebCache.h"
#import "HCBannerView.h"
@interface HCTestingTableView()<HCBannerViewClickDelegate>
@property (nonatomic, strong) HCBannerView *topBanner;

@property (strong, nonatomic) NSDictionary *mDataDic;

//@property (strong, nonatomic) UIImageView *UrlWithImage;

@property (nonatomic,strong)NSString *PushUrl;


@end

@implementation HCTestingTableView

- (id)initWithFrame:(CGRect)frame data:(NSArray *)bannerArray;
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    if (self) {
        if (bannerArray.count==0) {
           [self createTopBannerView:bannerArray];
        }
        [self createOtherPart];
    }
    return self;
}

- (void)createOtherPart{
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(HCSCREEN_WIDTH-64, HCSCREEN_WIDTH*0.933-22, 44, 44);
    [self.searchButton setImage:[UIImage imageNamed:@"HomeSearch"] forState:UIControlStateNormal];
    // [self.searchButton setImage:[UIImage imageNamed:@"searchHover"] forState:UIControlStateHighlighted];
    [self.searchButton addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchButton];
    
    self.cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    self.cityButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    self.cityButton.frame = CGRectMake(20, HCSCREEN_WIDTH*0.933+20, 80, 30);
    [self.cityButton setImage:[UIImage imageNamed:@"cityIcon"] forState:UIControlStateNormal];
    // [self.cityButton setTitle:@"北京" forState:UIControlStateNormal];
    [self.cityButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xe0e0e0) andSize:CGSizeMake(80, 30)] forState:UIControlStateHighlighted];
    [self.cityButton setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
    [self.cityButton.layer setMasksToBounds:YES];
    self.cityButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.cityButton.layer.cornerRadius = 2;
    [self.cityButton.layer setBorderWidth:0.5];
    self.cityButton.layer.borderColor =[UIColorFromRGBValue(0xe0e0e0) CGColor];
    [self.cityButton addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cityButton];
    
    self.vehicleNumLabel = [[UILabel alloc]init];
    self.vehicleNumLabel.frame = CGRectMake(self.cityButton.right+10, self.cityButton.top, HCSCREEN_WIDTH-110, 30);
    self.vehicleNumLabel.text = @"";
    self.vehicleNumLabel.font  = [UIFont systemFontOfSize:30.0];
    self.vehicleNumLabel.textColor = UIColorFromRGBValue(0xff2626);
    self.vehicleNumLabel.attributedText = [NSString setHomeVehicleNum:@""];
    [self addSubview:self.vehicleNumLabel];
}
- (void)searchBtnClick:(UIButton*)btn{
    if (self.delegate) {
        [self.delegate searchBtnClick];
    }
    
}
- (void)cityBtnClick:(UIButton*)btn{
    if (self.delegate) {
        [self.delegate cityBtnClick];
    }
    
}
- (void)networkerror{
    [self.topBanner networkerror];
}
- (void)resetSliderView:(NSArray*)sliderList{
    [self.topBanner setTopBannerData:sliderList];
}

- (void)createTopBannerView:(NSArray *)bannerArray{
    if (self.topBanner==nil) {
        self.topBanner = [[HCBannerView  alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.933) data:bannerArray controlStyle:1];
        
        self.topBanner.backgroundColor = [UIColor grayColor];
        self.topBanner.delegate = self;
        [self addSubview:self.topBanner];
    }
}
- (void)bannerClick:(Banner *)banner{
    if (self.delegate) {
        [self.delegate topBrannerClick:banner];
    }
}

- (void)resetVehicleNum:(NSString *)vehicleNum{
    NSString *vehicleNumStr = [NSString stringWithFormat:@"%@辆车供您选择!",vehicleNum];
    self.vehicleNumLabel.attributedText = [NSString setHomeVehicleNum:vehicleNumStr];
    
}


@end
