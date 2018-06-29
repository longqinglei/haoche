//
//  HCZhibo.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/10/12.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCZhibo.h"

@implementation HCZhibo
-(instancetype)initWithZhiBoData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.pic_url = [data objectForKey:@"pic_url"];
                self.link_url = (NSString *)[data objectForKey:@"link_url"];
                self.title = (NSString *)[data objectForKey:@"title"];
                if (!self.title) {
                    self.title = @"";
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    }
    return self;
}


@end
