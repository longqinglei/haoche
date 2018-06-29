//
//  BizNewViehicle.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/31.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "BizNewViehicle.h"
#import "AppClient.h"
#import "AppClient.h"
#import "Vehicle.h"
#import "BizUser.h"
#import "User.h"
#import "MyVehicle.h"
#import "NSString+ITTAdditions.h"
#import "BizCity.h"
#import "HCUUID.h"
static NSInteger pageNum = 0;

@implementation BizNewViehicle
+(void)getTodayNewVehicleSourceRemote:(NSMutableDictionary *)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish{
    pageNum = 1;
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:query forKey:@"query"];
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [AppClient action:@"list_today_v3"
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
                               vehicle= [[Vehicle alloc] initWithVehicleData:vehicleDic];
                               [vehicleList addObject:vehicle];
                           }
                           finish(vehicleList, VehicleSourceUpdateSuccess,count);
                       } @catch (NSException *exception) {
                           finish(nil, VehicleSourceUpdateFailed,0);
                       } @finally {
                           
                       }
                   }
               }
     ];
    pageNum = 2;
}
+(void)appendTodayHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary *)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger, NSInteger))finish{
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    
    [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:query forKey:@"query"];
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [AppClient action:@"list_today_v3"
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
                           }
                           Vehicle *vehicle;
                           NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                           for (NSDictionary* vehicleDic in vehicleDatas) {
                               vehicle= [[Vehicle alloc] initWithVehicleData:vehicleDic];
                               [vehicleList addObject:vehicle];
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
                             finish(nil, VehicleSourceUpdateFailed,0);
                       } @finally {
                           
                       }
                   }
               }
     ];
    
    
    
    
}

@end
