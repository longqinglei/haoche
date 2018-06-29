//
//  MySaleVehicles.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySaleVehicles : NSObject

@property (nonatomic)NSInteger vehicle_source_id;//车源ID
@property (nonatomic,strong)NSString *vehicle_name;//车源名称
@property (nonatomic,strong)NSString *brandName;
@property (nonatomic,strong)NSString *className;
@property (nonatomic)float Miles;
@property (nonatomic,strong)NSString *gearbox;
@property (nonatomic) NSInteger registerYear;
@property (nonatomic) NSInteger registerMonth;
@property (nonatomic,strong)NSString *cover_image;//封面图URL
@property (nonatomic,strong)NSString *correct_text;//纠正文本

@property (nonatomic,strong)NSString *correct_phone;//纠正电话号码
@property (nonatomic,strong)NSString *seller_price;//车源报价

@property (nonatomic,strong)NSString *eval_price;//车源建议价格
@property (nonatomic,strong)NSString *adjust_text;//调整价格文案

@property (nonatomic,strong)NSString *adjust_phone;//调整价格拨打电话
@property (nonatomic)NSInteger buyer_count;//客户咨询数量

@property (nonatomic,strong)NSString *offline_phone;//下线电话
@property (nonatomic,strong)NSString *offline_text;//下线文本

@property (nonatomic,strong)NSString *sell_vehicle_text;//底部跳转文本（比如：我还有车要出售»）
@property (nonatomic,strong)NSString *suggest_text;//按照好车无忧的估值体系进行评估，获得评估结果

@property (nonatomic,strong)NSArray *buyer_list;//客户咨询列表

@property (nonatomic,strong)NSString *online_text;//上线文本（比如：2015/11/09您的爱车成功上线）

@property (nonatomic,strong)NSString *sell_text;//售出文本（比如：2015/11/09您的爱车成功售出）
@property (nonatomic)NSInteger status;//车源状态编码(-1，下线处理；1，没有提交爱车出售信息；2,暂未上线；3,在售；4，已售)

@property (nonatomic)NSString *status_text;//车源状态文本

@property (nonatomic,strong)NSString *brand_id;

@property (nonatomic,strong)NSString *ask_seller_text;
@property (nonatomic,strong)NSString *ask_seller_phone;


- (void)initWithData:(NSDictionary *)data;
@end
