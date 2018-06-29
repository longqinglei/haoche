//
//  CondBtn.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

@protocol CondDelegate <NSObject>

//- (void)

@end
#import <UIKit/UIKit.h>
#import "DataFilter.h"
#import "StoreModel.h"

@interface CondBtn : UIButton
@property (nonatomic)SEL selector;
@property (nonatomic,strong)id target;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *restrict_url;
@property (nonatomic,strong)PriceCond *priceCond;
@property (nonatomic,strong)BrandSeriesCond *brandCond;
@property (nonatomic,strong)Activity *activity;
- (id)initWithPriceCond:(PriceCond*)cond;
- (id)initWithActivity:(Activity*)activity;
- (id)initWithBrandCond:(BrandSeriesCond *)cond WithTaget:(id)target WithSelector:(SEL)selector;

@end
