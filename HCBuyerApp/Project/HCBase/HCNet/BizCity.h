//
//  BizCity.h
//  HCBuyerApp
//
//  Created by wj on 15/3/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface BizCity : NSObject

//异步获取服务端城市列表。按照首字符排序
+(void)getCityListOrderedRemote:(BOOL)localEmpty finish:(void (^)(NSArray*))finish;

+ (NSDictionary *)getCityListOrderedFromLocal;

+ (CityElem *)getCurCity;

+ (void)saveSelectedCity:(CityElem *)city;

+ (void)getRecommendCityByLat:(float)lat andLng:(float)lng byfinish:(void(^)(CityElem *))finish;

+ (BOOL)isCitySelected;

+ (CityElem *)getRecommendCity;
@end
