//
//  HCNearCityCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/23.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"
@interface HCNearCityCell : UITableViewCell
- (instancetype)initWithNearCity;
- (void)setnearcity:(Vehicle*)vehicle;
@end
