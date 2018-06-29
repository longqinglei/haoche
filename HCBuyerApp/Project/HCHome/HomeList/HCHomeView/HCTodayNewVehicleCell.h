//
//  HCTodayNewVehicleCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/4/19.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HCTodayNewVehicleCellDelegate <NSObject>
-(void)clickMoreShare;
@end
@interface HCTodayNewVehicleCell : UITableViewCell
@property (nonatomic)BOOL isHaveLine;
@property (nonatomic,assign) id <HCTodayNewVehicleCellDelegate> delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
