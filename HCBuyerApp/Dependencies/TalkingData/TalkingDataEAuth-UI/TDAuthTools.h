//
//  TDAuthTools.h
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                 alpha:1.0]

@interface TDAuthTools : NSObject

+ (BOOL)isPureNumber:(NSString*)string;


+ (UIImage *)imageWithColorToButton:(UIColor *)color;

@end
