//
//  BizCoupon.m
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizCoupon.h"
#import "AppClient.h"
#import "User.h"
#import "Coupon.h"
#import "VehicleSourceUpdateStatus.h"
#import "MyHaveSeenVehicle.h"
#import "NSString+ITTAdditions.h"
#import "MyCouponVehicle.h"
#import "BizUser.h"
#import "HCMyHaveSeenVehicle.h"

static NSInteger pageNum = 0;
static NSInteger pageSize = 10;
static NSInteger lastFetchTime = 0;

@implementation BizCoupon

//获取用户优惠劵列表
+(void)getNewCouponRecord:(NSInteger)type  get:(void (^)(NSArray *, NSInteger))finish
{
    pageNum = 1;
    if ([[HCLogin standLog] isLog]) {
        
        
       NSDictionary *requestParam = @{@"page_size":LIST_PAGE_SIZE,
                                      @"phone" :IPHONE,//IPHONE
                                      @"page":[NSNumber numberWithInteger:pageNum],
                                      @"order_by":@"create_time desc",
                                      @"valid":(NSNumber*)[NSNumber numberWithInteger:type]
                                      };
        [AppClient action:@"get_user_coupons"
               withParams:requestParam
                   finish:^(HttpResponse* response) {
                       if (response.code != 0) {
                           NSLog(@"Http response error: %@", response.errMsg);
                           finish(nil, -1);
                       } else {
                           @try {
                               [MyCouponVehicle delettable];
                               Coupon *c;
                               NSArray* couponDatas = response.data;
                               NSMutableArray *couponList = [[NSMutableArray alloc] init];
                               for (NSDictionary* couponDic in couponDatas) {
                                   c = [[Coupon alloc] initWithCouponData:couponDic];
                                   [couponList addObject:c];
                                   [MyCouponVehicle getOrderFrom:couponDic                                                                                                                                                                                ];
                               }
                               finish(couponList, VehicleSourceUpdateSuccess);
                           } @catch (NSException *exception) {
                                finish(nil, VehicleSourceUpdateSuccess);
                           } @finally {
                               
                           }
                          
                       }
                   }
         ];
    }else{
        return;
    }
     pageNum = 2;
}


+(void)appendHistoryRecordForlist:(NSInteger)type  get:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish
{

    if ([[HCLogin standLog] isLog]) {
            NSDictionary *requestParam = @{@"page_size":LIST_PAGE_SIZE,
                                           @"phone" :IPHONE,//IPHONE
                                           @"page":[NSNumber numberWithInteger:pageNum],
                                           @"order_by":@"create_time desc",
                                           @"valid":(NSNumber*)[NSNumber numberWithInteger:type]
                                           };
               [AppClient action:@"get_user_coupons"
               withParams:requestParam
                   finish:^(HttpResponse* response) {
                       if (response.code != 0) {
                           NSLog(@"Http response error: %@", response.errMsg);
                           finish(nil, -1);
                       } else {
                           @try {
                               //[MyCouponVehicle delettable];
                               NSArray* couponDatas = response.data;
                               NSMutableArray *couponList = [[NSMutableArray alloc] init];
                               for (NSDictionary* couponDic in couponDatas) {
                                   Coupon *c = [[Coupon alloc] initWithCouponData:couponDic];
                                   [couponList addObject:c];
                                   [MyCouponVehicle getOrderFrom:couponDic];
                               }
                               NSMutableArray *result = [[NSMutableArray alloc] initWithArray:list];
                               BOOL existNew = NO;
                               for (Coupon *coupon in couponList) {
                                   BOOL exist = NO;
                                   for (Coupon *srcCoupon in list) {
                                       if (coupon.enumId == srcCoupon.enumId) {
                                           exist = YES;
                                           break;
                                       }
                                   }
                                   if (!exist) {
                                       [result addObject:coupon];
                                       existNew = YES;
                                   }
                               }
                               if ([couponList count] == pageSize) {
                                   pageNum += 1;
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

    }else{
        return;
    }
}

//+(void)getCouponDetail:(NSString *)couponId byfinish:(void(^)(Coupon *))finish
//{
//    NSDictionary *requestParam = @{
//                                   @"coupon_id" : couponId,
//                                   };
//    [AppClient action:@"get_coupon_info"
//           withParams:requestParam
//               finish:^(HttpResponse* response) {
//                   if (response.code != 0) {
//                       NSLog(@"Http response error: %@", response.errMsg);
//                       finish(nil);
//                   } else {
//                       NSDictionary* data = response.data;
//                       Coupon *coupon = [[Coupon alloc] initWithCouponData:data];
//                       finish(coupon);
//                   }
//               }
//     ];
//
//}

+(void)updateLastFetchTime
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"checkCoupon"]) {
        lastFetchTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"checkCoupon"]integerValue];
    }else{
        lastFetchTime = 0;
    }
    
}

+(void)checkNewCounpon:(void (^)(NSInteger))finish
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"checkCoupon"]) {
        lastFetchTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"checkCoupon"]integerValue];
    }else{
        lastFetchTime = 0;
    }
    NSDictionary *requestParam = @{
                                   @"phone" :IPHONE,
                                   @"last_check_time" : [NSNumber numberWithInteger:lastFetchTime],
                                   };
    [AppClient action:@"get_coupon_count"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(-1);
                   } else {
                       
                       NSInteger cnt = [response.data integerValue];
                       finish(cnt);
                   }
               }
     ];
}

//兑换优惠券接口
+(void)postNew:(NSString *)couponNumber show:(void (^)(NSString *))strMessg CouponRequest:(void (^)(NSArray *, NSInteger))finishe{
    NSDictionary *requestParam = @{
                                   @"buyer_phone" :IPHONE,
                                   @"code" :couponNumber,
                                   };
    [AppClient action:@"exchange_coupon"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finishe(response.data,response.code);
                       strMessg(response.errMsg);
                   } else {
                       NSInteger cnt = response.code ;
                       finishe(response.data,cnt);
                   }
               }
     ];
}

//使用优惠券
+(void)postUserCoupon:(NSString *)coupon_id trabs_id:(NSString *)trans_id CouponRequest:(void(^)(NSString*,NSInteger))finish{
    
    NSDictionary *requestParam = @{
                                   @"trans_id" : trans_id,
                                   @"coupon_id" :coupon_id,
                                   };
    [AppClient action:@"use_coupon"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"%d",response.code);
                     finish(response.data,response.code);
                   } else {
                       NSInteger cnt = response.code;
                      finish(response.data,cnt);
                   }
               }
     ];
}

//买家订单接口
+(void)postBuy:(NSString *)phone CouponRequest:(void (^)(NSArray *, NSInteger))finishe{
    
    pageNum = 0;
    NSDictionary *requestParam = @{
                                   @"buyer_phone" :phone,
                                   @"limit":LIST_PAGE_SIZE,
                                   @"page":[NSNumber numberWithInteger:pageNum],
                                   };
    [AppClient action:@"get_buyerorder_list"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finishe(nil, response.code);
                   }else{
                    NSMutableArray *couponList = [[NSMutableArray alloc] init];
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               NSArray* couponDatas = response.data;
                               [HCMyHaveSeenVehicle delettable];
                               for (NSDictionary* couponDic in couponDatas) {
                                   MyHaveSeenVehicle *c = [[MyHaveSeenVehicle alloc] initWithVehicleDataNew:couponDic];
                                   [couponList addObject:c];
                                   [HCMyHaveSeenVehicle getOrderFrom:couponDic];
                               }
                               finishe(couponList, 0);
                           }
                       } @catch (NSException *exception) {
                           finishe(couponList, 0);
                       } @finally {
                           
                       }
                      
                   }
                   
               }
     ];
    pageNum = 1;
}

+ (void)postBuyList:(NSString *)phone append:(NSArray*)list CouponRequest:(void (^)(NSArray *, NSInteger))finishe{

    NSDictionary *requestParam = @{
                                   @"limit": LIST_PAGE_SIZE,
                                   @"page":[NSNumber numberWithInteger:pageNum],
                                   @"buyer_phone" :phone,
                                   };
    [AppClient action:@"get_buyerorder_list"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                        finishe(nil, response.code);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               NSArray* vehicleDatas = response.data;
                               NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
                               for (NSDictionary* vehicleDic in vehicleDatas) {
                                   MyHaveSeenVehicle *vehicle = [[MyHaveSeenVehicle alloc] initWithVehicleDataNew:vehicleDic];
                                   [vehicleList addObject:vehicle];
                                   [HCMyHaveSeenVehicle getOrderFrom:vehicleDic];
                               }
                               
                               NSMutableArray *result = [[NSMutableArray alloc] initWithArray:list];
                               BOOL existNew = NO;
                               for (MyHaveSeenVehicle *vehicle in vehicleList) {
                                   BOOL exist = NO;
                                   for (MyHaveSeenVehicle *srcVehicle in list) {
                                       if ([vehicle.mVehicle_source_id isEqualToString: srcVehicle.mVehicle_source_id]) {
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
                                   finishe(result, 0);
                               } else if (!existNew) {
                                   finishe(result, -2);
                               } else {
                                   finishe(result, 0);
                               }
                               
                           }

                       } @catch (NSException *exception) {
                           finishe(nil ,0);
                       } @finally {
                           
                       }
                       
                   }
               }
     ];

}



@end
