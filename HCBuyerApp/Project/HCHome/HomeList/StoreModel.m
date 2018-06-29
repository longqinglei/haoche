//
//  StoreModel.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/26.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "StoreModel.h"
#import "Vehicle.h"


@implementation Activity

-(id)initWithActivityDic:(NSDictionary *)data{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
        self.title = [data objectForKey:@"title"];
        self.url =[self appendingChannelApp:[data objectForKey:@"url"]];
        }
    }
    return self;
}
- (NSString *)appendingChannelApp:(NSString *)url{
    NSString *urlstr;
    if([url rangeOfString:@"?"].location!= NSNotFound){
        urlstr = [NSString stringWithFormat:@"%@&channel=app",url];
    }else{
        urlstr = [NSString stringWithFormat:@"%@?channel=app",url];
    }
    return urlstr;
}
@end

@implementation Promotion

-(id)initWithPromotionDic:(NSDictionary *)data{
    self = [super init];
    if (self) {
          if ([data isKindOfClass:[NSDictionary class]]) {
        self.url = [data objectForKey:@"url"];
        self.image_url = [data objectForKey:@"image_url"];
              self.type = [[data objectForKey:@"id"]integerValue];}
    }
    return self;
}
@end
@implementation StoreModel
- (id)initWithDataDic:(NSDictionary *)data{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.vehicleArr = [[NSMutableArray alloc]init];
                NSArray *vehicleArray = [data objectForKey:@"vehicle"];
                for (NSDictionary *dict  in vehicleArray) {
                    Vehicle *vehicle = [[Vehicle alloc]initWithVehicleData:dict];
                    [self.vehicleArr addObject:vehicle];
                }
                self.topImageUrl = [data objectForKey:@"image"];
                self.vehicleCount = [[data objectForKey:@"count"]integerValue];
                self.redirect_url = [data objectForKey:@"redirect_url"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
       
        }
    }
    return self;
}
@end
