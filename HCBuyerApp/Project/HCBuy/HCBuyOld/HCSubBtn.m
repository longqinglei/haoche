//
//  HCSubBtn.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/9.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCSubBtn.h"
#import "DataFilter.h"
@implementation HCSubBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithSubCond:(id)cond{
    self = [super init];
    if (self) {
        [self drawLayer];
        self.subCond = cond;
        [self setTitleWithCond:cond];
        
       //[self setTitle:self.priceCond.desc forState:UIControlStateNormal];
    }
    return self;
    
}
- (void)drawLayer{
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //[self setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    //[self setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xf5f5f5) andSize:CGSizeMake((HCSCREEN_WIDTH - 43)/4, ((HCSCREEN_WIDTH - 43)/4)*0.48)] forState:UIControlStateHighlighted];
    [self setTitleColor: UIColorFromRGBValue(0x626262) forState:UIControlStateNormal];
    // self.titleLabel.textColor = UIColorFromRGBValue(0x212121);
    self.backgroundColor = UIColorFromRGBValue(0xf9f9f9);
    self.layer.borderColor = UIColorFromRGBValue(0xe0e0e0).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 0.5;
    self.layer.masksToBounds = YES;
    [self setTitleColor:UIColorFromRGBValue(0x656565) forState:UIControlStateNormal];
}
//根据不同的cond设置button的title
- (void)setTitleWithCond:(id)cond{
    if ([cond isKindOfClass:[BrandSeriesCond class]]) {
        BrandSeriesCond *idcond = (BrandSeriesCond*)cond;
        NSString *vehicleName;
        if (idcond.seriesName&&idcond.seriesName.length !=0) {
            vehicleName = [NSString stringWithFormat:@"%@·%@",idcond.brandName,idcond.seriesName];
        }else{
            vehicleName = idcond.brandName;
        }
        [self setTitle:vehicleName forState:UIControlStateNormal];
    }
    
    if ([cond isKindOfClass:[PriceCond class]]) {
        PriceCond *idcond = (PriceCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[AgeCond class]]) {
        AgeCond *idcond = (AgeCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[GearboxCond class]]) {
        GearboxCond *idcond = (GearboxCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[EmissionCond class]]) {
        EmissionCond *idcond = (EmissionCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[MilesCond class]]) {
        MilesCond *idcond = (MilesCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[StructureCond class]]) {
        StructureCond *idcond = (StructureCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[EmissionStandarCond class]]) {
        EmissionStandarCond *idcond = (EmissionStandarCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[ColorCond class]]) {
        ColorCond *idcond = (ColorCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[CountryCond class]]) {
        CountryCond *idcond = (CountryCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[PatternCond class]]) {
        PatternCond *idcond = (PatternCond*)cond;
        [self setTitle:idcond.desc forState:UIControlStateNormal];
        
    }
    if ([cond isKindOfClass:[NSString class]]) {
        NSString *idcond = (NSString*)cond;
        [self setTitle:idcond forState:UIControlStateNormal];
        
    }
    
    
}
@end
