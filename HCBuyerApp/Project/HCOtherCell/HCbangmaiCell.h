//
//  HCbangmaiCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/24.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCbangmaiDelegate <NSObject>

- (void)mEditing:(BOOL)open;
- (void)delegatePhone:(NSString*)phoneNum;
@end


@interface HCbangmaiCell : UITableViewCell

@property (nonatomic,strong)id<HCbangmaiDelegate>delegate;

@property (nonatomic,strong)UIButton *findBtn;
- (instancetype)initWithbangmai;
- (void)hideGusselike;
//- (void)setbangmai:(Vehicle*)vehicle;
- (void)resetPeopleNum:(Vehicle*)vehicle;
- (void)setVehicleInfoLabeltext:(NSString *)vehicleInfo;
@end
