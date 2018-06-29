//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

typedef NS_ENUM(NSInteger, AppStatusVs) {
    AppStatusVs_Name = 1,   //app名称
    AppStatusVs_Version = 2,   //app版本
    AppStatusVs_Build = 3,  //app build版本
    AppStatusVs_IdentifierNumber = 4,    //手机序列号
    AppStatusVs_UserPhoneName = 5,   //手机别名： 用户定义的名称
    AppStatusVs_DeviceName = 6,  //设备名称
    AppStatusVs_PhoneVersion = 7,   //手机系统版本
    AppStatusVs_PhoneModel = 8,  //手机型号
    AppStatusVs_LocalPhoneModel = 9, //地方型号  （国际化区域名称）
    AppStatusVs_InfoDictionary = 10 ,/// 当前应用名称
    AppStatusVs_CurName = 11,// // 当前应用软件版本
    AppStatusVs_CurVersion = 12,// 当前应用版本号码   int类型
    AppStatusVs_CurVersionNum = 13,//// 当前应用版本号码   int类型
};

@interface ITTDataEnvironment : NSObject

//+ (ITTDataEnvironment *)sharedDataEnvironment;

extern NSString * AppStatusVss(AppStatusVs status);

+ (NSString *)AppStatusVss:(int)type;

@end
