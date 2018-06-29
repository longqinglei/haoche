//
//  HCHomeButtonCell.h
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/19.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHomeButtonCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *data;

+ (instancetype)creatTableViewCellWithTableView:(UITableView *)tableView;

@end
