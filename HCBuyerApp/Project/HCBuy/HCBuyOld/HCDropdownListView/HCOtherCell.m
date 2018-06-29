//
//  HCOtherCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCOtherCell.h"
#import "HCOtherSelectBtn.h"
#import "HCOtherColorBtn.h"
#import "UIImage+RTTint.h"
#import "DataFilter.h"
@implementation HCOtherCell


- (id)initWithCondArray:(NSArray*)condArray withTitle:(NSString*)title type:(int)type withReuseid:(NSString *)reuseid{
    self = [super init];
    if (self) {
        if (!self.selectArray) {
            self.selectArray = [[NSMutableArray alloc]init];
        }
        self.condArray = condArray;
        self.reuseid =reuseid;
        UILabel *titleLabel = [[ UILabel alloc]init];
        titleLabel.frame = CGRectMake(15, 15, 100, 14);
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromRGBValue(0x424242);
        [self addSubview:titleLabel];
        [self createMainView:condArray];
        [self createRightBtn];
        [self createBtnWithcondArray:condArray Type:type];
    }
    return self;
}

-(void)createBtnWithcondArray:(NSArray *)condArray Type:(int)type{
    CGFloat btnWidth = (HCSCREEN_WIDTH*0.85-50)/3;
    if (type==0) {
        for (int i = 0; i < condArray.count-1; i++) {
            int row = i/3;
            int list = i%3;
            id cond = [condArray objectAtIndex:i+1];
            HCOtherSelectBtn *btn = [[HCOtherSelectBtn alloc]initWithFrame:CGRectMake(15+list*(btnWidth+10), row*(32+10), btnWidth, 32)withCond:cond];
            [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainView addSubview:btn];
            [self.selectArray addObject:btn];
        }

    }else if(type==1){
        for (int i = 0; i < condArray.count-1; i++) {
            int row = i/3;
            int list = i%3;
            id cond = [condArray objectAtIndex:i+1];
            HCOtherColorBtn *btn = [[HCOtherColorBtn alloc]initWithFrame:CGRectMake(15+list*(btnWidth+10), row*(32+10), btnWidth, 32)withCond:cond];
            [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainView addSubview:btn];
            [self.selectArray addObject:btn];
        }
    }else{
        for (int i = 0; i < condArray.count-1; i++) {
            int row = i/3;
            int list = i%3;
            id cond = [condArray objectAtIndex:i+1];
                HCOtherColorBtn *btn = [[HCOtherColorBtn alloc]initWithFrame:CGRectMake(15+list*(btnWidth+10), row*(32+10), btnWidth, 32)withCond:cond];
                [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.mainView addSubview:btn];
                [self.selectArray addObject:btn];
        }
    }
}
- (NSString *)reuseIdentifier{
    return self.reuseid;
}
- (void)createRightBtn{
    self.rightBth = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightImage = [[UIImageView alloc]init];
    self.rightImage.frame = CGRectMake(HCSCREEN_WIDTH*0.85-20, 19.5, 5, 3);
    self.rightImage.image = [[UIImage imageNamed:@"pulldown"] rt_tintedImageWithColor:UICOLOC];
    [self addSubview:self.rightImage];
    
    self.rightBth.frame = CGRectMake(self.rightImage.left-HCSCREEN_WIDTH*0.85+30, 0, HCSCREEN_WIDTH*0.85-35, 44);
    self.rightBth.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
    [self.rightBth setTitle:@"不限" forState:UIControlStateNormal];
    self.rightBth.backgroundColor = [UIColor clearColor];
    self.rightBth.titleLabel.textAlignment = NSTextAlignmentRight;
    self.rightBth.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight ;
    //[self.rightBth setImage:[[UIImage imageNamed:@"pulldown"] rt_tintedImageWithColor:UICOLOC] forState:UIControlStateNormal];
    //[self.rightBth horizontalCenterTitleAndImageRight:10];
    //self.rightBth.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.rightBth];
}
- (void)createMainView:(NSArray*)condarray{
    int row = (int)(condarray.count-1)/3+1;
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, HCSCREEN_WIDTH*0.85, 47*row)];
    self.mainView.hidden = YES;
    [self addSubview:self.mainView];
}
-(void)selectBtnClick:(HCOtherSelectBtn*)btn{
    for (HCOtherSelectBtn *other in self.selectArray) {
        if (other!=btn) {
            [other setStateUnSelect];
        }
    }
    if (btn.selectState ==YES) {
        if (self.delegate) {
            [self.delegate othercellBtnClick:[self.condArray objectAtIndex:0]];
        }
        [btn setStateUnSelect];
    }else{
        if (self.delegate) {
            [self.delegate othercellBtnClick:btn.cond];
        }
        [btn setStateSelect];
    }
    
}
-(void)colorBtnClick:(HCOtherColorBtn*)btn{
    for (HCOtherColorBtn *other in self.selectArray) {
        if (other!=btn) {
            [other setStateUnSelect];
        }
    }
    if (btn.selectState ==YES) {
        if (self.delegate) {
            [self.delegate cellcolorClick:[self.condArray objectAtIndex:0]];
        }
        [btn setStateUnSelect];
    }else{
        if (self.delegate) {
            [self.delegate cellcolorClick:btn.cond];
        }
        [btn setStateSelect];
    }
    
}
- (void)setSelectCond:(id)cond{
    for (HCOtherSelectBtn *other in self.selectArray) {
        if ([other isKindOfClass:[HCOtherSelectBtn class]]) {
            [other setStateUnSelect];
            if ([cond isKindOfClass:[GearboxCond class]]) {
                GearboxCond *cond1 = (GearboxCond*)cond;
                GearboxCond *cond2 = (GearboxCond*)other.cond;
                if (cond1.type==cond2.type) {
                    [other setStateSelect];
                }
            }
            if ([cond isKindOfClass:[EmissionStandarCond class]]) {
                EmissionStandarCond *cond1 = (EmissionStandarCond*)cond;
                EmissionStandarCond *cond2 = (EmissionStandarCond*)other.cond;
                if (cond1.from==cond2.from) {
                    [other setStateSelect];
                }
            }
            if ([cond isKindOfClass:[EmissionCond class]]) {
                EmissionCond *cond1 = (EmissionCond*)cond;
                EmissionCond *cond2 = (EmissionCond*)other.cond;
                if (cond1.from==cond2.from) {
                    [other setStateSelect];
                }
            }
        }
    }
    for (HCOtherColorBtn *other in self.selectArray) {
        if ([other isKindOfClass:[HCOtherColorBtn class]]) {
        if ([cond isKindOfClass:[ColorCond class]]) {
            ColorCond *cond1 = (ColorCond*)cond;
            ColorCond *cond2 = (ColorCond*)other.cond;
            if ([cond1.desc isEqualToString:cond2.desc]) {
                [other setStateSelect];
            }
        }
            if ([cond isKindOfClass:[CountryCond class]]) {
                CountryCond *cond1 = (CountryCond*)cond;
                CountryCond *cond2 = (CountryCond*)other.cond;
                if ([cond1.desc isEqualToString:cond2.desc]) {
                    [other setStateSelect];
                }
            }
        }
    }

}
- (void)resetCondBtnState{
    for (HCOtherSelectBtn *other in self.selectArray) {
        [other setStateUnSelect];
    }
    for (HCOtherColorBtn *other in self.selectArray) {
        [other setStateUnSelect];
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
