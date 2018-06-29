//
//  BizMySaleVehicle.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "BizMySaleVehicle.h"
#import "BizCity.h"
#import "AppClient.h"
#import "Vehicle.h"
#import "MySaleVehicles.h"
@implementation BizMySaleVehicle

+ (void)getMySaleVehicleDataWithPhoneNum:(NSString*)phoneNum Finish:(void (^)(NSArray *, NSInteger))finish{
    NSDictionary *requestParam = @{
                                   @"city_id" : [NSNumber numberWithInteger:[BizCity getCurCity].cityId],
                                   @"phone":phoneNum,
                                   @"source":[NSNumber numberWithInteger:21]
                                   };
    [AppClient action:@"get_my_vehicle"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@",response.errMsg);
                       finish(nil,response.code);
                   } else {
                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSArray* vehicleDatas = [response.data objectForKey:@"vehicle_info"];
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   MySaleVehicles *vehicle = [[MySaleVehicles alloc] init];
                                   [vehicle initWithData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }
                           }
                           finish(vehicleList,response.code);
                       } @catch (NSException *exception) {
                            finish(vehicleList,response.code);
                       } @finally {
                           
                       }
                   }
               }
     ];
}

+ (void)getVehicleDetailWithVehicleid:(NSInteger)vehicleid finish:(void (^)(Vehicle*, NSInteger))finish{
    
    
    NSDictionary *requestParam;
    if ([[HCLogin standLog]isLog]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"];
        requestParam = @{
                         @"id" : [NSNumber numberWithInteger:vehicleid],
                         @"uid": uid,
                         @"source":@21,
                         @"city":[NSNumber numberWithInteger:[BizCity getCurCity].cityId]
                         };
    }else{
        requestParam = @{
                         @"id" : [NSNumber numberWithInteger:vehicleid],
                         @"source":@21,
                         @"city":[NSNumber numberWithInteger:[BizCity getCurCity].cityId]
                         };
    }
    [AppClient action:@"get_vehicle_source_by_id_v2"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil,response.code);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary *dic = response.data;
                               Vehicle *vehicelDetail = [[Vehicle alloc]init];
                               [vehicelDetail setdataWithdic:dic];
                               finish(vehicelDetail,response.code);
                           }
                       } @catch (NSException *exception) {
                             finish(nil,response.code);
                       } @finally {
                           
                       }
                     
                    
                   }
               }
     ];
}
+ (NSInteger)convertTimestamp:(NSInteger)year andMonth:(NSInteger)month
{
    NSString *dateStr = [[NSString alloc] initWithFormat:@"%4ld-%2ld-01 00:00:00", (long)year, (long)month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    return [date timeIntervalSince1970];
}
@end


