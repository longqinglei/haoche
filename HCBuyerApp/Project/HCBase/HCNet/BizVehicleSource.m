
//
//  BizVehicleSource.m
//  HCBuyerApp
//
//  Created by wj on 15/3/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizVehicleSource.h"
#import "VehicleSource.h"
#import "AppClient.h"
#import "Vehicle.h"
#import "BizUser.h"
#import "User.h"
#import "MyVehicle.h"
#import "NSString+ITTAdditions.h"
#import "BizCity.h"
#import "HCUUID.h"
@implementation BizVehicleSource

static NSInteger pageNum = 0;


//+(NSArray *)getNewVeicleSourceFromLocal:(NSInteger)cityId
//{
//    NSArray *vehicleList = [VehicleSource getVehicleSourceList];
//    if ([vehicleList count] > 0) {
//        pageNum = 1;
//    }
//    
//    return vehicleList;
//}


+ (NSMutableDictionary*)setUserStact:(NSString*)userStact andset:(NSMutableDictionary *)dic andset:(NSString *)strKey andset:(NSString *)strValue
{
    NSMutableDictionary *dicResult;
    dicResult = dic;
    if ([dic objectForKey:strKey]) {
        userStact = [dic objectForKey:strKey];
        [dic removeObjectForKey:strKey];
        [dicResult setValue:userStact forKey:strValue];
    }
    return dicResult;
}

+ (NSMutableDictionary *)setUserDic:(NSString *)Key andset:(NSMutableDictionary *)dic staNumber:(NSInteger)teger{
    NSMutableDictionary *dicResult;
    dicResult = dic;
    if ([[dic objectForKey:Key] integerValue] == teger) {
        [dic removeObjectForKey:Key];
        [dic setObject:@"0" forKey:Key];
    }
    return dicResult;
}

+ (NSMutableDictionary*)dictResultesult:(NSMutableDictionary *)dict
{
   
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userDefaultsUid"] forKey:@"uid"];
    [dict setObject:IPHONE forKey:@"phone"];
    NSMutableDictionary *dictTe;
    dictTe = dict;
    [BizVehicleSource setUserStact:@"es_standard" andset:dictTe andset:@"femission_standard" andset:@"es_standard"];
    [BizVehicleSource setUserStact:@"price_high" andset:dictTe andset:@"high_price" andset:@"price_high"];
    [BizVehicleSource setUserStact:@"price_low" andset:dictTe andset:@"low_price" andset:@"price_low"];
    [BizVehicleSource setUserStact:@"miles_low" andset:dictTe andset:@"from_miles" andset:@"miles_low"];
    [BizVehicleSource setUserStact:@"miles_high" andset:dictTe andset:@"to_miles" andset:@"miles_high"];
    [BizVehicleSource setUserStact:@"year_low" andset:dictTe andset:@"from_year" andset:@"year_low"];
    [BizVehicleSource setUserStact:@"year_high" andset:dictTe andset:@"to_year" andset:@"year_high"];
    
    [BizVehicleSource setUserStact:@"emission_low" andset:dictTe andset:@"from_emission" andset:@"emission_low"];
    [BizVehicleSource setUserStact:@"emission_high" andset:dictTe andset:@"to_emission" andset:@"emission_high"];
    [BizVehicleSource setUserStact:@"structure" andset:dictTe andset:@"vehicle_structure" andset:@"structure"];
    [BizVehicleSource setUserStact:@"geerbox" andset:dictTe andset:@"gearbox" andset:@"geerbox"];
    [BizVehicleSource setUserStact:@"class_id" andset:dictTe andset:@"series_id" andset:@"class_id"];
    

    [BizVehicleSource setUserDic:@"price_high" andset:dictTe staNumber:1000];
    [BizVehicleSource setUserDic:@"miles_high" andset:dictTe staNumber:100];
    [BizVehicleSource setUserDic:@"year_high" andset:dictTe staNumber:100];
    [BizVehicleSource setUserDic:@"emission_high" andset:dictTe staNumber:100];
    return dictTe;
}

+(void)getNeSubscribe:(NSInteger)cityId Parame:(NSMutableDictionary *)dict show:(void (^)(NSString *))strMessg byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter
{
    NSMutableDictionary *dictArray;
    dictArray = [self dictResultesult:dict];
    NSString *actionName = @"subscribe_vehicles";
    [AppClient action:actionName
           withParams:dictArray
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                    //[MyVehicle getMyVehicleList];
                       strMessg(response.errMsg);
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, VehicleSourceUpdateFailed);
                   } else {
                       [[NSNotificationCenter defaultCenter]postNotificationName:@"subSucess" object:nil];
                       finish(nil, VehicleSourceUpdateSuccess);
                   }
               }
     ];
}

+(void)getVehicelSource:(NSMutableDictionary*)dic sortDic:(NSMutableDictionary*)sort  byfinish:(void (^)(NSArray *,NSArray *, NSInteger,NSInteger,NSInteger))finish{
    pageNum = 1;
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    [requestParam addEntriesFromDictionary:sort];
    if (dic == nil) {
    }else{
      [requestParam setObject:dic forKey:@"query"];
    }
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [requestParam setObject:[HCUUID getHCUUID] forKey:@"uuid"];
    [requestParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selflat"] forKey:@"lat"];
    [requestParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selflng"] forKey:@"lng"];
    //mark_long
    [AppClient action:@"list_all_v5"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finish(nil,nil, VehicleSourceUpdateFailed,0,0);
                   } else {
                       @try {
                           NSArray* vehicleDatas;
                           NSInteger countNumber = 0;
                           NSArray* recommendData;
                           NSInteger allNumber = 0;
                           
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               if ([response.data objectForKey:@"vehicles"] != nil && ![[response.data objectForKey:@"vehicles"] isEqual:[NSNull null]]) {
                                   vehicleDatas = (NSArray *)[response.data objectForKey:@"vehicles"];
                               }
                               if ([response.data objectForKey:@"recommend"] != nil && ![[response.data objectForKey:@"recommend"] isEqual:[NSNull null]]) {
                                   recommendData = (NSArray *)[response.data objectForKey:@"recommend"];
                               }
                               
                               countNumber = [[NSString isEqualTo:response.data key:@"count"] integerValue];
                               allNumber = [[NSString isEqualTo:response.data key:@"show_count"] integerValue];
                           }
                           
                           if (recommendData.count==0) {
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   Vehicle *vehicle;
                                   if ([vehicleDic objectForKey:@"title"]&&![[vehicleDic objectForKey:@"title"] isEqualToString:@""]) {
                                       vehicle= [[Vehicle alloc] initWithActivityData:vehicleDic];
                                       [vehicleList addObject:vehicle];
                                   }else if([vehicleDic objectForKey:@"near_city"]&&![[vehicleDic objectForKey:@"near_city"] isEqualToString:@""]){
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
                               finish(vehicleList,nil, VehicleSourceUpdateSuccess,countNumber,allNumber);
                           }else{
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               NSMutableArray *vehicledata = [NSMutableArray arrayWithArray:vehicleDatas];
                               if (vehicleDatas.count<10&&vehicleDatas.count>0) {
                                   for (int i=0; i<recommendData.count; i++) {
                                       [vehicledata addObject:[recommendData HCObjectAtIndex:i]];
                                   }
                               }
                               for (NSDictionary* vehicleDic in vehicledata) {
                                   Vehicle *vehicle;
                                   if ([vehicleDic objectForKey:@"title"]&&![[vehicleDic objectForKey:@"title"] isEqualToString:@""]) {
                                       vehicle= [[Vehicle alloc] initWithActivityData:vehicleDic];
                                       [vehicleList addObject:vehicle];
                                   }else if([vehicleDic objectForKey:@"near_city"]&&![[vehicleDic objectForKey:@"near_city"] isEqualToString:@""]){
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
                               [vehicleList insertObject:[[Vehicle alloc]init] atIndex:0];
                               finish(nil,vehicleList,VehicleSourceUpdateSuccess,countNumber,allNumber);
                           }
                       } @catch (NSException *exception) {
                            finish(nil,nil,VehicleSourceUpdateSuccess,0,0);
                       } @finally {
                           
                       }
                       
                   }
               }
     ];
    pageNum = 2;
}

+(void)appendHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary*)dic sortDic:(NSMutableDictionary*)sort  byfinish:(void (^)(NSArray *, NSInteger,NSInteger,NSInteger))finish{
    
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc]init];
    [requestParam addEntriesFromDictionary:sort];
    [requestParam setObject:dic forKey:@"query"];
    [requestParam setObject:LIST_PAGE_SIZE forKey:@"page_size"];
    [requestParam setObject:[NSNumber numberWithInteger:pageNum] forKey:@"page_num"];
    [requestParam setObject:[NSNumber numberWithInteger:[BizUser getUserId]] forKey:@"userid"];
    [requestParam setObject:[HCUUID getHCUUID] forKey:@"uuid"];
    [requestParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selflat"] forKey:@"lat"];
    [requestParam setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selflng"] forKey:@"lng"];
    [AppClient action:@"list_all_v5"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, VehicleSourceUpdateFailed,0,0);
                   } else {
                       NSArray* vehicleDatas;
                       NSArray* recommendData;
                       NSInteger countNumber = 0;
                       if ([response.data isKindOfClass:[NSDictionary class]]) {
                           vehicleDatas = [response.data objectForKey:@"vehicles"];
                           recommendData = [response.data objectForKey:@"recommend"];
                           countNumber = [[response.data objectForKey:@"count"]integerValue];
                       }
                       NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                       NSMutableArray *vehicleData = [NSMutableArray arrayWithArray:vehicleDatas];
                       if (vehicleDatas.count<10&&vehicleDatas.count>0) {
                           for (int i=0; i<recommendData.count; i++) {
                               [vehicleData addObject:[recommendData HCObjectAtIndex:i]];
                           }
                       }
                       for (NSDictionary* vehicleDic in vehicleData) {
                           Vehicle *vehicle;
                           if ([vehicleDic objectForKey:@"title"]) {
                               vehicle= [[Vehicle alloc] initWithActivityData:vehicleDic];
                               [vehicleList addObject:vehicle];
                           }else if([vehicleDic objectForKey:@"near_city"]){
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
                       //merge
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
                      // pageNum++;
                        finish(result, VehicleSourceUpdateSuccess,countNumber,pageNum-1);
                       if (!existNew) {
                           finish(result, VehicleSourceUpdateHistoryNone,countNumber,pageNum-1);
                       } else {
                           finish(result, VehicleSourceUpdateSuccess,countNumber,pageNum-1);
                       }
                   }
               }
     ];
}

+(void)getNewVehicleNumQuery:(NSMutableDictionary*)dic byfinish:(void (^)(NSInteger,NSInteger))finish{
     [dic setObject:[NSNumber numberWithInteger:[BizCity getCurCity].cityId] forKey:@"city"];
    NSDictionary *requestParam = @{@"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"query":dic,
                                   };
    [AppClient action:@"list_today_count_v3"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {
                       finish(0,response.code);
                   }else{
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSInteger count = [[response.data objectForKey:@"count"]integerValue];
                               finish(count,response.code);
                           }
                       } @catch (NSException *exception) {
                           finish(0,response.code);
                       } @finally {
                           
                       }
                   }
               }
     ];

    
}
//筛选条件显示车的数量
+(void)getVehiclesNumQuery:(NSMutableDictionary*)dic suitable:(NSInteger)type byfinish:(void (^)(NSInteger,NSInteger))finish{
    [dic setObject:[NSNumber numberWithInteger:type] forKey:@"suitable"];
    [dic setObject:[NSNumber numberWithInteger:[BizCity getCurCity].cityId] forKey:@"city"];
    NSDictionary *requestParam = @{@"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"query":dic,
                                   };
   
    [AppClient action:@"list_count_v3"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {

                       finish(0,response.code);

                   }else{
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSInteger count = [[response.data objectForKey:@"count"]integerValue];
                               finish(count,response.code);
                           }
                       } @catch (NSException *exception) {
                                finish(0,response.code);
                       } @finally {
                           
                       }
                   }
            }
     ];
}
//直营店数量
+(void)getZhiyingdianVehiclesNumQuery:(NSMutableDictionary*)dic byfinish:(void (^)(NSInteger,NSInteger))finish{
    [dic setObject:[NSNumber numberWithInteger:[BizCity getCurCity].cityId] forKey:@"city"];
    NSDictionary *requestParam = @{@"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"query":dic,
                                   };
    
    [AppClient action:@"list_store_count_v3"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {
                       finish(0,response.code);
                   }else{
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSInteger count = [[response.data objectForKey:@"count"]integerValue];
                               finish(count,response.code);
                           }
                       } @catch (NSException *exception) {
                           finish(0,response.code);
                       } @finally {
                           
                       }
                   }
               }
     ];
}

////首页的推广位
//+(void)HomePromotion:(NSString *)Promotion backRequestParam:(void(^)(NSInteger,NSString *,NSString *,int))finish
//{
//    NSDictionary *requestParam = @{@"udid":Promotion,};
//    NSString *actionName = @"promote";
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response){
//                   if (response.code != 0) {
//                       finish(-1,nil,nil,5);
//                   }else{
//                       @try {
//                           if ([response.data isKindOfClass:[NSDictionary class]]) {
//                               NSString * url = [response.data objectForKey:@"url"];
//                               NSString *image_url = [response.data objectForKey:@"image_url"];
//                               int type = [[response.data objectForKey:@"id"] intValue];
//                               finish(VehicleSourceUpdateSuccess, url,image_url,type);
//                           }
//                       } @catch (NSException *exception) {
//                                finish(VehicleSourceUpdateSuccess, nil,nil,0);
//                       } @finally {
//                           
//                       }
//                       
//                 }
//            }
//     ];
//}

////首页检测版本
//+(void)HomeVersionDetectionBackRequestParam:(void(^)(NSInteger,int,NSArray*))finish
//{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSDictionary *requestParam = @{@"version":app_Version};
//    NSString *actionName = @"version_check";
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response){
//                   if (response.code == 0) {
//                       if ([response.data isKindOfClass:[NSDictionary class]]) {
//                           int type = [[response.data objectForKey:@"update"] intValue];
//                           finish(VehicleSourceUpdateSuccess,type,[response.data objectForKey:@"content"]);
//                       }
//                   }else{
//                        finish(-1,1,0);
//                   }
//            }
//     ];
//}

//检测首页问答
+(void)HomeInterlocutionRequestParam:(void(^)(NSInteger,int,NSArray*,NSString *))finish
{
    NSDictionary *requestParam = @{@"udid" : [HCUUID getHCUUID]};
    NSString *actionName = @"promote_home";
    [AppClient action:actionName
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code == 0) {   //有问题啊
                       if ([response.data isKindOfClass:[NSDictionary class]]) {
                           int type = [[response.data objectForKey:@"type"] intValue];
                           finish(VehicleSourceUpdateSuccess,type,[response.data objectForKey:@"content"],[response.data objectForKey:@"title"]);
                       }
                   }else{
                       finish(-1,1,0,nil);
                   }
               }
     ];
}


//+(void)mViewController:(NSString *)Promotion backRequestParam:(void(^)(NSInteger,NSDictionary*))finish
//{
//    NSDictionary *requestParam = [[NSDictionary alloc]init];
//    requestParam = @{@"udid":Promotion,};
//    NSString *actionName = @"jump_ios";
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response){
//                   if (response.code != 0) {
//                       finish(-1,nil);
//                   }else{
//                       NSDictionary *dictData = [[NSDictionary alloc]init];
//                      dictData = response.data;
//                       
//                       finish(VehicleSourceUpdateSuccess, dictData);
//                   }
//               }
//     ];
//}


@end
