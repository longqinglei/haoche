//
//  HCBuyListCell.h
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/22.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@interface HCBuyListCell : UITableViewCell

@property (nonatomic, strong) Vehicle *vehicle;

+ (instancetype)creatTableViewCellWithTableView:(UITableView *)tableView;

@end
