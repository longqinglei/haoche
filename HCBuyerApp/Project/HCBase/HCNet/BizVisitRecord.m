//
//  BizVisitRecord.m
//  HCBuyerApp
//
//  Created by wj on 15/6/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizVisitRecord.h"
#import "AppClient.h"

#import "BizUser.h"
#import "Vehicle.h"

@implementation BizVisitRecord

static NSInteger lastUpdateTime = 0;
static NSInteger pageSize = 10;

//
//+(void)getNewVisitRecord:(NSInteger)page Record:(void (^)(NSArray *, NSInteger))finish
//{
//
//    NSDate *now = [NSDate date];
//    lastUpdateTime = [now timeIntervalSince1970];
//    NSDictionary *requestParam = @{
//                                   @"user_id" : [NSNumber numberWithInteger:[BizUser getUserId]],
//                                   @"page_size": [NSNumber numberWithInteger:pageSize],
//                                   @"page":[NSNumber numberWithInteger:page],
//                                   @"last_update_time" : [NSNumber numberWithInteger:lastUpdateTime]
//                                   };
//    
//    [AppClient action:@"get_browse_history_v2"
//           withParams:requestParam
//               finish:^(HttpResponse* response) {
//                   if (response.code != 0) {
//                       NSLog(@"Http response error: %@", response.errMsg);
//                       finish(nil, -1);
//                   } else {
//                       NSArray* vehicleDatas = response.data;
//                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
//                       @try {
//                           for (NSDictionary* vehicleDic in vehicleDatas) {
//                               Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
//                               [vehicleList addObject:vehicle];
//                           }
//                           //获取最后车源的写入时间
//                           if ([vehicleList count] > 0) {
//                               Vehicle *vehicle = [vehicleList HCObjectAtIndex:[vehicleList count] - 1];
//                               lastUpdateTime = vehicle.createTime;
//                           }
//                            finish(vehicleList, 0);
//                       } @catch (NSException *exception) {
//                             finish(vehicleList, 0);
//                       } @finally {
//                           
//                       }
//                       
//                   }
//               }
//     ];
//}



+(void)getNewVisitRecord:(void (^)(NSArray *, NSInteger))finish
{
    NSDate *now = [NSDate date];
    lastUpdateTime = [now timeIntervalSince1970];
    
    NSDictionary *requestParam = @{
                                   @"user_id" : [NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"page_size": [NSNumber numberWithInteger:pageSize],
                                   @"last_update_time" : [NSNumber numberWithInteger:lastUpdateTime]
                                   };
    
    [AppClient action:@"get_browse_history_v2"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary* vehicleDatas = response.data;
                               NSArray *vehicleData = [vehicleDatas objectForKey:@"vehicles"];
                               NSMutableArray *vehicleList = [[NSMutableArray alloc]init];
                               for (NSDictionary* vehicleDic in vehicleData) {
                                   Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }
                              // NSNull *null = [[NSNull alloc]init];
                             //  Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:null];
                              // [vehicleList insertObject:vehicle atIndex:0];
                               //获取最后车源的写入时间
                               if ([vehicleList count] > 0) {
                                   Vehicle *vehicle = [vehicleList HCObjectAtIndex:[vehicleList count] - 1];
                                   lastUpdateTime = vehicle.createTime;
                                   
                               }
                               finish(vehicleList, 0);
                           }

                       } @catch (NSException *exception) {
                           finish(nil, 0);

                       } @finally {
                           
                       }
                    }
               }
     ];
}

+(void)getOrderRecord:(void (^)(int , NSInteger))finish{
    
    NSDictionary *requestParam = @{@"udid" : [NSNumber numberWithInteger:[BizUser getUserId]],};
    [AppClient action:@"get_browse_history_count"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(0, -1);
                   } else {
                       int number ;
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               number = [[response.data objectForKey:@"count"]intValue];
                           }else{
                               number = 0;
                           }
                            finish(number, 0);
                       } @catch (NSException *exception) {
                            finish(number, 0);
                       } @finally {
                           
                       }
                   }
               }
     ];
}


+(void)appendHistoryRecordForlist:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish
{
    if (lastUpdateTime == 0) {
        NSDate *now = [NSDate date];
        lastUpdateTime = [now timeIntervalSince1970]; 
    }
    NSDictionary *requestParam = @{
                                   @"user_id" : [NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"page_size": [NSNumber numberWithInteger:pageSize],
                                   @"last_update_time" : [NSNumber numberWithInteger:lastUpdateTime]
                                   };
    [AppClient action:@"get_browse_history_v2"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       @try {
                           NSDictionary* vehicleDatas = response.data;
                           NSArray *vehicleData = [vehicleDatas objectForKey:@"vehicles"];
                           NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                           for (NSDictionary* vehicleDic in vehicleData) {
                               Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                               [vehicleList addObject:vehicle];
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
                           //获取最后车源的写入时间
                           if ([vehicleList count] > 0) {
                               Vehicle *vehicle = [vehicleList HCObjectAtIndex:[vehicleList count] - 1];
                               lastUpdateTime = vehicle.createTime;
                           }
                           if ([vehicleData count] == [LIST_PAGE_SIZE integerValue]) {
                               finish(result, 0);
                           } else if (!existNew) {
                               finish(result, -2);
                           } else {
                               finish(result, 0);
                           }

                       } @catch (NSException *exception) {
                            finish(nil, 0);
                       } @finally {
                           
                       }
                    }
               }
     ];
}

@end
