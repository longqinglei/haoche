//
//  GuideModel.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/6/8.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideModel : NSObject
@property (nonatomic)NSInteger mid;
@property (nonatomic,strong)NSString *image_url;
@property (nonatomic)NSInteger jump;
@property (nonatomic,strong)NSString *redirect;
@property (nonatomic)NSInteger show_time;
-(id)initWithData:(NSDictionary*)dict;
@end
