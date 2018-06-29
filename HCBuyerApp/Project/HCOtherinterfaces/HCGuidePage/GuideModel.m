//
//  GuideModel.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/6/8.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "GuideModel.h"

@implementation GuideModel
-(id)initWithData:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            @try {
                self.mid = [(NSNumber*) [self isEqualTo:dict key:@"id"]integerValue];
                self.redirect = [self isEqualTo:dict key:@"redirect"];
                self.jump = [(NSNumber*) [self isEqualTo:dict key:@"jump"]integerValue];
                self.show_time = [(NSNumber*) [self isEqualTo:dict key:@"show_time"]integerValue];
                self.image_url = [self isEqualTo:dict key:@"image_url"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
       
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.mid forKey:@"id"];
    [aCoder encodeInteger:self.jump forKey:@"jump"];
    [aCoder encodeInteger:self.show_time forKey:@"show_time"];
    [aCoder encodeObject:self.redirect forKey:@"redirect"];
    [aCoder encodeObject:self.image_url forKey:@"image_url"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.mid = [aDecoder decodeIntegerForKey:@"id"];
    self.jump = [aDecoder decodeIntegerForKey:@"jump"];
    self.show_time = [aDecoder decodeIntegerForKey:@"show_time"];
    self.redirect = [aDecoder decodeObjectForKey:@"redirect"];
    self.image_url = [aDecoder decodeObjectForKey:@"image_url"];
    
    return self;
}

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
@end
