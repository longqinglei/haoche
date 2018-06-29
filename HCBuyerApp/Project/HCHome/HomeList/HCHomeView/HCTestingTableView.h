//
//  HCTestingTableView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Banner.h"
@protocol HCTestingTableViewDelegate <NSObject>

- (void)topBrannerClick:(Banner *)banner;

- (void)cityBtnClick;

- (void)searchBtnClick;

@end


@interface HCTestingTableView : UIView

@property (assign, nonatomic) id<HCTestingTableViewDelegate> delegate;
@property (nonatomic,strong) UIButton *cityButton;
@property (nonatomic,strong) UIButton *searchButton;
@property (nonatomic,strong) UILabel *vehicleNumLabel;
- (id)initWithFrame:(CGRect)frame data:(NSArray *)bannerArray;
- (void)resetVehicleNum :(NSString*)vehicleNum;
//- (void)ViewData:(NSDictionary *)dict;
- (void)networkerror;
- (void)resetSliderView:(NSArray*)sliderList;
@end
