//
//  HCUI_L.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/22.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCUI_L.h"

@implementation HCUI_L

+ (nullable UILabel *)creatLabeWithText:(nullable NSString *)text textColor:(nullable UIColor *)textcolor backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)font numberOfLines:(NSInteger)numberOfLines{
    UILabel * label =[[UILabel alloc]init];
    label.text = text;
    if (textcolor) {
        label.textColor =textcolor;
    }
    if (backColor) {
        label.backgroundColor = backColor;
    }
    label.font=[UIFont fontSize:font];
    label.textAlignment =textAlignment;
    label.numberOfLines =numberOfLines;
    return label;
}

@end
