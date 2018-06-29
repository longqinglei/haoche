//
//  BizSearch.h
//  HCBuyerApp
//www
//  Created by 张熙 on 15/9/23.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizSearch : NSObject

+(void)getHotSearchByFinish:(void (^)(NSArray *, NSInteger))finish;

+ (void)getAssociateDataWithText:(NSString*)text ByFinish:(void(^)(NSArray *, NSInteger))finish;

+ (void)getSearchResultWithText:(NSString*)text ByFinish:(void(^)(NSArray *, NSInteger,NSInteger,NSDictionary* ))finish;



////领取优惠券1111的接口
//+(void)getStartChartElevenFinish:(NSString *)text and:(NSString *)number ByFinish:(void (^)(NSArray *, NSInteger,NSString*))finish;
//



@end
