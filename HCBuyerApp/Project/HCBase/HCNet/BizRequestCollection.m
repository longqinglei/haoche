//
//  BizRequestCollection.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/28.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "BizRequestCollection.h"
#import "VehicleSourceUpdateStatus.h"
@implementation BizRequestCollection

+(void)requestCollection:(NSInteger)vehicle_source_id byfinish:(void (^)(NSString *, NSInteger))finish reture:(BOOL)isReture{
    
    UID;
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    ;
    [requestParam setObject:[NSString stringWithFormat:@"%ld",(long)vehicle_source_id] forKeyedSubscript:@"vehicle_source_id"];
    [requestParam setObject:uid forKey:@"uid"];
    NSString *actionName;
    if (isReture) {
        actionName = @"collection_add";
    }else{
        actionName = @"collection_cancel";
    }
    [AppClient action:actionName
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finish(response.errMsg,VehicleSourceUpdateFailed);
                   } else {
                       finish(response.errMsg, VehicleSourceUpdateSuccess);
                   }
               }
     ];
}

+(void)requestObtainCollection:(NSInteger)vehicle_source_id byfinish:(void (^)(NSInteger, int))finish{
    UID;
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    [requestParam setObject:[NSString stringWithFormat:@"%ld",(long)vehicle_source_id] forKeyedSubscript:@"vehicle_source_id"];
    [requestParam setObject:[NSString stringWithFormat:@"%@",uid] forKey:@"uid"];
    NSString *actionName = @"get_detail_data";
    [AppClient action:actionName
           withParams:requestParam
               finish:^(HttpResponse* response){
                   NSDictionary *dict;
                   NSString *strKey;
                   if ([response.data isKindOfClass:[NSDictionary class]]) {
                       dict = response.data;
                       strKey = [dict objectForKey:@"collected"];
                   }
                   if (response.code != 0) {
                       finish(VehicleSourceUpdateFailed,[strKey intValue]);
                   } else {
                       finish(VehicleSourceUpdateSuccess,[strKey intValue]);
                   }
               }
     ];
}

+(void)requestCollection_list:(NSInteger )page back:(void (^)(NSInteger, NSArray*,NSString *))finish{
    
    UID;

    NSDictionary *requestParam = @{
                     @"uid":[NSString stringWithFormat:@"%@",uid],
                     @"page_size":LIST_PAGE_SIZE,
                     @"page":[NSNumber numberWithInteger:page],
                     @"order":[NSString stringWithFormat:@"create_time desc"]//时间
                     };
    NSString *actionName = @"list_collection_v3";
    
    [AppClient action:actionName
           withParams:requestParam
               finish:^(HttpResponse* response){
                if (response.code != 0) {
                       finish(VehicleSourceUpdateFailed,nil,0);
                   }else{
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSString * vehicle_count = [response.data objectForKey:@"count"];
                               NSArray* vehicleDatas = [response.data objectForKey:@"vehicles"];
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   Vehicle*  vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }
                               finish(VehicleSourceUpdateSuccess, vehicleList,vehicle_count);
                           }

                       } @catch (NSException *exception) {
                           finish(VehicleSourceUpdateSuccess, nil,0);
                       } @finally {
                           
                       }
                   }
               }
     ];
}

@end
