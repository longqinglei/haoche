//
//  BizSearch.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/23.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizSearch.h"
#import "BizUser.h"
#import "BizCity.h"
#import "AppClient.h"
@implementation BizSearch


+(void)getHotSearchByFinish:(void (^)(NSArray *, NSInteger))finish{
    
      NSDictionary *requestParam = @{
                @"udid" : [NSNumber numberWithInteger:[BizUser getUserId]],
                    };
    [AppClient action:@"hot_search"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0){
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               NSArray* searchData = response.data;
                               finish(searchData, 0);
                           }
                       } @catch (NSException *exception) {
                           finish(nil, 0);
                       } @finally {
                           
                       }
                   }
               }
     ];
}

+ (void)getAssociateDataWithText:(NSString *)text ByFinish:(void(^)(NSArray *, NSInteger))finish{
    NSDictionary *requestParam = @{
                                   @"keyword" : text,
                                   };
    [AppClient action:@"search_suggestion"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0){
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               NSArray* searchData = response.data;
                               finish(searchData, 0);
                           }

                       } @catch (NSException *exception) {
                            finish(nil, 0);
                       } @finally {
                           
                       }
                }
            }
     ];
}

+ (void)getSearchResultWithText:(NSString*)text ByFinish:(void(^)(NSArray *, NSInteger,NSInteger,NSDictionary*))finish{
        NSDictionary *requestParam = @{
                                        @"query" : text,
                                        @"city_id":[NSNumber numberWithInteger:[BizCity getCurCity].cityId],
                                        @"page_num":@1,
                                        @"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                                        @"order":@"time",
                                        @"desc":@0,
                                        @"page_size":LIST_PAGE_SIZE
                                   };
    [AppClient action:@"list_search_v3"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0){
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil, -1,0,nil);
                   } else {
                       NSMutableArray* searchData = [[NSMutableArray alloc]init];
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSArray* searchVehicle = [response.data objectForKey:@"recommend"];
                               NSInteger vehicleNum = [[response.data objectForKey:@"count"]integerValue];
                               NSDictionary *query = response.query;
                               for (NSDictionary *dict in searchVehicle) {
                                   Vehicle *vehicle = [[Vehicle alloc]initWithVehicleData:dict];
                                   [searchData addObject:vehicle];
                               }
                               [searchData insertObject:[[Vehicle alloc]init] atIndex:0];
                               finish(searchData, 0,vehicleNum,query);
                               }
                       } @catch (NSException *exception) {
                             finish(searchData, 0,0,nil);
                       } @finally {
                           
                       }
                   }
                   
               }
     ];
}

//+(void)getStartChartElevenFinish:(NSString *)text and:(NSString *)number ByFinish:(void (^)(NSArray *, NSInteger, NSString *))finish{
//    
//    NSDictionary *requestParam = @{@"phone":text,@"type":number};
//    [AppClient action:@"alocate_coupon"
//           withParams:requestParam
//               finish:^(HttpResponse* response){
//                   if (response.code != 0){
//                       NSLog(@"Http response error: %@", response.errMsg);
//                       finish(nil, -1,response.errMsg);
//                   } else {
//                       NSArray* searchData = response.data;
//                       finish(searchData, 0,response.errMsg);
//                   }
//                   
//               }
//     ];
//}



@end
