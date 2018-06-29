                                //
//  AppClient.m
//  BuyerApp
//
//  Created by sjchao on 14-9-20.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "AppClient.h"
#import "NSObject+JSON.h"
#import "BizUser.h"
#import "User.h"

#import "SDImageCache.h"
#import "Reachability.h"


#define APPID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define IOSID [AppClient getIOSVersion]

static AppClient *appClient = nil;


#define URL @"index.php"

@implementation AppClient

+ (AppClient *)tongji{
    
    if (appClient == nil) {
        appClient  =[[self alloc]init];
    }
    return appClient;
}

+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

+(instancetype)sharedClient {
    static AppClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        NSMutableSet* typeSet = [NSMutableSet setWithSet:_sharedClient.responseSerializer.acceptableContentTypes];
        [typeSet addObject:@"text/html"];
        _sharedClient.responseSerializer.acceptableContentTypes = typeSet;
        _sharedClient.operationQueue.maxConcurrentOperationCount = 10;
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 10;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return _sharedClient;
}

+(NSDictionary *)createClient:(NSString *)action andParams:(NSDictionary *)parames{
    
    NSMutableDictionary* msg = [[NSMutableDictionary alloc]init];
    NSInteger udid = [User getUserInfo].userId;
    if (udid) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parames];
        [dict setObject:[NSNumber numberWithInteger:udid] forKey:@"udid"];
        parames = [NSDictionary dictionaryWithDictionary:dict];
    }
    [msg setObject:action forKey:@"action"];
    [msg setObject:parames forKey:@"params"];
    NSString *strIos = [NSString stringWithFormat:@"%f",IOSID];
    NSString *strWIth = [NSString stringWithFormat:@"%f",HCSCREEN_WIDTH];
    NSString *strHegit = [NSString stringWithFormat:@"%f",HCSCREEN_HEIGHT];
    NSString *strNumber = [NSString stringWithFormat:@"2"];

    NSDictionary *other = @{
                            @"a_v":APPID,
                            @"s_v":strIos,
                            @"r_w":strWIth,
                            @"r_h":strHegit,
                            @"p":strNumber,
                            @"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                            };

    NSMutableDictionary* req = [[NSMutableDictionary alloc]init];
    [req setObject:Token forKey:@"token"];
    [req setObject:msg forKey:@"msg"];
    [req setObject:other forKey:@"other"];
    NSDictionary *parameters= [NSDictionary dictionaryWithObject:[req JSONPrettyPrintedString] forKey:@"req"];
    return parameters;
}

+ (void)regetRequestSuccess:(id)responseObject httpResponse:(HttpResponse *)response
{
    NSDictionary* result = responseObject;
    NSNumber* code = [result objectForKey:@"errno"];
    response.code = code.intValue;
    if (response.code == 0) {
        if([[result objectForKey:@"data"]isEqual:[NSNull null]]){
            response.data = [[NSArray alloc] init];
            response.errMsg = nil;
        }else{
            response.data = [result objectForKey:@"data"];
            response.errMsg = nil;//注释了也没有
        }
        if ([result objectForKey:@"query"]) {
            response.query = [result objectForKey:@"query"];
        }
    } else if (response.code != -7){
        response.errMsg = [result objectForKey:@"errmsg"];
        response.data = nil;
        response.query= nil;
    } else {
        response.code = 0;
        response.data = [[NSArray alloc] init];
        response.errMsg = nil;
        response.query= nil;
    }
}


+(void)action:(NSString *)action withParams:(NSDictionary *)params finish:(void (^)(HttpResponse *))finish
{
     AppClient* sharedClient = [self sharedClient];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [sharedClient POST:URL parameters:[AppClient createClient:action andParams:params] success:^
     (AFHTTPRequestOperation* operation, id responseObject){
        HttpResponse * response = [[HttpResponse alloc] init];
            [self regetRequestSuccess:responseObject httpResponse:response];
            if (finish) {
             finish(response);
         }
     } failure:^
     (AFHTTPRequestOperation* operation, NSError* error){
         HttpResponse* response = [[HttpResponse alloc] init];
                     response.code = -1;
                     response.errMsg = error.description;
                     response.data = nil;
                     if (finish) {
                         finish(response);
                     }
     }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


+(void)tongji:(NSString *)Params
{
    [self tongji:Params finish:^(BOOL isSuccess) {
        if (isSuccess) {
        }
    }];
}


+(void)tongji:(NSString *)Params finish:(void(^)(BOOL))finish
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSURL * URLString = [NSURL URLWithString:[NSString stringWithFormat:@"%@udid=%ld%@",TONGJI,(long)[BizUser getUserId],Params]];
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URLString];
        NSURLResponse * response = nil;
        NSError * error = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            if (finish){
                finish(NO);
            }
        }else{
            if (finish)
            {finish(YES);
            }
        }
    });
}

@end

@implementation HttpResponse

@end
