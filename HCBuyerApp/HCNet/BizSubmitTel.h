//
//  BizSubmitTel.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizSubmitTel : NSObject

+ (void)getSaleDataByFinish:(void (^)(NSDictionary *, NSInteger))finish;

+ (void)submitTelWithphone:(NSString*)telenum byFinish:(void (^)(NSDictionary *, NSInteger, NSString* ))finish;
@end
