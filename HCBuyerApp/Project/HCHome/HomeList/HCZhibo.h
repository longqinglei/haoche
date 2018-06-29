//
//  HCZhibo.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/10/12.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCZhibo : NSObject
@property (strong, nonatomic) NSString *pic_url;
@property (strong, nonatomic) NSString *link_url;
@property (strong, nonatomic) NSString *title;
-(instancetype)initWithZhiBoData:(NSDictionary *)data;
@end
