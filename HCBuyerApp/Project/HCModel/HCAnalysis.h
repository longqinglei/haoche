//
//  HCAnalysis.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/25.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCAnalysis : NSObject
//+ (void)HCclick:(NSString*)myEvent;
+ (void)HCclick:(NSString *)myEvent WithProperties:(NSDictionary *)properties;
+ (void)controllerBegin:(NSString *)begin;
+ (void)controllerEnd:(NSString *)end;
+ (void)HCUserClick:(NSString*)myEvent;
@end
