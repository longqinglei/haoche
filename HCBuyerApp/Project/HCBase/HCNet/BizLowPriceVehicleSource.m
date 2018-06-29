//
//  BizLowPriceVehicleSource.m
//  HCBuyerApp
//
//  Created by wj on 15/6/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizLowPriceVehicleSource.h"
#import "AppClient.h"
#import "BizUser.h"
#import "Vehicle.h"

static NSInteger pageNum = 0;


//static NSInteger curCityId = 0;

@implementation BizLowPriceVehicleSource
//
//+(void)getNewVehicleSourceForHomePage:(BOOL)localEmpty cityId:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter;
//{
//    //获取当前时间戳
////    NSDate *now = [NSDate date];
////    NSInteger nowTS = [now timeIntervalSince1970];
////    
////    //如果上次更新时间在半小时以内，则不从服务端更新
////    if (lastRefreshTime + 1800 > nowTS && !localEmpty && curCityId == cityId) {
////        NSLog(@"no need to update lowprice vehicle data for homepage");
////        finish(nil, 0);
////        return;
////    }
//
//    curCityId = cityId;
//    NSDictionary *query = @{
//                            @"city":[NSNumber numberWithInteger:cityId],
//                            @"suitable":@1
//                            };
//    NSDictionary *requestParam = @{
//                                   @"order":@"time",
//                                   @"desc":@1,
//                                   @"page_size":LIST_PAGE_SIZE,
//                                   @"page_num":@0 ,
//                                   @"query" :query,
//                                   @"userid" : [NSNumber numberWithInteger:[BizUser getUserId]]
//                                   };
//    NSString *actionName = @"vehicle_list";
//    if (filter && [filter isValid]) {
//        NSMutableDictionary *filterRequestParam = [filter getFilterRequestParams];
//        [filterRequestParam addEntriesFromDictionary:requestParam];
//        requestParam = filterRequestParam;
//    }
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response) {
//                   if (response.code != 0) {
//                       NSLog(@"Http response error: %@", response.errMsg);
//                       finish(nil, VehicleSourceUpdateFailed);
//                   } else {
//                       NSArray* vehicleDatas;
//                       if ([response.data isKindOfClass:[NSDictionary class]]) {
//                           vehicleDatas = [response.data objectForKey:@"vehicles"];
//                       }
//                    //   NSInteger count = [[response.data objectForKey:@"count"]integerValue];
//                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
//                       for (NSDictionary* vehicleDic in vehicleDatas) {
//                           Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
//                           [vehicleList addObject:vehicle];
//                       }
//                       //
////                       lastRefreshTime = [now timeIntervalSince1970];
//                       finish(vehicleList, VehicleSourceUpdateSuccess);
//                   }
//               }
//     ];
//}
+(void)getNewVehicleSourceRemote:(NSMutableDictionary *)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish{
    pageNum = 1;
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
     [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:query forKey:@"query"];  
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    NSLog(@"requestparam%@",requestParam);
    [AppClient action:@"vehicle_list_v2"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                if (response.code != 0) {
                    finish(nil, VehicleSourceUpdateFailed,0);
                } else {
                    @try {
                        NSArray* vehicleDatas;NSInteger count = 0;
                        if ([response.data isKindOfClass:[NSDictionary class]]) {
                            vehicleDatas = [response.data objectForKey:@"vehicles"];
                            count = [[response.data objectForKey:@"count"]integerValue];
                        }
                        Vehicle *vehicle;
                        NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                        for (NSDictionary* vehicleDic in vehicleDatas) {
                            if([vehicleDic objectForKey:@"near_city"]){
                                vehicle = [[Vehicle alloc]initNearcity:vehicleDic];
                                [vehicleList addObject:vehicle];
                            }else if ([vehicleDic objectForKey:@"bang_count"]){
                                vehicle = [[Vehicle alloc]init];
                                vehicle.bangmaiCount = [[vehicleDic objectForKey:@"bang_count"]integerValue];
                                [vehicleList addObject:vehicle];
                            }else{
                                vehicle= [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                [vehicleList addObject:vehicle];
                            }
                        }
                        finish(vehicleList, VehicleSourceUpdateSuccess,count);
                    } @catch (NSException *exception) {
                        finish(nil, VehicleSourceUpdateSuccess,0);
                    } @finally {
                        
                    }
                }
            }
     ];
    pageNum = 2;
}
+(void)appendHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary *)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger, NSInteger))finish{
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    
    [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:query forKey:@"query"];
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [AppClient action:@"vehicle_list_v2"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, VehicleSourceUpdateFailed,0);
                   } else {
                       @try {
                           NSArray* vehicleDatas;
                           
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               vehicleDatas = [response.data objectForKey:@"vehicles"];
                               //  countNumber = [[response.data objectForKey:@"count"] integerValue];
                           }
                           Vehicle *vehicle;
                           NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                           for (NSDictionary* vehicleDic in vehicleDatas) {
                               if([vehicleDic objectForKey:@"near_city"]){
                                   vehicle = [[Vehicle alloc]initNearcity:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }else if ([vehicleDic objectForKey:@"bang_count"]){
                                   vehicle = [[Vehicle alloc]init];
                                   vehicle.bangmaiCount = [[vehicleDic objectForKey:@"bang_count"]integerValue];
                                   [vehicleList addObject:vehicle];
                               }else{
                                   vehicle= [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }
                               
                           }
                           NSMutableArray *result = [[NSMutableArray alloc] initWithArray:list];
                           BOOL existNew = NO;
                           for (Vehicle *vehicle in vehicleList) {
                               existNew = YES;
                               [result addObject:vehicle];
                               if (vehicleDatas.count==0) {
                                   existNew = NO;
                               }
                           }
                           if (vehicleDatas.count == 0) {
                               
                           }else{
                               pageNum += 1;
                           }
                           
                           if ([vehicleDatas count] >= [LIST_PAGE_SIZE integerValue]) {
                               // pageNum += 1;
                               finish(result, VehicleSourceUpdateSuccess,pageNum);
                           } else if (!existNew) {
                               finish(result, VehicleSourceUpdateHistoryNone,pageNum);
                           } else {
                               finish(result, VehicleSourceUpdateSuccess,pageNum);
                           }

                       } @catch (NSException *exception) {
                           finish(nil, VehicleSourceUpdateSuccess,0);
                       } @finally {
                           
                       }
                    }
               }
     ];

    
    
    
}


@end
