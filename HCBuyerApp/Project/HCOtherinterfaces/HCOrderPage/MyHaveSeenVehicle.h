//
//  MyHaveSeenVehicle.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHaveSeenVehicle : NSObject
//各个状态 1已预约 2看车失败 3看车失败已出售按钮隐藏 4预定公司过户 5成交自己过户 6成交未使用 7成交已用卷

@property (nonatomic,strong)NSString *mPlace;
@property (nonatomic,strong)NSString *mTime;
@property (nonatomic)NSInteger mStatus;
@property (nonatomic,strong)NSString *mGeerbox;
@property (nonatomic,strong)NSString *mImage;
@property (nonatomic,strong)NSString *mRegister_time;
@property (nonatomic,strong)NSString *mVehicle_online;
@property (nonatomic,strong)NSString *mVehicle_name;
@property (nonatomic,strong)NSString *mMile;// 公里
@property (nonatomic,strong)NSString *mName;  //专员人名
@property (nonatomic,strong)NSString *mTrans_status; //交易状态
@property (nonatomic,strong)NSString *mVehicle_source_id;//车源ID
@property (nonatomic,strong)NSString *mType; //type 类型
@property (nonatomic)NSInteger mId;  //
@property (nonatomic,strong)NSString *mPhone;//电话
@property (nonatomic,strong)NSString *mCoupon_amount; //优惠券价格
@property (nonatomic,strong)NSString *mCoupon_type; //优惠券类型
@property (nonatomic,strong)NSString *mDesc;    //
@property (nonatomic,strong)NSString *mPrice;
@property (nonatomic,strong)NSString *mComment;
@property (nonatomic,strong)NSString *brand_name;
@property (nonatomic,strong)NSString *class_name;

-(instancetype)initWithVehicleDataNew:(NSDictionary *)data;
- (NSString*)geerbox;
@end
