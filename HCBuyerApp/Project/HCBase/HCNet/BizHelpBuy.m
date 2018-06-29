//
//  BizHelpBuy.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/26.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "BizHelpBuy.h"
#import "AppClient.h"
#import "BizUser.h"
@implementation BizHelpBuy

+(void)requesthelpbuyWithphone:(NSString*)phone query:(NSDictionary*)query word:(NSString *)keyWord finish:(void (^)(NSInteger))finish{
    NSDictionary *requestParam = @{
                                   @"udid":[NSNumber numberWithInteger:[BizUser getUserId]],
                                   @"phone":phone,
                                   @"query":query,
                                   @"word":keyWord//时间
                                   };
    NSString *actionName = @"buyer_lead_bangmai";
    [AppClient action:actionName
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {
                       finish(response.code);
                   }else{
                       finish(response.code);
                   }
            }
     ];
}


@end
