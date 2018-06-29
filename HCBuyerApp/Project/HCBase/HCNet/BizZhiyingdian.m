//
//  BizZhiyingdian.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/21.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "BizZhiyingdian.h"
#import "AppClient.h"
#import "Vehicle.h"
#import "BizUser.h"
#import "User.h"
#import "MyVehicle.h"
#import "NSString+ITTAdditions.h"
#import "BizCity.h"
#import "HCUUID.h"
@implementation BizZhiyingdian


+ (void)updateZhiyingdianVehicleListQuery:(NSMutableDictionary *)query Page:(NSInteger)page_num sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish{
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:query forKey:@"query"];
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:page_num] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [AppClient action:@"list_store_v3"
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

}

@end
