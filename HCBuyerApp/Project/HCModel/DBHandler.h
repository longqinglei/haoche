//
//  DBHandler.h
//  HCBuyerApp
//
//  Created by wj on 14-10-21.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBHandler : NSObject

+ (FMDatabase *)getDBHandle;

+ (void)dropDB;

+ (FMDatabase *)getDBhhh;
@end
