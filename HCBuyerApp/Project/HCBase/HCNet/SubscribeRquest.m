//
//  SubscribeRquest.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/20.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SubscribeRquest.h"
#import "VehicleSourceUpdateStatus.h"
#import "AppClient.h"
#import "User.h"
#import "SubscriptionModelCar.h"
#import "DataFilter.h"
#import "MyVehicle.h"
#import "BizUser.h"

static NSInteger pageNum = 0;
//static NSInteger pageSize = 10;

static NSInteger lastFetchTime = 0;
static NSInteger num;
@implementation SubscribeRquest


+(void)getSubscriber:(NSInteger)type tpye:(NSDictionary*)dict sub:(NSInteger)subId city:(NSInteger)cityId SourceInformation:(void (^)(NSArray *, NSInteger,NSInteger))finish
{
    UID;
    pageNum = 0;
    NSString *strName = @"list_subscribe_v3";  //2.6更改接口名称   添加了UDID
    NSString *strStact = @"get_user_all_subscribe";
    NSDictionary *requestParam;
    
    NSString *mOrder_by = [dict objectForKey:@"order_by"];
    NSString *mDesc = [dict objectForKey:@"desc"];
    
    if ([[HCLogin standLog] isLog]) {
        if (type == 1) { //我的订阅
            requestParam = @{
                             @"uid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"],
                             @"page_size":LIST_PAGE_SIZE,
                             @"page":[NSNumber numberWithInteger:pageNum],
                             @"phone" : IPHONE,
                             @"sub_id" :[NSNumber numberWithInteger:subId],
                             @"order_by":mOrder_by,
                             @"desc":mDesc,
                             @"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                             };
            [AppClient action:strName
                   withParams:requestParam
                       finish:^(HttpResponse* response){
                          // NSLog(@"订阅车源%@",response.data);
                           if (response.code != 0){
                               NSLog(@"Http response error: %@", response.errMsg);
                               finish(nil, -1,0);
                           } else {
                               @try {
                                     NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                                   if ([response.data isKindOfClass:[NSDictionary class]]) {
                                       // [MyOrderDetail delettable];
                                       Vehicle *vehicle;
                                       NSDictionary *vehicleArray = response.data;
                                       NSArray* vehicleDatas;
                                       if (vehicleArray.count != 0) {
                                           vehicleDatas = [response.data objectForKey:@"vehicles"];
                                           num = [[response.data objectForKey:@"count"] integerValue];
                                       }
                                     
                                       for (NSDictionary* vehicleDic in vehicleDatas) {
                                           vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                           [vehicleList addObject:vehicle];
                                           //[MyOrderDetail getOrder:vehicleDic];
                                       }
                                   }
                                    finish(vehicleList, response.code,num);
                               } @catch (NSException *exception) {
                                    finish(nil, VehicleSourceUpdateSuccess,0);
                               } @finally {
                                   
                               }
                            }
                       }
             ];
        }else{
            requestParam = @{    //我的全部订阅5条
                             @"uid" :uid,
                             @"phone" : IPHONE,
                             };
            [AppClient action:strStact
                   withParams:requestParam
                       finish:^(HttpResponse* response){
                           if (response.code != 0){
                               NSLog(@"Http response error: %@", response.errMsg);
                               finish(nil, -1,0);
                           } else {
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               if (type == 5) {
                                   vehicleList = response.data;
                               }else {
                                   @try {
                                       if ([response.data isKindOfClass:[NSArray class]]) {
                                           [MyVehicle delettable];
                                           SubscriptionModelCar *vehicle;
                                           NSArray* vehicleDatas = response.data;
                                           for (NSDictionary* vehicleDic in vehicleDatas) {
                                               vehicle = [[SubscriptionModelCar alloc] initWithVehicleDataNew:vehicleDic];
                                               [vehicleList addObject:vehicle];
                                               [MyVehicle getDicDataFrom:vehicleDic];
                                           }
                                       }
                                       finish(vehicleList, VehicleSourceUpdateSuccess,num);
                                   } @catch (NSException *exception) {
                                       finish(nil, VehicleSourceUpdateSuccess,0);
                                   } @finally {
                                       
                                   }
                                   
                                }
                              
                           }
                       }
             ];
        }
    }else{
        return;
    }
   pageNum = 1;
}

//下拉请求
+(void)append:(NSArray *)list tpye:(NSDictionary*)dict sub:(NSInteger)subId city:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger, NSInteger))finish
{ //我的订阅
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"];
    NSString *mOrder_by = [dict objectForKey:@"order_by"];
    NSString *mDesc = [dict objectForKey:@"desc"];
    NSDictionary *requestParam = @{
                                   @"uid" : uid,
                                   @"page_size":LIST_PAGE_SIZE,
                                   @"page":[NSNumber numberWithInteger:pageNum],
                                   @"phone" :IPHONE,
                                   @"sub_id" :[NSNumber numberWithInteger:subId],
                                   @"order_by":mOrder_by,
                                   @"desc":mDesc
                                   };
    
    [AppClient action:@"list_subscribe_v3"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                        finish(nil, VehicleSourceUpdateFailed,0);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary* vehicleArray = response.data;
                               NSArray* vehicleDatas;
                               if (vehicleArray.count != 0) {
                                   vehicleDatas = [vehicleArray objectForKey:@"vehicles"];
                               }
                               
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                                   // [MyOrderDetail getOrder:vehicleDic];
                               }
                               //merge
                               NSMutableArray *result = [[NSMutableArray alloc] initWithArray:list];
                               BOOL existNew = NO;
                               for (Vehicle *vehicle in vehicleList) {
                                   BOOL exist = NO;
                                   for (Vehicle *srcVehicle in list) {
                                       if (vehicle.vehicle_id == srcVehicle.vehicle_id) {
                                           exist = YES;
                                           break;
                                       }
                                   }
                                   if (!exist) {
                                       [result addObject:vehicle];
                                       existNew = YES;
                                   }
                               }
                               if ([vehicleDatas count] == [LIST_PAGE_SIZE integerValue]) {
                                   pageNum += 1;
                                   finish(result, VehicleSourceUpdateSuccess,pageNum);
                               } else if (!existNew) {
                                   finish(result, VehicleSourceUpdateHistoryNone,pageNum);
                               } else {
                                   finish(result, VehicleSourceUpdateSuccess,pageNum);
                               }
                               
                           }

                       } @catch (NSException *exception) {
                            finish(nil, VehicleSourceUpdateSuccess,0);
                       } @finally {
                           
                       }
                    }
            }
     ];

}

+(void)deleteSub:(NSInteger)integer scription:(void(^)(NSMutableArray *,NSInteger))finsh{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"];
    NSDictionary *requestParam;
    requestParam = @{
                     @"uid" : uid,
                     @"phone" : IPHONE,
                     @"sub_id" :[NSNumber numberWithInteger:integer]
                     };
    [AppClient action:@"unsubscribe_vehicles"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0){
                       NSLog(@"Http response error: %@", response.errMsg);
                        finsh(nil, -1);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               finsh(nil, VehicleSourceUpdateSuccess);
                           }
                       } @catch (NSException *exception) {
                            finsh(nil, VehicleSourceUpdateSuccess);
                       } @finally {
                       }
                   }
               }
     ];
}

+(void)getTimeCar:(NSInteger)refresh_time city:(NSInteger)cityId subid:(NSInteger)subid SourceInformation:(void (^)(int, NSInteger))finish{
    
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"];
    NSString *strName = @"get_user_subscribe_vehicle_count";
    NSDictionary *requestParam;
    requestParam = @{
                     @"sub_id":[NSNumber numberWithInteger:subid],
                     @"uid" : uid,
                     @"refresh_time" : [NSNumber numberWithInteger:refresh_time],
                     @"phone" : IPHONE,
                     @"city_id": [NSNumber numberWithInteger:cityId]
                     };
    
    [AppClient action:strName
           withParams:requestParam
               finish:^(HttpResponse* response){
                   int tagNumber;
                   if (response.code != 0){
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(0, response.code);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               tagNumber = [[response.data objectForKey:@"num"] intValue];
                               finish(tagNumber, VehicleSourceUpdateSuccess);
                           }
                       } @catch (NSException *exception) {
                           finish(0, response.code);
                       } @finally {
                           
                       }
                   }
               }
     ];
}


+(void)updateLastFetchTime
{
    NSDate *now = [NSDate date];
    NSInteger nowTS = [now timeIntervalSince1970];
    lastFetchTime = nowTS;
}



@end
