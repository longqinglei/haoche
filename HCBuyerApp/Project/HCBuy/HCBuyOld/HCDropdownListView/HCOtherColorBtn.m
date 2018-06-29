//
//  HCOtherColorBtn.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCOtherColorBtn.h"
#import "DataFilter.h"
@interface HCOtherColorBtn()
@property (nonatomic,strong)UIImageView * closeView;
@end
@implementation HCOtherColorBtn


- (id)initWithFrame:(CGRect)frame withCond:(id)cond{
    self =[super initWithFrame:frame];
    if (self) {
        self.cond = cond;
        self.closeView = [[UIImageView alloc]init];
        self.closeView.frame = CGRectMake(frame.size.width-16, frame.size.height-16, 16, 16);
        self.closeView.image = [UIImage imageNamed:@"cancle"];
        [self addSubview:self.closeView];
        [self createColorCond:cond];
        self.titleLabel.font  = [UIFont systemFontOfSize:12];
       // [self setTitle:[self getTitleFrom:cond] forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
        self.layer.borderWidth =0.5;
        self.layer.cornerRadius = 0.5;
        self.layer.borderColor = UIColorFromRGBValue(0xe0e0e0).CGColor;
        self.layer.masksToBounds = YES;
        self.closeView.hidden = YES;
        self.selectState = NO;
    }
    return self;
}
- (void)createColorCond:(id)cond{
    if ([cond isKindOfClass:[ColorCond class]]) {
        ColorCond*colorcond =(ColorCond*)cond;
        [self horizontalCenterImageAndTitle: 5];
        [self setImage:[UIImage imageNamed:colorcond.imageName] forState:UIControlStateNormal];
        [self setTitle:colorcond.desc forState:UIControlStateNormal];
    }
    if ([cond isKindOfClass:[CountryCond class]]) {
        CountryCond*countrycond =(CountryCond*)cond;
        if (countrycond.imageName!=nil) {
             [self horizontalCenterImageAndTitle: 5];
            [self setImage:[UIImage imageNamed:countrycond.imageName] forState:UIControlStateNormal];
        }
        [self setTitle:countrycond.desc forState:UIControlStateNormal];
    }
    
}
//- (void)createCoverView:(ColorCond*)cond{
//    UIView *view = [[UIView alloc]init];
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self.target action:self.selector];
//    gesture.delegate = self.target;
//    gesture.numberOfTapsRequired = 1;
//    [view addGestureRecognizer:gesture];
//    view.userInteractionEnabled  = YES;
//    view.frame = CGRectMake(0, 0, (HCSCREEN_WIDTH - 43)/4, ((HCSCREEN_WIDTH - 43)/4)*0.48);
//    NSString *imageName = [NSString stringWithFormat:@"%ld.png",(long)cond.brandId];
//    UIImageView *brandImage =[[UIImageView alloc]init];
//    brandImage.frame = CGRectMake(0, (((HCSCREEN_WIDTH - 43)/4)*0.48-15)/2, 15, 15);
//    brandImage.image = [UIImage imageNamed:imageName];
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.frame = CGRectMake(brandImage.right+5, (((HCSCREEN_WIDTH - 43)/4)*0.48-15)/2, 20, 15);
//    titleLabel.font =  [UIFont systemFontOfSize:12];
//    titleLabel.textColor = UIColorFromRGBValue(0x424242);
//    titleLabel.text = cond.brandName;
//    [titleLabel sizeToFit];
//    if (titleLabel.width+brandImage.width+5>=(HCSCREEN_WIDTH - 45)/4) {
//        [titleLabel setWidth:titleLabel.width-10];
//    }
//    [view setWidth:titleLabel.width+brandImage.width+5];
//    [view setLeft:((HCSCREEN_WIDTH - 45)/4-view.width)/2];
//    [view addSubview:brandImage];
//    [view addSubview:titleLabel];
//    [self addSubview:view];
//}
- (NSString*)getTitleFrom:(id)cond{
    if ([cond isKindOfClass:[AgeCond class]]) {
        return ((AgeCond *)cond).desc;
    }
    if ([cond isKindOfClass:[MilesCond class]]) {
        return ((MilesCond *)cond).desc;
    }
    if ([cond isKindOfClass:[GearboxCond class]]){
        return ((GearboxCond *)cond).desc;
    }
    if ([cond isKindOfClass:[EmissionStandarCond class]]) {
        return ((EmissionStandarCond *)cond).desc;
    }
    if ([cond isKindOfClass:[EmissionCond class]]) {
        return ((EmissionCond *)cond).desc;
    }
    return @"";
}
- (void)setStateSelect{
    self.selectState = YES;
    self.closeView.hidden = NO;
    self.layer.borderColor = PRICE_STY_CORLOR.CGColor;
    self.backgroundColor = UIColorFromRGBValue(0xfff0f0);
    [self setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
    
}
- (void)setStateUnSelect{
    self.selectState = NO;
    self.closeView.hidden = YES;
    self.layer.borderColor = UIColorFromRGBValue(0xe0e0e0).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
