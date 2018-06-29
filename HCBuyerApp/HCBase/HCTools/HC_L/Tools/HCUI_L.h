//
//  HCUI_L.h
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/22.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCUI_L : NSObject

+(nullable UILabel *)creatLabeWithText:(nullable NSString *)text textColor:(nullable UIColor *)textcolor backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)font numberOfLines:(NSInteger)numberOfLines;
@end
