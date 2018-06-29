//
//  Config.h
//  DSSManito
//
//  Created by 龙青磊 on 2018/5/16.
//  Copyright © 2018年 longiqnglei.xfkeji. All rights reserved.
//

#ifndef Config_h
#define Config_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Tools.h"
#import "Remind_L.h"
#import "UIColor+HexColor.h"
#import "UIFont+FitSize.h"
#import "Masonry.h"
#import "UIResponder+tools.h"
#import "HCUI_L.h"


//设备
#define isIPhoneX [UIScreen mainScreen].bounds.size.height==812
#define isIPhone5 [UIScreen mainScreen].bounds.size.width==320
#define isIPhone6 [UIScreen mainScreen].bounds.size.width==375
#define isPlus    [UIScreen mainScreen].bounds.size.width==414

//设备的宽和高
#define  kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define  kScreenWidth    [UIScreen mainScreen].bounds.size.width

//nav高
#define kNavHegith      (kScreenHeight == 812.0 ? 88 : 64)
//tabar高
#define kTabbarHeight   (kScreenHeight == 812.0 ? (34 + 49) : 49)

//tabar高
#define kTabbarBottom   (kScreenHeight == 812.0 ? 34 : 0)

//颜色值
#define RGB(r,g,b)      RGB_A(r,g,b,1)
#define RGB_A(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//弱引用
#define KWeakSelf(type) __weak typeof(type) weak##type = type;
#define Width(value) kScreenWidth / 375 * value

#define NSLog_L(format, ...)   {\
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "log location--->");                                      \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
fprintf(stderr, "\n");                                               \
}

typedef void(^RequestFinish)(BOOL result, id data);

#endif /* Config_h */
