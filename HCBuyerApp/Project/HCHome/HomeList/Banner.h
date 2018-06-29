//
//  Banner.h
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property (strong, nonatomic) NSString *pic_url;
@property (strong, nonatomic) NSString *link_url;
@property (strong, nonatomic) NSString *title;

//@property (nonatomic) NSInteger cityId;

//@property (nonatomic, strong) NSString *share_des;

@property (nonatomic, strong) NSString *share_image;

//@property (nonatomic, strong) NSString *share_link;
//@property (nonatomic, strong) NSString *share_title;
//@property (nonatomic) int login_check;

//单加的高度比例
@property (nonatomic,strong)NSString * mHeightRatio;

-(instancetype)initWithBannerData:(NSDictionary *)data;

//+ (void)createTable;
//
//+ (NSArray *)getBannerList:(NSInteger)cityId;
//
//+ (void)batchUpdateBannerList:(NSArray *)bannerData forCity:(NSInteger)cityId;

-(instancetype)initWithTopSliderData:(NSDictionary *)data;
@end
