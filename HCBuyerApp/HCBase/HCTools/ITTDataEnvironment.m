//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//

#import "ITTDataEnvironment.h"
#import "SDImageCache.h"
#import "ITTObjectSingleton.h"


@implementation ITTDataEnvironment

//ITTOBJECT_SINGLETON_BOILERPLATE(ITTDataEnvironment, sharedDataEnvironment);

//扩展名称的方法
extern NSString * AppStatusVss(AppStatusVs status)
{
   return [ITTDataEnvironment AppStatusVss:status];
}

//直接返回nsstring
+ (NSString *)AppStatusVss:(int)type
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    switch (type) {
        case AppStatusVs_Name:
            return [infoDictionary objectForKey:@"CFBundleDisplayName"];
        case AppStatusVs_Version:
            return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        case AppStatusVs_Build:
            return [infoDictionary objectForKey:@"CFBundleVersion"];
        case AppStatusVs_IdentifierNumber:
            return @"手机序列号";
        case AppStatusVs_UserPhoneName:
            return [[UIDevice currentDevice] name];
        case AppStatusVs_DeviceName:
            return [[UIDevice currentDevice] systemName];
        case AppStatusVs_PhoneVersion:
            return [[UIDevice currentDevice] systemVersion];
        case AppStatusVs_PhoneModel:
            return  [[UIDevice currentDevice] model];
        case AppStatusVs_LocalPhoneModel:
            return [[UIDevice currentDevice] localizedModel];
        case AppStatusVs_CurName:
            return [infoDictionary objectForKey:@"CFBundleDisplayName"];
        case AppStatusVs_CurVersion:
            return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        case AppStatusVs_CurVersionNum:
            return [infoDictionary objectForKey:@"CFBundleVersion"];
        default:
            return @"";
    }
    return @"";
}

-(NSNumber *)isJailBreak
{
    static NSInteger isJailBreak = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    });
    return @(isJailBreak);
}

- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        //进入后台时保存数据
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSave)name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
#endif
#endif
}

//收到内存警告的时候会调用
- (void)clearCacheData
{
    //clear cache data if needed
  //  [DATA_CACHE_MANAGER clearMemoryCache];
    [[SDImageCache sharedImageCache]clearMemory];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end