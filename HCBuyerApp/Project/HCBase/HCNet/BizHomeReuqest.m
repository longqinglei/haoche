//
//  BIzHomeReuqest.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/29.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "BizHomeReuqest.h"
#import "BizCity.h"
#import "Banner.h"
#import "HomePromoteModel.h"
#import "StoreModel.h"
#import "DataFilter.h"
#import "ForumModel.h"
#import "HCZhibo.h"
@implementation BizHomeReuqest
+ (void)getHomeForumDataWithPageNum:(int)pageNum byfinish:(void(^)(NSArray *,NSInteger))finish{
    
    NSDictionary *requestParam = @{
                                   @"page_num" :[NSNumber numberWithInt:pageNum]
                                   };
    [AppClient action:@"home_forum_v4"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code!=0) {
                       finish(nil,response.code);
                   }else{
                    NSMutableArray *forumData = [[NSMutableArray alloc]init];
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]){
                               for (NSDictionary *data in response.data) {
                                   ForumModel *model = [[ForumModel alloc]initWithForumData:data];
                                   [forumData addObject:model];
                               }
                           }
                           finish(forumData,response.code);
                       } @catch (NSException *exception) {
                            finish(forumData,response.code);
                       } @finally {
                           
                       }
                   }
        }];
}
+(void)getHomeCityData:(NSInteger )cityid byfinish:(void(^)(NSInteger,NSArray*,NSArray*,NSString*,NSString*,NSString*,NSArray*,NSArray*,NSArray*,Promotion *,NSDictionary*,int))finish
{
    if (cityid == -1) {
        NSArray *cityArray = [City getCityList];
        CityElem* city1 = [cityArray objectAtIndex:0];
        cityid = city1.cityId;
    }
    NSDictionary *requestParam = @{@"city_id":[NSNumber numberWithInteger:cityid]
                                   };
    NSLog(@" reqqqq %@",requestParam);
    [AppClient action:@"home_city_data_v6"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   
                   if (response.code != 0) {
                      
                       finish(response.code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,-1);
                   } else {
                       NSDictionary *dictAll;
                       NSLog(@"城市相关数据%@",response.data);
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               dictAll = response.data;
                               //中间banner
                               NSArray *arrayBanner = [dictAll objectForKey:@"mid_banner"];
                               NSMutableArray *bannerList = [[NSMutableArray alloc] init];
                               for (NSDictionary *bannerData in arrayBanner) {
                                   Banner *banner = [[Banner alloc] initWithBannerData:bannerData]; //强转URL ——————》(NSSTRING)
                                   [bannerList addObject:banner];
                               }
                               //顶部滑动门店
                               NSArray *sliderArray = [dictAll objectForKey:@"top_slider"];
                               NSMutableArray *sliderList = [[NSMutableArray alloc] init];
                               for (NSDictionary *sliderData in sliderArray) {
                                   Banner *banner = [[Banner alloc] initWithTopSliderData:sliderData]; //强转URL ——————》(NSSTRING)
                                   [sliderList addObject:banner];
                               }
                               //直播数据
                               NSDictionary *zhiboDict = [dictAll objectForKey:@"zhibo_btn"];
                               
                               //城市数据
                               NSArray *cityData = [dictAll objectForKey:@"all_city"];
                        
                               [City delettable];
                               NSArray *cityDatas = cityData;
                               NSInteger sort = 0;
                               NSMutableArray *cityList = [[NSMutableArray alloc] init];
                               for (NSDictionary *cityInfo in cityDatas) {
                                   CityElem *elem = [[CityElem alloc] init];
                                   elem.cityId = [(NSNumber *)[cityInfo objectForKey:@"city_id"] integerValue];
                                   elem.cityName = (NSString *)[cityInfo objectForKey:@"city_name"];
                                   elem.firstLetter = (NSString *)[cityInfo objectForKey:@"first_char"];
                                   elem.domain = (NSString *)[cityInfo objectForKey:@"domain"];
                                   elem.createTime = sort;
                                   [City addCityInfo:elem];
                                   [cityList addObject:elem];
                                   sort ++;
                               }
                               //买家分享
                               //首页头条模块
                               NSArray *postsData = [dictAll objectForKey:@"btm_posts"];
                               NSMutableArray *forumArray = [[NSMutableArray alloc]init];
                               for (NSDictionary *data in postsData) {
                                   ForumModel * forum = [[ForumModel alloc]initWithForumData:data];
                                   [forumArray addObject:forum];
                               }

                               //运营
                               Promotion *Promote;
                               
                               NSArray *arrayPop = [dictAll objectForKey:@"pop_images"];
                               if (arrayPop.count!=0) {
                                   NSDictionary *promoteData = [arrayPop HCObjectAtIndex:0];
                                   Promote = [[Promotion alloc] initWithPromotionDic:promoteData ];
                               }
                               //选车车系  数组变字典
                              
                               NSArray *arrayBrand  = [dictAll objectForKey:@"brand_list"];
                               NSMutableArray *brandArr = [[NSMutableArray alloc]init];
                               for (NSDictionary  *data in arrayBrand) {
                                   if ([data objectForKey:@"brand_id"]) {
                                       BrandSeriesCond *cond = [[BrandSeriesCond alloc]init];
                                       cond.brandId = [[data objectForKey:@"brand_id"] integerValue];
                                       cond.brandName = [data objectForKey:@"brand_name"];
                                       [brandArr addObject:cond];
                                   }else{
                                       Activity *activity  = [[Activity alloc]initWithActivityDic:data];
                                       [brandArr addObject:activity];
                                   }
                               }
                               int has_zhiyingdian =  [[dictAll objectForKey:@"has_zhiyingdian"]intValue];
                               //今日上新数量
                               NSString * today_count = [dictAll objectForKey:@"today_count"];
                               //问题车辆
                               NSString *accident_check_count = [dictAll objectForKey:@"accident_check_count"];
                               //城市车辆
                               NSString *vehicle_count = [dictAll objectForKey:@"vehicle_count"];
                               //批量添加
                              // [Banner batchUpdateBannerList:bannerList forCity:city]

                               finish(response.code,cityList,brandArr,vehicle_count,today_count,accident_check_count,sliderList,bannerList,forumArray,Promote,zhiboDict,has_zhiyingdian);
                               }
                       } @catch (NSException *exception) {
                               finish(response.code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,-1);

                       } @finally {

                       }
                   }
            }
     ];
}

+(void)getHomeCityData:(CGFloat )lat lng:(CGFloat)lng finish:(RequestFinish)finish;{
    NSDictionary *requestParam = @{@"uuid":[HCUUID getHCUUID],
                                   @"lng":[NSNumber numberWithFloat:lng],
                                   @"lat":[NSNumber numberWithFloat:lat]
                                   };
    [AppClient action:@"home_data_v8"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   
                   if (response.code != 0) {
                       
                       finish(NO,nil);
                   } else {
                       NSDictionary *dictAll;
                       NSLog(@"城市相关数据%@",response.data);
                       if ([response.data isKindOfClass:[NSDictionary class]]) {
                           dictAll = response.data;
                           finish(YES, dictAll);
                       }else{
                           finish(NO, nil);
                       }
//                       @try {
//                           if ([response.data isKindOfClass:[NSDictionary class]]) {
//                               dictAll = response.data;
//                               //中间banner
//                               NSArray *arrayBanner = [dictAll objectForKey:@"mid_banner"];
//                               NSMutableArray *bannerList = [[NSMutableArray alloc] init];
//                               for (NSDictionary *bannerData in arrayBanner) {
//                                   Banner *banner = [[Banner alloc] initWithBannerData:bannerData]; //强转URL ——————》(NSSTRING)
//                                   [bannerList addObject:banner];
//                               }
//                               //顶部滑动门店
//                               NSArray *sliderArray = [dictAll objectForKey:@"top_slider"];
//                               NSMutableArray *sliderList = [[NSMutableArray alloc] init];
//                               for (NSDictionary *sliderData in sliderArray) {
//                                   Banner *banner = [[Banner alloc] initWithTopSliderData:sliderData]; //强转URL ——————》(NSSTRING)
//                                   [sliderList addObject:banner];
//                               }
//                               //直播数据
//                               NSDictionary *zhiboDict = [dictAll objectForKey:@"zhibo_btn"];
//                               
//                               //城市数据
//                               NSArray *cityData = [dictAll objectForKey:@"all_city"];
//                               
//                               [City delettable];
//                               NSArray *cityDatas = cityData;
//                               NSInteger sort = 0;
//                               NSMutableArray *cityList = [[NSMutableArray alloc] init];
//                               for (NSDictionary *cityInfo in cityDatas) {
//                                   CityElem *elem = [[CityElem alloc] init];
//                                   elem.cityId = [(NSNumber *)[cityInfo objectForKey:@"city_id"] integerValue];
//                                   elem.cityName = (NSString *)[cityInfo objectForKey:@"city_name"];
//                                   elem.firstLetter = (NSString *)[cityInfo objectForKey:@"first_char"];
//                                   elem.domain = (NSString *)[cityInfo objectForKey:@"domain"];
//                                   elem.createTime = sort;
//                                   [City addCityInfo:elem];
//                                   [cityList addObject:elem];
//                                   sort ++;
//                               }
//                               //买家分享
//                               //首页头条模块
//                               NSArray *postsData = [dictAll objectForKey:@"btm_posts"];
//                               NSMutableArray *forumArray = [[NSMutableArray alloc]init];
//                               for (NSDictionary *data in postsData) {
//                                   ForumModel * forum = [[ForumModel alloc]initWithForumData:data];
//                                   [forumArray addObject:forum];
//                               }
//                               
//                               //运营
//                               Promotion *Promote;
//                               
//                               NSArray *arrayPop = [dictAll objectForKey:@"pop_images"];
//                               if (arrayPop.count!=0) {
//                                   NSDictionary *promoteData = [arrayPop HCObjectAtIndex:0];
//                                   Promote = [[Promotion alloc] initWithPromotionDic:promoteData ];
//                               }
//                               //选车车系  数组变字典
//                               
//                               NSArray *arrayBrand  = [dictAll objectForKey:@"brand_list"];
//                               NSMutableArray *brandArr = [[NSMutableArray alloc]init];
//                               for (NSDictionary  *data in arrayBrand) {
//                                   if ([data objectForKey:@"brand_id"]) {
//                                       BrandSeriesCond *cond = [[BrandSeriesCond alloc]init];
//                                       cond.brandId = [[data objectForKey:@"brand_id"] integerValue];
//                                       cond.brandName = [data objectForKey:@"brand_name"];
//                                       [brandArr addObject:cond];
//                                   }else{
//                                       Activity *activity  = [[Activity alloc]initWithActivityDic:data];
//                                       [brandArr addObject:activity];
//                                   }
//                               }
//                               int has_zhiyingdian =  [[dictAll objectForKey:@"has_zhiyingdian"]intValue];
//                               //今日上新数量
//                               NSString * today_count = [dictAll objectForKey:@"today_count"];
//                               //问题车辆
//                               NSString *accident_check_count = [dictAll objectForKey:@"accident_check_count"];
//                               //城市车辆
//                               NSString *vehicle_count = [dictAll objectForKey:@"vehicle_count"];
//                               //批量添加
//                               // [Banner batchUpdateBannerList:bannerList forCity:city]
//                               
//                               finish(response.code,cityList,brandArr,vehicle_count,today_count,accident_check_count,sliderList,bannerList,forumArray,Promote,zhiboDict,has_zhiyingdian);
//                           }
//                       } @catch (NSException *exception) {
//                           finish(response.code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,-1);
//                           
//                       } @finally {
//                           
//                       }
                   }
               }
     ];
}

+ (void)gethome_other_databyfinish:(void(^)(NSArray*,NSDictionary *,NSDictionary *,NSArray *,NSArray *,NSArray *,NSMutableArray*,NSInteger))finish
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *requestParam = @{@"version":app_Version};
    [AppClient action:@"home_other_data_v4"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finish(nil,nil,nil,nil,nil,nil,nil,response.code );
                   } else {
                       @try {
                           NSDictionary *dictAll;
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               dictAll = response.data;
                               if (dictAll != nil) {
                                   //评论模块
                                  
                                  // NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"comment", [[NSDictionary alloc]init],nil];
                                    NSArray *arrayComment = [dictAll objectForKey:@"comment"];
                                   NSMutableArray *array = [[NSMutableArray alloc]init];
                                   for (NSDictionary *data in arrayComment){
                                       HomePromoteModel *banner = [[HomePromoteModel alloc] initWithData:data and:NO];
                                       [array addObject:banner];
                                   }
                                   //登陆模块
                                   NSDictionary *login = [dictAll objectForKey:@"login"];
                                   //首页topimage
                                  // NSMutableDictionary *diii = [[NSMutableDictionary alloc]init];
                                   //[diii setObject:[[NSArray alloc]init] forKey:@"check"];
                                   NSDictionary *check = [dictAll objectForKey:@"check"];
                                   
                                   //城市数据
                                   NSArray *cityData = [dictAll objectForKey:@"support_city"];
                                   [City delettable];
                                   NSArray *cityDatas = cityData;
                                   NSInteger sort = 0;
                                   NSMutableArray *cityList = [[NSMutableArray alloc] init];
                                   for (NSDictionary *cityInfo in cityDatas) {
                                       CityElem *elem = [[CityElem alloc] init];
                                       elem.cityId = [(NSNumber *)[cityInfo objectForKey:@"city_id"] integerValue];
                                       elem.cityName = (NSString *)[cityInfo objectForKey:@"city_name"];
                                       elem.firstLetter = (NSString *)[cityInfo objectForKey:@"first_char"];
                                       elem.domain = (NSString *)[cityInfo objectForKey:@"domain"];
                                       elem.createTime = sort;
                                       [City addCityInfo:elem];
                                       [cityList addObject:elem];
                                       sort ++;
                                   }
                                   //首页价格数据
                                   // NSArray *versionCheck  =[dictAll objectForKey:@"version"];
                                   NSMutableArray *priceCondArray = [[NSMutableArray alloc]init];
                                   NSArray *priceData = [dictAll objectForKey:@"price"];
                                 //  priceData = [[NSArray alloc]init];
                                 //  NSString *str= nil;
                                  // NSDictionary *doct = @{@"ceshishuju":str};
                                   for (NSDictionary *priceDic in priceData) {
                                       PriceCond *cond = [[PriceCond alloc]init];
                                       NSArray *condArray =[priceDic objectForKey:@"range"];
                                       if (condArray.count>1) {
                                           [cond setPriceFrom:[[condArray HCObjectAtIndex:0]integerValue]];
                                           [cond setPriceTo:[[condArray HCObjectAtIndex:1]integerValue]];
                                           [cond setDesc:[priceDic objectForKey:@"title"]];
                                           [priceCondArray addObject:cond];
                                       }
                                   }
                                   //首页头条模块
                                   NSArray *forumData = [dictAll objectForKey:@"forum"];
                                   NSMutableArray *forumArray = [[NSMutableArray alloc]init];
                                   for (NSDictionary *data in forumData) {
                                       ForumModel * forum = [[ForumModel alloc]initWithForumData:data];
                                       [forumArray addObject:forum];
                                   }
                                   
                                   
                                   finish(array,login,check,nil,cityList,priceCondArray,forumArray,response.code );
                                   
                               }
                           }
                       } @catch (NSException *exception) {
                             finish(nil,nil,nil,nil,nil,nil,nil,response.code );
                       } @finally {
                           
                       }
                   }
               }
     ];
}


//+ (void)getHome_todayNew_vehiclepage:(NSInteger )page back:(void (^)(NSInteger, NSArray*,NSString *,NSString *))finish{
//   
//    NSDictionary *requestParam = @{
//                                   @"page_size":@5,
//                                   @"page_num":[NSNumber numberWithInteger:page],
//                                   @"city_id":[NSNumber numberWithInteger:[BizCity getCurCity].cityId]
//                                   };
//    NSString *actionName = @"home_today_vehicle";
//    [AppClient action:actionName
//           withParams:requestParam
//               finish:^(HttpResponse* response){
//    
//                   if (response.code != 0) {
//                       finish(-1,nil,0,0);
//                   }else{
//                       if ([response.data isKindOfClass:[NSDictionary class]]) {
//                           NSString * vehicle_count = [response.data objectForKey:@"vehicle_count"];
//                           NSArray* vehicleDatas = [response.data objectForKey:@"vehicle_list"];
//                           NSString *updata_time = [response.data objectForKey:@"update_time"];
//                           
//                           NSMutableArray *vehicleList = [[NSMutableArray alloc] init];
//                           for (NSDictionary* vehicleDic in vehicleDatas) {
//                               Vehicle*  vehicle = [[Vehicle alloc] initWithVehicleData:vehicleDic];
//                               [vehicleList addObject:vehicle];
//                           }
//                           finish(0, vehicleList,vehicle_count,updata_time);
//                       }
//                       
//                   }
//               }
//     ];
//}









@end
