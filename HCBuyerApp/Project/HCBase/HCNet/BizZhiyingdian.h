//
//  BizZhiyingdian.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/21.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFilter.h"
#import "VehicleSourceUpdateStatus.h"
@interface BizZhiyingdian : NSObject
+ (void)updateZhiyingdianVehicleListQuery:(NSMutableDictionary *)query Page:(NSInteger)page_num sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish;
@end
