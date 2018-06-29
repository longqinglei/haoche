//
//  BizRquestStartPage.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/28.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "BizRquestStartPage.h"
#import "GuideModel.h"
@implementation BizRquestStartPage

+(void)guideviewRequestFinish:(void(^)(NSInteger,GuideModel *,GuideModel*,NSArray *))finish{
    NSDictionary *requestParam  = @{@"udid":@"Promotion"};
    [AppClient action:@"promote_start"
           withParams:requestParam
               finish:^(HttpResponse* response){
                   if (response.code != 0) {
                       finish(-1,nil,nil,nil);
                   }else{
                       if ([response.data isKindOfClass:[NSDictionary class]]) {
                           GuideModel *bodyModel = [[GuideModel alloc]initWithData:[response.data objectForKey:@"body"]];
                           GuideModel *footModel = [[GuideModel alloc]initWithData:[response.data objectForKey:@"foot"]];
                           NSMutableArray *modelarr = [[NSMutableArray alloc]init];
                           [modelarr addObject:bodyModel];
                           [modelarr addObject:footModel];
                           finish(0, bodyModel,footModel,modelarr);
                       }
                       
                   }
               }
     ];

    
}



@end
