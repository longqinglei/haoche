//
//  CityViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/1/4.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
@protocol CityViewControllerDelegate <NSObject>

- (void)pushViewController:(NSInteger)ID CityName:(NSString *)name CityId:(NSInteger)cityId;

@end


@interface CityViewController : UIViewController

@property (strong, nonatomic)UITableView *mTavleView;
@property (assign,nonatomic)id<CityViewControllerDelegate>delegate;
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)NSDictionary *dictArray;
- (void)reloadVIew;
@property (nonatomic)CGFloat arrayHeight;
@property (nonatomic, strong) CityElem *recommendCity;
@property (nonatomic,strong)UILabel *cityName;
- (void)resetCityColor:(NSInteger)cityid;
+(CityViewController*)shareCity;
- (void)getRecommendCity;
@end
