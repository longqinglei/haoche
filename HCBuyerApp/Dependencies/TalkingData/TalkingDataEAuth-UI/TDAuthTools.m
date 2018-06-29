//
//  TDAuthTools.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import "TDAuthTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation TDAuthTools

+ (BOOL)isPureNumber:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (UIImage *)imageWithColorToButton:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
