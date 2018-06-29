//
//  UIColor+HexColor.m
//  Tools
//
//  Created by 龙青磊 on 2018/6/15.
//  Copyright © 2018年 龙青磊. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (instancetype)hex:(NSString *)hex {
    NSString *str = [hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].uppercaseString;
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:0];
    }
    if (str.length != 6) {
        return [UIColor whiteColor];
    }
    unsigned int rgbValue = 0;
    [[NSScanner scannerWithString:str] scanHexInt:&rgbValue];
    CGFloat red = (CGFloat)((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = (CGFloat)((rgbValue & 0x00FF00) >> 8) / 255.0;
    CGFloat blue = (CGFloat)(rgbValue & 0x0000FF) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
