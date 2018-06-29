//
//  AppClient.h
//  BuyerApp
//
//  Created by sjchao on 14-9-20.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "AFNetworking.h"


typedef enum {
    NetWorkType_None = 0,
    NetWorkType_WIFI,
    NetWorkType_2G,
    NetWorkType_3G,
} NetWorkType;

@interface HttpResponse : NSObject
@property(nonatomic, assign) int code;
@property(nonatomic, copy) NSString* errMsg;
@property(nonatomic, retain) id data;
@property(nonatomic,strong)NSDictionary *query;

@end

@interface AppClient : AFHTTPRequestOperationManager

+(instancetype)sharedClient;

+(void)action:(NSString*)action withParams:(NSDictionary*)params finish:(void (^)(HttpResponse*))finish;
+(void)tongji:(NSString *)Param;
+(void)tongji:(NSString *)Params finish:(void(^)(BOOL))finish;



@end
