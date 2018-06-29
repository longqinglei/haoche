//
//  UIFont+FitSize.m
//  Ranch
//
//  Created by 龙青磊 on 2018/3/3.
//  Copyright © 2018年 xfkeji_Ranch. All rights reserved.
//

#import "UIFont+FitSize.h"
#import "Config.h"

@implementation UIFont (FitSize)

+ (UIFont *)fontSize:(NSInteger)size{
    if (isIPhone5) {
        return [UIFont systemFontOfSize:size - 2];
    }else if (isIPhone6){
        return [UIFont systemFontOfSize:size];
    }else{
        return [UIFont systemFontOfSize:size + 2];
    }
}

@end
