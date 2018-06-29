//
//  Vehicle.m
//  HCBuyerApp
//
//  Created by wj on 14-10-18.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "Vehicle.h"
#import "City.h"
#import "BizCity.h"

@implementation Vehicle


- (NSString *)isEqualTo:(NSDictionary *)data key:(NSString *)key
{
    if ([data objectForKey:key]==nil){
        return @"";
    }else if([[data objectForKey:key] isEqual:[NSNull null]]){
        return @"";
    }else if([data objectForKey:key]){
         return [data objectForKey:key];
    }else {
        return @"";
    }
}

-(instancetype)initWithVehicleData:(NSDictionary *)data {
    self = [super init];
    if (self) {
         if ([data isKindOfClass:[NSDictionary class]]) {
             @try {
                 
                 self.left_top = [self isEqualTo:data key:@"left_top"];
                 self.left_bottom = [self isEqualTo:data key:@"left_bottom"];
                 self.left_top_rate = [self isEqualTo:data key:@"left_top_rate"];
                 self.left_bottom_rate = [self isEqualTo:data key:@"left_bottom_rate"];
                 self.vehicle_id = [(NSNumber*)[self isEqualTo:data key:@"id"] integerValue];
                 self.vehicle_name = [data objectForKey:@"vehicle_name"];
                 self.city_name = [data objectForKey:@"city_name"];
                 
                 if ([data objectForKey:@"city_name"] &&![[data objectForKey:@"city_name"] isEqualToString:[BizCity getCurCity].cityName]) {
                    self.vehicle_name = [NSString stringWithFormat:@"[%@]%@",self.city_name,self.vehicle_name];
                 }
                 self.createTime = [[data objectForKey:@"create_time"]intValue];
                  self.yushou = [[data objectForKey:@"yushou"]intValue];
                 self.seller_price = [data objectForKey:@"seller_price"];
                 self.shoufu_price = [data objectForKey:@"shoufu_price"];
                 self.register_time = [data objectForKey:@"register_time"];
                 self.miles = [data objectForKey:@"miles"];
                 self.geerbox_type = [data objectForKey:@"geerbox_type"];
                 self.cover_pic =[NSString getFixedSolutionImageUrl: [data objectForKey:@"cover_pic"]];
                 self.suitable = [(NSNumber*)[self isEqualTo:data key:@"suitable"] intValue];
                 self.status =  [(NSNumber*)[self isEqualTo:data key:@"status"] intValue];
                 self.promote = [(NSNumber*)[self isEqualTo:data key:@"promote"] intValue];
                 self.zhiyingdian = [(NSNumber*)[self isEqualTo:data key:@"zhiyingdian"] intValue];
                 self.zhibao = [(NSNumber*)[self isEqualTo:data key:@"zhibao"] intValue];
                 self.act_pic = [self isEqualTo:data key:@"act_pic"];
                 self.act_text = [self isEqualTo:data key:@"act_txt"];
                 self.qianggou = [(NSNumber*)[self isEqualTo:data key:@"qianggou"] integerValue];
                // self.qianggou = 1474543380;
                 self.store_addr = data[@"store_addr"];
                 self.show_baoyou = data[@"show_baoyou"];
             } @catch (NSException *exception) {
                 
             } @finally {
                 
             }
             
         }
    }
    return self;
}

- (instancetype)initNearcity:(NSDictionary*)dict{
    self = [super init];
    if (self) {  if ([dict isKindOfClass:[NSDictionary class]]) {
        self.nearCity = [self isEqualTo:dict key:@"near_city"];}
    }
    return self;
}


-(instancetype)initWithActivityData:(NSDictionary *)data {
    self = [super init];
    if (self) {
         if ([data isKindOfClass:[NSDictionary class]]) {
        self.features_id =  [(NSNumber*)[self isEqualTo:data key:@"id"] intValue];
        
        self.jump =  [(NSNumber*)[self isEqualTo:data key:@"jump"] intValue];
        self.redirect_url = [self isEqualTo:data key:@"redirect_url"];
        self.pic_rate =  [(NSNumber*)[self isEqualTo:data key:@"pic_rate"] floatValue];
        self.image_url = [NSString getFixedSolutionImageAllurl:[self isEqualTo:data key:@"image_url"] w:HCSCREEN_WIDTH*2 h:HCSCREEN_WIDTH/self.pic_rate*2];
        self.title = [self isEqualTo:data key:@"title"];
        self.share_desc = [self isEqualTo:data key:@"share_desc"];
        self.share_image = [self isEqualTo:data key:@"share_image"];
        self.share_title = [self isEqualTo:data key:@"share_title"];
         }
    }
    return self;
}
//-(NSString *)detailTitle
//{
//    if (!_detailTitle) {
//        _detailTitle = [self getDetailTitle:self.brandName className:self.className];
//    }
//    return _detailTitle;
//}


//- (NSInteger)convertTimestamp:(NSInteger)year andMonth:(NSInteger)month
//{
//    NSString *dateStr = [[NSString alloc] initWithFormat:@"%4ld-%2ld-01 00:00:00", (long)year, (long)month];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date=[dateFormatter dateFromString:dateStr];
//    return [date timeIntervalSince1970];
//}

//- (NSString *)getDetailTitle:(NSString *)brandName className:(NSString *)className
//{
//    NSRange range =[className rangeOfString:brandName];
//    if (range.length > 0) {
//        return className;
//    } else {
//        return [NSString stringWithFormat:@"%@%@", brandName, className];
//    }
//}

- (NSString *)getCityName:(NSInteger)cityId
{
    return [City getCityNameById:cityId];
}

//- (NSString *)getSharedTitle
//{
//    return [NSString stringWithFormat:@"个人好车！%.2f万就能买 %@", self.vehiclePrice, self.vehicleName];
//}

//- (NSString *)getSharedContent
//{
//    //2013年10月上牌 | 已行驶2,2万公里 | 1.8T | 手自一体 | 国五排放
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.registerDate];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY年MM月"];
//    NSString *registerTimeStr = [formatter stringFromDate:confromTimesp];
//    NSString *cnt = [NSString stringWithFormat:@"%@上牌 | 已行驶%.1f万公里 | %@ ",registerTimeStr, self.vehicleMiles, self.gearbox];
//    return cnt;
//}
- (void)setdataWithdic:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
    self.askPhone = [self isEqualTo:dic key:@"ask_phone"];
    self.vehicle_id =[(NSNumber*)[self isEqualTo:dic key:@"id"]integerValue] ;
    self.vehicle_name = [self isEqualTo:dic key:@"vehicle_name"];
    self.brandName = [self isEqualTo:dic key:@"brand_name"];
    self.className = [self isEqualTo:dic key:@"class_name"];
    self.status = [(NSNumber*)[self isEqualTo:dic key:@"status"] intValue];
    self.miles = [self isEqualTo:dic key:@"miles"];
    self.geerbox_type = [self isEqualTo:dic key:@"geerbox_type"];
    self.collection_status = [[self isEqualTo:dic key:@"collection_status"] intValue];
    self.register_time = [self isEqualTo:dic key:@"register_time"];
    self.seller_price = [self isEqualTo:dic key:@"seller_price"];
    self.cover_pic = [NSString getFixedSolutionImageUrl:[self isEqualTo:dic key:@"cover_pic"]];
    self.promote_text = [self isEqualTo:dic key:@"promote_text"];
    self.share_title = [self isEqualTo:dic key:@"share_title"];
    self.share_desc = [self isEqualTo:dic key:@"share_desc"];
    self.share_link = [self isEqualTo:dic key:@"share_link"];
    self.share_image = [self isEqualTo:dic key:@"share_image"];
    }
}

@end
