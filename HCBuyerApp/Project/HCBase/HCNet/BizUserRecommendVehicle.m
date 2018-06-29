//
//  BizUserRecommendVehicle.m
//  HCBuyerApp
//
//  Created by wj on 15/6/26.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizUserRecommendVehicle.h"
#import "AppClient.h"
#import "BizUser.h"
#import "Vehicle.h"
#import "BizCity.h"
#import "User.h"


//static NSInteger pageNum = 0;

static NSInteger lastFetchTime = 0;

@implementation BizUserRecommendVehicle

/*
+(void)getNewRecommendRecord:(BOOL)forceUpdate finish:(void (^)(NSArray *, NSInteger))finish;
{
    //获取当前时间戳
    NSDate *now = [NSDate date];
    NSInteger nowTS = [now timeIntervalSince1970];
    
    //如果上次更新时间在1小时以内，则不从服务端更新
    if (lastRefreshTime + 3600 > nowTS && !forceUpdate) {
        NSLog(@"no need to update recommend vehicle data");
        finish(nil, 0);
        return;
    }
    
    NSDictionary *requestParam = @{
                                   @"user_id" : [NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"city_id": [NSNumber numberWithInteger:[BizCity getCurCity].cityId],
                                   };
    [AppClient action:@"get_user_preferences"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       NSLog(@"update recommed vehicle data success");
                       NSArray* vehicleDatas = response.data;
                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                       for (NSDictionary* vehicleDic in vehicleDatas) {
                           Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                           [vehicleList addObject:vehicle];
                       }
                       finish(vehicleList, 0);
                       lastRefreshTime = [now timeIntervalSince1970];
                   }
               }
     ];
}
*/

//获取最新的推荐车源(我的界面)
+(void)getNewVehicleSourceRemote:(void (^)(NSArray *, NSInteger))finish
{
  
    NSDictionary *requestParam = @{
                                   @"user_id" :[NSNumber numberWithInteger:[BizUser getUserId]],
                                   };
    [AppClient action:@"my_recommend_list_v2"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       @try {
                           NSArray* vehicleDatas;
                           if ([response.data isKindOfClass:[NSDictionary class]]) {//判断返回的数据是否是正确的字典
                               if ([[response.data objectForKey:@"vehicles"] isKindOfClass:[NSArray class]]) {//判断字典有正确的数组
                                   vehicleDatas = [response.data objectForKey:@"vehicles"];
                               }else{
                                   return ;//判断里面没有数组的话直接返回.不走下面,不存在任何问题
                               }
                           }
                           NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                        //   vehicleDatas = [[NSNull alloc]init];
                           if (vehicleDatas.count!=0) { //判断这个数组是否是空的
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
                                   [vehicleList addObject:vehicle];
                               }
                             
                           }
                           finish(vehicleList, 0);
                       } @catch (NSException *exception) {
                           finish(nil, 0);
                       } @finally {
                           
                       }
                       
                   }
               }
     ];
}

////获取历史数据, 并和当前的list 合并
//+(void)appendHistoryVehicleSource:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish
//{
//    NSDictionary *requestParam = @{
//                                   @"user_id" :[NSNumber numberWithInteger:[BizUser getUserId]],
////                                   @"page_size": [NSNumber numberWithInteger:pageSize],
////                                   @"page" : [NSNumber numberWithInteger:pageNum]
//                                   };
//    NSString *actionName = @"my_recommend_list";
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response) {
//                   if (response.code != 0) {
//                       NSLog(@"Http response error: %@", response.errMsg);
//                       finish(nil, -1);
//                   } else {
//                       NSArray* vehicleDatas = response.data;
//                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
//                       for (NSDictionary* vehicleDic in vehicleDatas) {
//                           Vehicle *vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
//                           [vehicleList addObject:vehicle];
//                       }
//                       //merge
//                       NSMutableArray *result = [[NSMutableArray alloc] initWithArray:list];
//                       BOOL existNew = NO;
//                       for (Vehicle *vehicle in vehicleList) {
//                           BOOL exist = NO;
//                           for (Vehicle *srcVehicle in list) {
//                               if (vehicle.vehicleSourceId == srcVehicle.vehicleSourceId) {
//                                   exist = YES;
//                                   break;
//                               }
//                           }
//                           if (!exist) {
//                               [result addObject:vehicle];
//                               existNew = YES;
//                           }
//                       }
//                       if ([vehicleDatas count] == [LIST_PAGE_SIZE integerValue]) {
//                           pageNum += 1;
//                           finish(result, 0);
//                       } else if (!existNew) {
//                           finish(result, -2);
//                       } else {
//                           finish(result, 0);
//                       }
//                   }
//               }
//     ];
//}

+(void)checkNewUserRecommend:(void(^)(BOOL,NSInteger))finish
{
    
    [self updateLastFetchTime];
    
    NSDictionary *requestParam = @{
                                   @"user_id":[NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"last_activity_time":[NSNumber numberWithInteger:lastFetchTime],
                                   };
    [AppClient action:@"check_user_recommend"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(NO,0);
                   } else {
                       @try {
                           [[NSUserDefaults standardUserDefaults] setObject:[NSString getNowTimestamp] forKey:@"last_refresh"];
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary* newRecommendCntInfo = response.data;
                               if ([newRecommendCntInfo objectForKey:@"count"]) {
                                   NSInteger cnt = [[newRecommendCntInfo objectForKey:@"count"] integerValue];
                                   if (cnt > 0) {
                                       finish(YES,cnt);
                                   }
                               }
                               finish(NO,0);
                           }

                       } @catch (NSException *exception) {
                            finish(YES,0);
                       } @finally {
                           
                       }
                    }
               }
     ];
}


+(void)updateLastFetchTime
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"last_refresh"]&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"last_refresh"]integerValue]>0) {
         lastFetchTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"last_refresh"] integerValue];
    }else{
        
         lastFetchTime = 0;
    }
}

+(void)requestnumdata:(void(^)(NSDictionary *,NSInteger))finish{
    UID;
    NSString *time =[[NSUserDefaults standardUserDefaults]objectForKey:@"subs_refresh"] ;
    if (time == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey: @"subs_refresh"];
    }
    NSInteger timeNum =[time integerValue];
    NSDictionary *requestParam = @{
                                   @"uid":uid,
                                   @"refresh_time":[NSNumber numberWithInteger:timeNum],
                                   @"phone" :IPHONE,
                                   };
    [AppClient action:@"my_data"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil,-1);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary * numdata = response.data;
                               finish(numdata,0);
                           }
                       } @catch (NSException *exception) {
                                finish(nil,0);
                       } @finally {
                           
                       }
                    }
               }
     ];
}
@end
