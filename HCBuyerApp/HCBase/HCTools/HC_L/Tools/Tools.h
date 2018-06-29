//
//  Tools.h
//  Tools
//
//  Created by 龙青磊 on 2018/6/14.
//  Copyright © 2018年 龙青磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

/**
 根据storyboard和storyboardid 返回控制器
 
 @param storyboard storyboard名称
 @param viewcontroller controller所在storyboard的storyboardid
 @return 返回的控制器
 */
+ (UIViewController *)storyboard:(NSString *)storyboard viewcontroller:(NSString *)viewcontroller;


/**
 把data数据转换成对象
 
 @param object data数据
 @return 返回数据
 */
+ (id)dataToJson:(NSData *)object;

/**
 把对象转换成json字符串
 
 @param object 要转换的对象
 @return 转换完成的字符串
 */
+ (NSString *)dataToJsondString:(id)object;

/**
 获取当前显示的控制器
 
 @return 返回当前显示的控制器
 */
+ (UIViewController *)getCurrentVC;

/**
 返回一张指定颜色的图片

 @param color 指定的颜色
 @return 返回的图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
  根据时间戳获取日期字符串

 @param interval 时间戳
 @param format 日期格式(默认 yyyy-MM-dd HH:mm:ss)
 @return 日期字符串
 */
+ (NSString *)getDateStrWithNSTimeInterval:(NSInteger)interval format:(NSString *)format;

@end
