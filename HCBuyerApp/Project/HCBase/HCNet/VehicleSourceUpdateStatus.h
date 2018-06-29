//
//  VehicleSourceUpdateStatus.h
//  HCBuyerApp
//
//  Created by wj on 15/6/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    VehicleSourceUpdateSuccess = 0, //成功
    VehicleSourceUpdateFailed  = -1, //失败
    VehicleSourceUpdateHistoryNone = -2, //无更多历史数据
} VehicleSourceUpdateStatus;