//
//  BizVisitRecord.h
//  HCBuyerApp
//
//  Created by wj on 15/6/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizVisitRecord : NSObject



//更换一个
//+(void)getNewVisitRecord:(NSInteger)page Record:(void (^)(NSArray *, NSInteger))finish;


//下面俩个
+(void)getNewVisitRecord:(void (^)(NSArray *, NSInteger))finish;

+(void)appendHistoryRecordForlist:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish;


+(void)getOrderRecord:(void (^)(int , NSInteger))finish;

@end
