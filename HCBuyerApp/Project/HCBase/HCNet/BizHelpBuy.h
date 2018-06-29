//
//  BizHelpBuy.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/26.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizHelpBuy : NSObject
+(void)requesthelpbuyWithphone:(NSString*)phone query:(NSDictionary*)query word:(NSString *)keyWord finish:(void (^)(NSInteger))finish;
@end
