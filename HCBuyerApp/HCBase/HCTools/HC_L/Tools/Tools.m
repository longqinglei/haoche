//
//  Tools.m
//  Tools
//
//  Created by 龙青磊 on 2018/6/14.
//  Copyright © 2018年 龙青磊. All rights reserved.
//

#import "Tools.h"

@implementation Tools

// 返回SB中的控制器
+ (UIViewController *)storyboard:(NSString *)storyboard viewcontroller:(NSString *)viewcontroller{
    NSAssert(storyboard && viewcontroller, @"(EZTool) +storyboard:viewcontroller param is error");
    UIViewController *page = nil;
    UIStoryboard *story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    if (story) {
        page = [story instantiateViewControllerWithIdentifier:viewcontroller];
    }
    return page;
}

// 把JSON转为字典
+ (id)dataToJson:(NSData *)object{
    id result;
    NSError *error = nil;
    if (object) {
        result = [NSJSONSerialization JSONObjectWithData:object
                                                 options:NSJSONReadingMutableContainers
                                                   error:&error];
    }
    return error ? error : result;
}

// 把对象转为json字符串
+ (NSString *)dataToJsondString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//获取当前屏幕显示的控制器
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

// 返回一张指定颜色的图片
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 根据时间戳获取日期字符串
+ (NSString *)getDateStrWithNSTimeInterval:(NSInteger)interval format:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (format) {
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *time = [formatter stringFromDate:date];
    return time;
}

@end
