//
//  DataFilter.h
//  HCBuyerApp
//
//  Created by wj on 14-10-21.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

typedef enum : NSUInteger {
    SortTypeDefault, //默认排序
    SortTypePriceAsc, ////
    SortTypePriceDsc,
    SortTypeAgeAsc, //
    SortTypeMilesAsc //
} SortType;

//排序条件
@interface SortCond : NSObject

-(instancetype)initByType:(SortType)type desc:(NSString *)sortDesc;

@property (nonatomic) SortType sortType;

@property (nonatomic, strong) NSString *sortDesc;

-(BOOL)isValid;

//获取排序条件的信息
+(NSArray *)getSortCondData;
@end


//品牌车系
@interface BrandSeriesCond : NSObject

-(instancetype)initByBrand:(NSInteger)brandId brandName:(NSString *)brandName
                    series:(NSInteger)seriesId seriesName:(NSString *)seriesName;

@property (nonatomic) NSInteger brandId;
@property (nonatomic) NSInteger seriesId;

@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *seriesName;

-(BOOL)isValid;

@end

//价格排序
@interface PriceCond : NSObject

-(instancetype)initByPriceFrom:(CGFloat)from to:(CGFloat)to desc:(NSString *)desc;

@property (nonatomic) NSInteger priceFrom;
@property (nonatomic) NSInteger priceTo;
@property (nonatomic, strong) NSString *desc;

-(BOOL)isValid;

+(NSArray *)getPriceCondData;

@end

//其他选项

@interface AgeCond : NSObject

-(instancetype)initByAgeFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic) NSInteger yearFrom;
@property (nonatomic) NSInteger yearTo;

-(BOOL)isValid;

+(NSArray *)getAgeCondData;

@end


//变速箱
typedef enum : NSUInteger {
    GearBoxTypeNone = 0, //不限
    GearBoxTypeManu = 1, //手动
    GearBoxTypeAuto = 2, //自动
} GearBoxType;

@interface GearboxCond : NSObject

-(instancetype)initByType:(GearBoxType)type desc:(NSString *)desc;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic) GearBoxType type;

-(BOOL)isValid;

+(NSArray *)getGearboxCondData;
@end

//排量
@interface EmissionCond : NSObject

-(instancetype)initByEmissionFrom:(CGFloat)from to:(CGFloat)to desc:(NSString *)desc;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) CGFloat from;
@property (nonatomic) CGFloat to;

-(BOOL)isValid;
+(NSArray *)getEmissionCondData;

@end

@interface MilesCond : NSObject

-(instancetype)initByMilesFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic) NSInteger from;
@property (nonatomic) NSInteger to;

-(BOOL)isValid;

+(NSArray *)getMilesCondData;
@end


//车身结构
typedef enum : NSUInteger {
    StructTypeNone = 0, //不限
    StructTypeTwo = 1, //两厢
    StructTypeThree = 2, //三厢
    StructTypeSUV = 3,//suv
    StructTypeMPV = 4, //mpv
    StructTypeTravel = 5, //旅行车
    StructTypeRace = 6,//跑车
    StructTypePika = 7, //皮卡
    StructTypeVan = 8,//面包车
} StructType;

@interface StructureCond : NSObject

-(instancetype)initByType:(StructType)type desc:(NSString *)desc image:(NSString*)imageName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) StructType type;

-(BOOL)isValid;

+(NSArray *)getSturctureCondData;
@end

//排放标准

@interface EmissionStandarCond : NSObject

-(instancetype)initByESFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic) NSInteger from;
@property (nonatomic) NSInteger to;

-(BOOL)isValid;

+(NSArray *)getEmissionStandarCondData;

@end
@interface ColorCond : NSObject
-(instancetype)initDesc:(NSString *)desc imageName:(NSString*)imageName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageName;
+(NSArray *)getColorCondData;
-(BOOL)isValid;
@end

@interface PatternCond : NSObject
-(instancetype)initPatternCond:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc;

@property (nonatomic, strong) NSString *desc;
@property (nonatomic) NSInteger from;
@property (nonatomic) NSInteger to;

@end

@interface CountryCond : NSObject
-(instancetype)initCountryCond:(NSString*)desc imageName:(NSString*)imageName;
+(NSArray *)getCountryCondData;
+ (NSString*)getDescByPInyin:(NSString*)str;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageName;
-(BOOL)isValid;
@end


@interface DataFilter : NSObject

//@property (nonatomic, readonly) BOOL isChanged;


- (NSMutableDictionary *)getFilterRequestParams;
- (NSMutableDictionary *)getFilterRequestParam:(NSInteger)type;

- (void)setCondValuesByData:(NSDictionary*)dict;


#pragma mark 刷新控件
//+ (NSMutableDictionary*)setSortType;
/* 
-(void) setSortCond:(SortCond *)sortCond;
-(void) setBrandSeriesCond:(BrandSeriesCond *)brandSeriesCond;
-(void) setPriceCond:(PriceCond *)priceCond;
-(void) setAgeCond:(AgeCond *)ageCond;
-(void) setGearboxCond:(GearboxCond *)gearboxCond;
-(void) setEmissionCond:(EmissionCond *)emissionCond;
-(void) setMilesCond:(MilesCond *)milesCond;
-(void) setStructureCond:(StructureCond *)structureCond;
-(void) setEmissionStandarCond:(EmissionStandarCond *)emissionStandarCond;
 */

@property (strong, nonatomic) SortCond *sortCond;
@property (strong, nonatomic) AgeCond *ageCond;
@property (strong, nonatomic) BrandSeriesCond *brandSeriesCond;
@property (strong, nonatomic) PriceCond *priceCond;
@property (strong, nonatomic) GearboxCond *gearboxCond;
@property (strong, nonatomic) EmissionCond *emissionCond;
@property (strong, nonatomic) MilesCond *milesCond;
@property (strong, nonatomic) StructureCond *structureCond;
@property (strong, nonatomic) EmissionStandarCond *emissionStandarCond;
@property (strong, nonatomic) CityElem *city;
@property (strong, nonatomic) ColorCond *colorCond;
@property (strong, nonatomic) PatternCond *pattenCond;
@property (strong, nonatomic) CountryCond *countyrCond;
@property (strong, nonatomic) NSString *searchString;
- (NSString *)getCondeDescString;
- (DataFilter*)removeQueryCond:(id)cond withdatafile:(DataFilter*)datafilter;
- (NSArray *)getCondDescArray;
- (BOOL)otherViewisValid;
-(BOOL)isValid;
- (DataFilter *)cleanAllData;
//-(DataFilter *)cleanPrice;
@end
