//
//  HCAllVehicleView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/18.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFilter.h"

@interface HCAllVehicleView : UIView

#pragma mark - public   以后拆分类用这个view

- (void)setupRefresh:(UITableView*)tableView;

-(NSMutableDictionary*)setSortType:(DataFilter *)dataFilter;

//- (void)showButtonOption:(NSArray *)_arrayAll button:(UIButton *)filterBtn w:(int)W addTarget:(id)target action:(SEL)action view:(UIView *)view;

@end
