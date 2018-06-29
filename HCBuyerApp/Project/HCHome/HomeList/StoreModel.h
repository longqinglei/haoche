//
//  StoreModel.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/26.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Activity : NSObject
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *url;
- (id)initWithActivityDic:(NSDictionary*)data;
@end

@interface Promotion : NSObject
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *image_url;
@property (nonatomic)NSInteger type;
- (id)initWithPromotionDic:(NSDictionary*)data;
@end

@interface StoreModel : NSObject
@property (nonatomic,strong)NSMutableArray *vehicleArr;
@property (nonatomic,strong)NSString *topImageUrl;
@property (nonatomic,strong)NSString *redirect_url;
@property (nonatomic,assign)NSInteger vehicleCount;
- (id)initWithDataDic:(NSDictionary*)data;
@end
