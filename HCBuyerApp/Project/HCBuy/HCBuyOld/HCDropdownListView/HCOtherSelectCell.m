//
//  HCOtherSelectCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/13.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCOtherSelectCell.h"
#import "HCOtherSelectBtn.h"
#import "DataFilter.h"
#import "HCVehicleStruBtn.h"
@implementation HCOtherSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithCondArray:(NSArray*)condArray withTitle:(NSString*)title withreuseid:(NSString *)reuseid{
    self = [super init];
    if (self) {
        if (!self.selectArray) {
            self.selectArray = [[NSMutableArray alloc]init];
        }
        self.condArray = condArray;
        UILabel *titleLabel = [[ UILabel alloc]init];
        titleLabel.frame = CGRectMake(15, 15, 100, 14);
        titleLabel.text = title;
        self.reuseid = reuseid;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromRGBValue(0x424242);
        [self addSubview:titleLabel];
        CGFloat btnWidth = (HCSCREEN_WIDTH*0.85-50)/3;
        for (int i = 0; i < condArray.count-1; i++) {
            int row = i/3;
            int list = i%3;
            id cond = [condArray objectAtIndex:i+1];
            HCOtherSelectBtn *btn = [[HCOtherSelectBtn alloc]initWithFrame:CGRectMake(15+list*(btnWidth+10), titleLabel.bottom+15+row*(32+10), btnWidth, 32)withCond:cond];
            [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.selectArray addObject:btn];
        }
    }
    return self;
}
- (id)initWithStruCond:(NSArray*)StruCondArray withTitle:(NSString*)title withreuseid:(NSString *)reuseid{
    self = [super init];
        if (self) {
            if (!self.selectArray) {
            self.selectArray = [[NSMutableArray alloc]init];
        }
        self.reuseid= reuseid;
        self.condArray = StruCondArray;
        UILabel *titleLabel = [[ UILabel alloc]init];
        titleLabel.frame = CGRectMake(15, 15, 100, 14);
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = UIColorFromRGBValue(0x424242);
        [self addSubview:titleLabel];
        CGFloat btnWidth = (HCSCREEN_WIDTH*0.85-50)/3;
        for (int i = 0; i < StruCondArray.count-1; i++) {
            int row = i/3;
            int list = i%3;
            id cond = [StruCondArray objectAtIndex:i+1];
            HCVehicleStruBtn *btn = [[HCVehicleStruBtn alloc]initWithFrame:CGRectMake(15+list*(btnWidth+10), titleLabel.bottom+15+row*(75+10), btnWidth, 75)withCond:cond];
            [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.selectArray addObject:btn];
        }
    }
    return self;
}
-(NSString *)reuseIdentifier{
    return _reuseid;
}
-(void)selectBtnClick:(HCOtherSelectBtn*)btn{
    for (HCOtherSelectBtn *other in self.selectArray) {
        if (other!=btn) {
            [other setStateUnSelect];
        }
    }
    if (btn.selectState ==YES) {
        if (self.delegate) {
            [self.delegate cellBtnClick:[self.condArray objectAtIndex:0]];
        }
        [btn setStateUnSelect];
    }else{
        if (self.delegate) {
            [self.delegate cellBtnClick:btn.cond];
        }
        [btn setStateSelect];
    }
    
}
- (void)setSelectStruCond:(id)cond{
    for (HCVehicleStruBtn *other in self.selectArray) {
        [other setStateUnSelect];
        if ([cond isKindOfClass:[StructureCond class]]) {
            StructureCond *cond1 = (StructureCond*)cond;
            StructureCond *cond2 = (StructureCond*)other.cond;
            if (cond1.type==cond2.type) {
                [other setStateSelect];
            }
        }
    }
}
- (void)setSelectCond:(id)cond{
    
    for (HCOtherSelectBtn *other in self.selectArray) {
            [other setStateUnSelect];
        if ([cond isKindOfClass:[AgeCond class]]) {
            AgeCond *cond1 = (AgeCond*)cond;
            AgeCond *cond2 = (AgeCond*)other.cond;
            if (cond1.yearTo==cond2.yearTo) {
                [other setStateSelect];
            }
        }
        if ([cond isKindOfClass:[MilesCond class]]) {
            MilesCond *cond1 = (MilesCond*)cond;
            MilesCond *cond2 = (MilesCond*)other.cond;
            if (cond1.to==cond2.to) {
                [other setStateSelect];
            }
        }
        
    }
}
- (void)resetCondBtnColor{
    for (HCOtherSelectBtn *other in self.selectArray) {
        [other setStateUnSelect];
        
    }
    for (HCVehicleStruBtn *other in self.selectArray) {
        [other setStateUnSelect];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
