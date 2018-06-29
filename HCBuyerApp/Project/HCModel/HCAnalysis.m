//
//  HCAnalysis.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/25.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCAnalysis.h"
#import "TalkingData.h"
#import "SensorsAnalyticsSDK.h"
@implementation HCAnalysis
+ (void)HCclick:(NSString *)myEvent{
   // [[SensorsAnalyticsSDK sharedInstance]track:myEvent];
}
+ (void)HCclick:(NSString *)myEvent WithProperties:(NSDictionary *)properties{
//    [[SensorsAnalyticsSDK sharedInstance]track:myEvent withProperties:properties];
    [TalkingData trackEvent:myEvent label:@"" parameters:properties];
    
}

+(void)controllerBegin:(NSString *)begin{
    [TalkingData trackPageBegin:begin];
}
+ (void)controllerEnd:(NSString *)end{
    [TalkingData trackPageEnd:end];
}

+ (void)HCUserClick:(NSString*)myEvent{
    [TalkingData trackEvent:myEvent];
    NSString *userAction = [NSString stringWithFormat:@"&userAction=%@",myEvent];
    [AppClient tongji:userAction];
}

@end
