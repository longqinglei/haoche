//
//  MySaleVehicles.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "MySaleVehicles.h"
/*
 "id": "20036",
 "brand_name": "阿尔法罗密欧",
 "class_name": "ALFA 156",
 "register_year": "2007",
 "register_month": "4",
 "miles": "1.6",
 "geerbox": "自动"*/
@implementation MySaleVehicles

- (void)initWithData:(NSDictionary *)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        @try {
            if ([data objectForKey:@"brand_name"]) {
                self.brandName = [data objectForKey:@"brand_name"];
            }
            if ([data objectForKey:@"class_name"]) {
                self.className = [data objectForKey:@"class_name"];
            }if ([data objectForKey:@"register_year"]) {
                self.registerYear = [(NSNumber*)[data objectForKey:@"register_year"] intValue];
            }
            if ([data objectForKey:@"register_month"]) {
                self.registerMonth = [(NSNumber*)[data objectForKey:@"register_month"] intValue];
            }
            if ([data objectForKey:@"vehicle_source_id"]) {
                self.vehicle_source_id = [[data objectForKey:@"vehicle_source_id"]integerValue];
            }
            if ([data objectForKey:@"miles"]) {
                self.Miles = [[data objectForKey:@"miles"]floatValue];
            }
            if ([data objectForKey:@"geerbox"]) {
                self.gearbox = [data objectForKey:@"geerbox"];
            }
            if ([data objectForKey:@"vehicle_name"]) {
                self.vehicle_name = [data objectForKey:@"vehicle_name"];
            }
            if ([data objectForKey:@"cover_image"]) {
                self.cover_image = [data objectForKey:@"cover_image"];
            }
            if ([data objectForKey:@"correct_text"]) {
                self.correct_text =  [data objectForKey:@"correct_text"];
            }
            if ([data objectForKey:@"correct_phone"]) {
                self.correct_phone = [data objectForKey:@"correct_phone"];
            }
            if ([data objectForKey:@"seller_price"]) {
                self.seller_price = [data objectForKey:@"seller_price"] ;
            }
            if ([data objectForKey:@"eval_price"]) {
                self.eval_price =  [data objectForKey:@"eval_price"];
            }
            if ([data objectForKey:@"adjust_text"]) {
                self.adjust_text =  [data objectForKey:@"adjust_text"];
            }
            if ([data objectForKey:@"adjust_phone"]) {
                self.adjust_phone =  [data objectForKey:@"adjust_phone"];
            }
            if ([data objectForKey:@"buyer_count"]) {
                self.buyer_count =  [[data objectForKey:@"buyer_count"]integerValue];
            }
            if ([data objectForKey:@"buyer_list"]) {
                self.buyer_list =  [data objectForKey:@"buyer_list"];
            }if ( [data objectForKey:@"offline_phone"]) {
                self.offline_phone =  [data objectForKey:@"offline_phone"];
            }
            if ([data objectForKey:@"offline_text"]) {
                self.offline_text =  [data objectForKey:@"offline_text"];
            }
            if ([data objectForKey:@"online_text"]) {
                self.online_text = [data objectForKey:@"online_text"];
            }
            if ([data objectForKey:@"sell_text"]) {
                self.sell_text =  [data objectForKey:@"sell_text"];
            }
            if ([data objectForKey:@"sell_vehicle_text"]) {
                self.sell_vehicle_text  =  [data objectForKey:@"sell_vehicle_text"];
            }
            if ([data objectForKey:@"suggest_text"]) {
                self.suggest_text =  [data objectForKey:@"suggest_text"];
            }
            if ([data objectForKey:@"status"]) {
                self.status = [[data objectForKey:@"status"]integerValue];
            }
            if ([data objectForKey:@"status_text"]) {
                self.status_text = [data objectForKey:@"status_text"];
            }
            if ([data objectForKey:@"brand_id"]) {
                self.brand_id = [data objectForKey:@"brand_id"];
            }
            if ([data objectForKey:@"ask_seller_text"]) {
                self.ask_seller_text = [data objectForKey:@"ask_seller_text"];
            }
            if ([data objectForKey:@"ask_seller_phone"]) {
                self.ask_seller_phone = [data objectForKey:@"ask_seller_phone"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    
    }
}
@end
