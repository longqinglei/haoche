//
//  MyHaveSeenVehicle.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyHaveSeenVehicle.h"

@implementation MyHaveSeenVehicle

-(instancetype)initWithVehicleDataNew:(NSDictionary *)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        @try {
            if ([data objectForKey:@"place"]&&![[data objectForKey:@"place"]isEqual:[NSNull null]]) {
                self.mPlace = [data objectForKey:@"place"];
            }
            if ([data objectForKey:@"image"]&&![[data objectForKey:@"image"]isEqual:[NSNull null]]) {
                self.mImage =[NSString getFixedSolutionImageUrl: [data objectForKey:@"image"]];
            }
            if ([data objectForKey:@"time"]&&![[data objectForKey:@"time"]isEqual:[NSNull null]]) {
                self.mTime = [data objectForKey:@"time"];
            }if ([data objectForKey:@"status"]&&![[data objectForKey:@"status"]isEqual:[NSNull null]]) {
                self.mStatus = [[data objectForKey:@"status"]integerValue];
            }
            if ([data objectForKey:@"geerbox"]&&![[data objectForKey:@"geerbox"]isEqual:[NSNull null]]) {
                self.mGeerbox = [data objectForKey:@"geerbox"];
                self.mGeerbox = [self geerbox];
            }if ([data objectForKey:@"register_time"]&&![[data objectForKey:@"register_time"]isEqual:[NSNull null]]) {
                self.mRegister_time = [data objectForKey:@"register_time"];
            }if ([data objectForKey:@"vehicle_online"]&&![[data objectForKey:@"vehicle_online"]isEqual:[NSNull null]]) {
                if ([[data objectForKey:@"vehicle_online"]isKindOfClass:[NSString class]]) {
                    self.mVehicle_online = [data objectForKey:@"vehicle_online"];
                }else{
                    self.mVehicle_online = [[data objectForKey:@"vehicle_online"]stringValue];
                }
                
            }if ([data objectForKey:@"vehicle_name"]&&![[data objectForKey:@"vehicle_name"]isEqual:[NSNull null]]) {
                self.mVehicle_name = [data objectForKey:@"vehicle_name"];
                
            }if ([data objectForKey:@"mile"]&&![[data objectForKey:@"mile"]isEqual:[NSNull null]]) {
                self.mMile = [data objectForKey:@"mile"];
            }if ([data objectForKey:@"name"]&&![[data objectForKey:@"name"]isEqual:[NSNull null]]) {
                self.mName = [data objectForKey:@"name"];
            }if ([data objectForKey:@"trans_status"]&&![[data objectForKey:@"trans_status"]isEqual:[NSNull null]]) {
                self.mTrans_status = [data objectForKey:@"trans_status"];
            }if ([data objectForKey:@"vehicle_source_id"]&&![[data objectForKey:@"vehicle_source_id"]isEqual:[NSNull null]]) {
                self.mVehicle_source_id = [[data objectForKey:@"vehicle_source_id"]stringValue];
            }if ([data objectForKey:@"type"]&&![[data objectForKey:@"type"]isEqual:[NSNull null]]) {
                self.mType = [data objectForKey:@"type"];
            }if ( [data objectForKey:@"id"]&&![[data objectForKey:@"id"]isEqual:[NSNull null]]) {
                self.mId = [[data objectForKey:@"id"]integerValue];
            }if ([data objectForKey:@"phone"]&&![[data objectForKey:@"phone"]isEqual:[NSNull null]]) {
                self.mPhone = [data objectForKey:@"phone"];
            }if ( [data objectForKey:@"coupon_amount"]&&![[data objectForKey:@"coupon_amount"]isEqual:[NSNull null]]) {
                self.mCoupon_amount = [data objectForKey:@"coupon_amount"];
            }if ([data objectForKey:@"coupon_type"]&&![[data objectForKey:@"coupon_type"]isEqual:[NSNull null]]) {
                if ([[data objectForKey:@"coupon_type"]isKindOfClass:[NSString class]]) {
                    self.mCoupon_type = [data objectForKey:@"coupon_type"];
                }else{
                    self.mCoupon_type = [[data objectForKey:@"coupon_type"]stringValue];
                }
            }if ([data objectForKey:@"desc"]&&![[data objectForKey:@"desc"]isEqual:[NSNull null]]) {
                self.mDesc = [data objectForKey:@"desc"];
            }if ([data objectForKey:@"price"]&&![[data objectForKey:@"price"]isEqual:[NSNull null]]) {
                self.mPrice = [NSString stringWithFormat:@"%@",[data objectForKey:@"price"]];
            }
            if ( [data objectForKey:@"comment"]&&![[data objectForKey:@"comment"]isEqual:[NSNull null]]) {
                self.mComment = [data objectForKey:@"comment"];
            }if ([data objectForKey:@"brand_name"]&&![[data objectForKey:@"brand_name"]isEqual:[NSNull null]]) {
                self.brand_name = [data objectForKey:@"brand_name"];
            }if ([data objectForKey:@"class_name"]&&![[data objectForKey:@"class_name"]isEqual:[NSNull null]]) {
                self.class_name =[data objectForKey:@"class_name"];
            }
            

        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    return self;
}
- (NSString*)geerbox
{
    switch ([self.mGeerbox integerValue]) {
        case 0: return @"不限";
        case 1: return @"手动";
        case 2: return @"自动";
        case 3: return @"双离合";
        case 4: return @"手自一体";
        case 5: return @"无级变速";
    }
    return @"...";
}
//- (void)ifnilmdata:(NSString *)str data:(NSString*)data{
//    if (data) {
//        str = data;
//    }
//}
//- (NSString *)getFixedSolutionImageUrl:(NSString *)imgUrl
//{
//    // NSLog(@"imgurl: %@", imgUrl);
//    NSRange range = [imgUrl rangeOfString:@".jpg"];
//    if (range.length > 0) {
//        NSMutableString *temp = [NSMutableString stringWithString:imgUrl];
//        [temp replaceCharactersInRange:range withString:@".jpg?imageView2/2/w/240/h/180"];
//        return temp;
//    }
//    return @"";
//}


@end
