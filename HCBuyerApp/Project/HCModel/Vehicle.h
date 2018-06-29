//
//  Vehicle.h
//  HCBuyerApp
//
//  Created by wj on 14-10-18.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHaveSeenVehicle.h"
@interface Vehicle : NSObject


//v3.2新接口
/*
 "id": "142199",
 "city_name": "成都",
 "vehicle_name": "奥迪A4L 2011款 2.0 TFSI 标准型",
 "seller_price": "15.66",
 "shoufu_price": "4.70",
 "register_time": "2011.7",
 "miles": "8.8",
 "geerbox_type": "自动",
 "cover_pic": "?imageView2/2/w/280/h/210",
 "left_top": "",
 "left_top_rate": "",
 "suitable": 0,
 "status": 1,
 "promote": 0
 
 */

@property (nonatomic) NSInteger vehicle_id;
@property (nonatomic,strong) NSString *city_name;
@property (nonatomic,strong) NSString *vehicle_name;
@property (nonatomic,strong) NSString *seller_price;
@property (nonatomic,strong) NSString *shoufu_price;
@property (nonatomic,strong) NSString *register_time;
@property (nonatomic,strong) NSString *miles;
@property (nonatomic,strong) NSString *geerbox_type;
@property (nonatomic,strong) NSString *cover_pic;
@property (nonatomic,strong)NSString *left_top;
@property (nonatomic,strong)NSString *left_top_rate;
@property (nonatomic) int suitable;
@property (nonatomic) int status;
@property (nonatomic) int promote;
@property (nonatomic) int zhiyingdian;
@property (nonatomic) int zhibao;
@property (nonatomic,strong) NSString *act_pic;
@property (nonatomic,strong) NSString *act_text;
@property (nonatomic) NSInteger qianggou;
@property (nonatomic) int yushou;
//@property (nonatomic)id  allReceive;
#pragma mark long add
@property (nonatomic, copy) NSString *store_addr;
@property (nonatomic, copy) NSString *show_baoyou;

@property (nonatomic) int registerDate;
@property (nonatomic) float vehicleMiles;
@property (nonatomic,strong) NSString *strMiles;
@property (nonatomic) int gearboxType;
@property (nonatomic) float cutPrice;
@property (nonatomic, strong) NSString* gearbox;
@property (nonatomic) int oilCard;
@property (nonatomic) int onlineTime;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic) int brandId;
@property (nonatomic, strong) NSString *className;
@property (nonatomic) int offline;
@property (nonatomic) int favStatus;
@property (nonatomic) int cityId;
@property (nonatomic) int createTime;
@property (nonatomic) int activityTime;
@property (nonatomic) int activityStatus;
@property (nonatomic) int recommendStatus;
@property (nonatomic) int collection_status;
//新添加\

@property (nonatomic,strong)id low;
@property (nonatomic,strong)id high;
@property (nonatomic)NSInteger ID;
@property (nonatomic,strong)NSString *geerbox;
@property (nonatomic) NSInteger subID;
@property (nonatomic)float miles_low;
@property (nonatomic)float miles_high;
@property (nonatomic,strong)NSArray *labelArray;
////专题数据
@property (nonatomic)NSInteger features_id;
@property (nonatomic)int jump;
@property (nonatomic,strong)NSString *redirect_url;
@property (nonatomic)float pic_rate;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *image_url;
//@property (nonatomic,strong)NSString *share_title;
//@property (nonatomic,strong)NSString *share_desc;
//@property (nonatomic,strong)NSString *share_image;

//第一次行的活动
@property (nonatomic)int activity;


//分享
@property (nonatomic, strong) NSString *share_title;
@property (nonatomic, strong) NSString *share_desc;
@property (nonatomic, strong) NSString *share_link;
@property (nonatomic, strong) NSString *share_image;
@property (nonatomic) NSInteger register_year;
//2.3接口 闪购返回的字段
@property (nonatomic,strong)NSString *promote_text;



@property (nonatomic) float cheapPrice;
@property (nonatomic, strong) NSString *awardInfo;

@property (nonatomic, strong) NSString *detailTitle;

@property (nonatomic) int refresh_time;

@property (nonatomic) float quoted_price;
@property (nonatomic) float dealer_buy_price;
@property (strong, nonatomic) NSArray *coverImgUrls;

@property (nonatomic) BOOL isSelectedForCompare;
@property (nonatomic,strong)NSString *askPhone;
//2.7
@property (nonatomic) NSInteger bangmaiCount;
@property (nonatomic,strong)NSString *nearCity;

//2.9.1


@property (nonatomic,strong)NSString *left_bottom;
@property (nonatomic,strong)NSString *left_bottom_rate;
//@property (nonatomic) int recommend_time;
-(instancetype)initWithActivityData:(NSDictionary *)data ;
-(instancetype)initWithVehicleData:(NSDictionary *)data;
- (void)setdataWithdic:(NSDictionary*)dic;
//- (NSString *)getSharedTitle;
- (instancetype)initNearcity:(NSDictionary*)dict;

//- (instancetype)initbangmaicount:(NSDictionary *)dict;
@end
