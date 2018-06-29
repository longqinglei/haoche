//
//  BizRquestStartPage.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/28.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuideModel.h"
@interface BizRquestStartPage : NSObject
//app启动页
+(void)guideviewRequestFinish:(void(^)(NSInteger,GuideModel *,GuideModel*,NSArray *))finish;

@end
