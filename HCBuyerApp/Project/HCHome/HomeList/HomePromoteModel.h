//
//  HomePromoteModel.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/30.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePromoteModel : NSObject

@property (strong, nonatomic) NSString *bannerImgaeUrl;
@property (strong, nonatomic) NSString *redirect_url;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) NSInteger cityId;
@property (nonatomic, strong) NSString *share_des;
@property (nonatomic, strong) NSString *share_image;
@property (nonatomic, strong) NSString *share_title;
@property (nonatomic) int login_check;
@property (nonatomic,strong)NSString *pic_rate;
-(instancetype)initWithData:(NSDictionary *)data and:(BOOL)banner;




//2.9版本添加的
@property (nonatomic,strong)NSString *mHead_url;
@property (nonatomic,strong)NSString *mPhone;
@property (nonatomic)float mScore;
@property (nonatomic,strong)NSString *mContent;
@property (nonatomic,strong)NSString *mVehicle_info;
@property (nonatomic,strong)NSString *mFrom;




@end
