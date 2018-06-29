//
//  DataFilter.m
//  HCBuyerApp
//
//  Created by wj on 14-10-21.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "DataFilter.h"
#import "AutoSeries.h"
#import "BrandSeries.h"
#import "NSDate+ITTAdditions.h"
#import "BizCity.h"
@interface DataFilter()

@end


@implementation SortCond

-(instancetype)initByType:(SortType)type desc:(NSString *)sortDesc
{
    if (self=[super init]) {
        self.sortDesc = sortDesc;
        self.sortType = type;
    }
    return self;
}

-(BOOL)isValid
{
    return (self.sortType != SortTypeDefault);
}

+(NSArray *)getSortCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[SortCond alloc] initByType:SortTypeDefault desc:@"综合排序"]];
    [data addObject:[[SortCond alloc] initByType:SortTypePriceAsc desc:@"价格低到高"]];
    [data addObject:[[SortCond alloc] initByType:SortTypePriceDsc desc:@"价格高到低"]];
    [data addObject:[[SortCond alloc] initByType:SortTypeAgeAsc desc:@"车龄新到旧"]];
    [data addObject:[[SortCond alloc] initByType:SortTypeMilesAsc desc:@"里程短到长"]];
    return data;
}

@end

@implementation BrandSeriesCond

-(instancetype)initByBrand:(NSInteger)brandId brandName:(NSString *)brandName
                    series:(NSInteger)seriesId seriesName:(NSString *)seriesName
{
    if (self = [super init]) {
        self.brandId = -1;
        self.seriesId = -1;
        self.brandName = @"";
        self.seriesName = @"";
    }
    return self;
}

-(BOOL)isValid
{
    return  (self.brandId != -1);
}

@end


@implementation PriceCond

-(instancetype)initByPriceFrom:(CGFloat)from to:(CGFloat)to desc:(NSString *)desc
{
    if (self = [super init]) {
        self.priceFrom = from;
        self.priceTo = to;
        self.desc = desc;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.priceFrom == -1 && self.priceTo == -1);
}

+(NSArray *)getPriceCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
        [data addObject:[[PriceCond alloc] initByPriceFrom:-1 to:-1 desc:@"不限"]];//查看全部
        [data addObject:[[PriceCond alloc] initByPriceFrom:0 to:2 desc:@"2万以内"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:2 to:3 desc:@"2-3万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:3 to:5 desc:@"3-5万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:5 to:7 desc:@"5-7万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:7 to:9 desc:@"7-9万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:9 to:12 desc:@"9-12万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:12 to:15 desc:@"12-15万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:15 to:20 desc:@"15-20万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:20 to:30 desc:@"20-30万"]];
        [data addObject:[[PriceCond alloc] initByPriceFrom:30 to:1000 desc:@"30万以上"]];
    return data;
}



@end

@implementation AgeCond

-(instancetype)initByAgeFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc;
{
    if (self = [super init]) {
        self.yearFrom = from;
        self.yearTo = to;
        self.desc = desc;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.yearFrom == -1 && self.yearTo == -1);
}

+(NSArray *)getAgeCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[AgeCond alloc] initByAgeFrom:-1 to:-1 desc:@"不限"]];
    [data addObject:[[AgeCond alloc] initByAgeFrom:0 to:1 desc:@"1年内"]];
    [data addObject:[[AgeCond alloc] initByAgeFrom:0 to:3 desc:@"3年内"]];
    [data addObject:[[AgeCond alloc] initByAgeFrom:0 to:5 desc:@"5年内"]];
    [data addObject:[[AgeCond alloc] initByAgeFrom:0 to:8 desc:@"8年内"]];
    [data addObject:[[AgeCond alloc] initByAgeFrom:8 to:100 desc:@"8年以上"]];
    return data;
}

@end


@implementation GearboxCond

- (instancetype)initByType:(GearBoxType)type desc:(NSString *)desc
{
    if (self = [super init]) {
        self.type = type;
        self.desc = desc;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.type == GearBoxTypeNone);
}

+(NSArray *)getGearboxCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[GearboxCond alloc]initByType:GearBoxTypeNone desc:@"不限" ] ];
    [data addObject:[[GearboxCond alloc]initByType:GearBoxTypeManu desc:@"手动" ] ];
    [data addObject:[[GearboxCond alloc]initByType:GearBoxTypeAuto desc:@"自动" ] ];
    return data;
}

@end

@implementation EmissionCond

- (instancetype)initByEmissionFrom:(CGFloat)from to:(CGFloat)to desc:(NSString *)desc
{
    if (self = [super init]) {
        self.desc = desc;
        self.from = from;
        self.to = to;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.from == -1 && self.to == -1);
}

+ (NSArray *)getEmissionCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:-1 to:-1 desc:@"不限"]];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:0 to:1.2f desc:@"1.2升以下"]];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:1.3f to:1.6f desc:@"1.3~1.6升"]];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:1.7f to:2.0f desc:@"1.7~2.0升"]];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:2.1f to:3.0f desc:@"2.1~3.0升"]];
    [data addObject:[[EmissionCond alloc] initByEmissionFrom:4.1f to:100.0f desc:@"4.1升以上"]];
    return data;
}

@end

@implementation MilesCond

-(instancetype)initByMilesFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc
{
    if (self = [super init]) {
        self.from = from;
        self.to = to;
        self.desc = desc;
    }
    return  self;
}

-(BOOL)isValid
{
    return !(self.from == -1 && self.to == -1);
}

+(NSArray *)getMilesCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[MilesCond alloc] initByMilesFrom:-1 to:-1 desc:@"不限"] ];
    [data addObject:[[MilesCond alloc] initByMilesFrom:0 to:3 desc:@"3万公里内"] ];
    [data addObject:[[MilesCond alloc] initByMilesFrom:0 to:5 desc:@"5万公里内"] ];
    [data addObject:[[MilesCond alloc] initByMilesFrom:0 to:8 desc:@"8万公里内"] ];
    [data addObject:[[MilesCond alloc] initByMilesFrom:0 to:10 desc:@"10万公里内"] ];
    [data addObject:[[MilesCond alloc] initByMilesFrom:8 to:100 desc:@"10万公里以上"] ];
    return data;
}

@end

@implementation StructureCond

-(instancetype)initByType:(StructType)type desc:(NSString *)desc image:(NSString *)imageName
{
    if (self = [super init]) {
        self.type = type;
        self.desc = desc;
        self.imageName = imageName;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.type == StructTypeNone);
}

+(NSArray *)getSturctureCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[StructureCond alloc] initByType:StructTypeNone desc:@"不限" image:@""] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeTwo desc:@"两厢" image:@"liangxiang"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeThree desc:@"三厢" image:@"sanxiang"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeSUV desc:@"SUV" image:@"SUV"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeMPV desc:@"MPV" image:@"MPV"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeTravel desc:@"旅行车" image:@"lvxingche"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeRace desc:@"跑车" image:@"paoche"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypePika desc:@"皮卡" image:@"pika"] ];
    [data addObject:[[StructureCond alloc] initByType:StructTypeVan desc:@"面包车" image:@"mianbaoche"] ];
    return data;
}

@end

@implementation EmissionStandarCond

- (instancetype)initByESFrom:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc
{
    if (self = [super init]) {
        self.from = from;
        self.to = to;
        self.desc = desc;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.from == -1 && self.to == -1);
}

+(NSArray *)getEmissionStandarCondData
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[EmissionStandarCond alloc] initByESFrom:-1 to:-1 desc:@"不限"] ];
    [data addObject:[[EmissionStandarCond alloc] initByESFrom:1 to:100 desc:@"国三及以上"] ];
    [data addObject:[[EmissionStandarCond alloc] initByESFrom:2 to:100 desc:@"国四及以上"] ];
    [data addObject:[[EmissionStandarCond alloc] initByESFrom:3 to:3 desc:@"国五"] ];
    return data;
}

@end
@implementation ColorCond
-(instancetype)initDesc:(NSString *)desc imageName:(NSString*)imageName
{
    if (self = [super init]) {
        self.desc = desc;
        self.imageName = imageName;
    }
    return self;
}

+(NSArray *)getColorCondData{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[ColorCond alloc]initDesc:nil imageName:nil]];
    [data addObject:[[ColorCond alloc]initDesc:@"黑色" imageName:@"heise"]];
    [data addObject:[[ColorCond alloc]initDesc:@"白色" imageName:@"baise"]];
    [data addObject:[[ColorCond alloc] initDesc:@"银灰色" imageName:@"yinhuise"]];
    [data addObject:[[ColorCond alloc] initDesc:@"深灰色" imageName:@"shenhuise"]];
    [data addObject:[[ColorCond alloc] initDesc:@"红色" imageName:@"hongse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"蓝色" imageName:@"lanse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"绿色" imageName:@"lvse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"黄色" imageName:@"huangse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"金色" imageName:@"jinse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"橙色" imageName:@"chengse"]];
    [data addObject:[[ColorCond alloc] initDesc:@"其他" imageName:@"qita"]];
    return data;
}
-(BOOL)isValid
{
    return !(self.desc==nil);
}
@end

@implementation PatternCond

- (instancetype)initPatternCond:(NSInteger)from to:(NSInteger)to desc:(NSString *)desc{
    if (self = [super init]) {
        self.from = from;
        self.to = to;
       //self.desc = desc;
    }
    return self;
}

-(BOOL)isValid
{
    return !(self.from == -1 && self.to == -1);
}

@end

@implementation CountryCond
-(instancetype)initCountryCond:(NSString *)desc imageName:(NSString *)imageName
{
    if (self = [super init]) {
        self.desc = desc;
        self.imageName = imageName;
    }
    return self;
}

+(NSArray *)getCountryCondData{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:[[CountryCond alloc]initCountryCond:nil imageName:nil]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"德系" imageName:@"dexi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"日系" imageName:@"rixi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"韩系" imageName:@"hanxi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"美系" imageName:@"meixi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"法系" imageName:@"faxi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"国产" imageName:@"guochan"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"合资" imageName:@"hezi"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"进口" imageName:@"jinkou"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"非国产" imageName:@"feiguochan"]];
    [data addObject:[[CountryCond alloc]initCountryCond:@"非日系" imageName:@"feirixi"]];
    return data;
}

+ (NSString*)getDescByPInyin:(NSString*)str{
    NSArray *arr = [CountryCond getCountryCondData];
    for (CountryCond *cond in arr) {
        if ([cond.imageName isEqualToString:str]) {
            return cond.desc;
        }
    }
    return @"";
}
-(BOOL)isValid
{
    return !(self.desc==nil);
}
@end

@interface DataFilter()


@property (nonatomic) BOOL changed;
@end

@implementation DataFilter

- (BOOL)otherViewisValid{
    return
   
    (self.ageCond && [self.ageCond isValid]) ||
    (self.gearboxCond && [self.gearboxCond isValid]) ||
    (self.emissionCond && [self.emissionCond isValid]) ||
    (self.milesCond && [self.milesCond isValid]) ||
    (self.structureCond && [self.structureCond isValid]) ||
    (self.colorCond &&[self.colorCond isValid])||
    (self.countyrCond && [self.countyrCond isValid]) ||
    (self.emissionStandarCond && [self.emissionStandarCond isValid]);
}

-(BOOL)isValid
{
    return
            (self.sortCond&&[self.sortCond isValid])||
            (self.pattenCond &&[self.pattenCond isValid])||
            (self.colorCond &&[self.colorCond isValid])||
            (self.ageCond && [self.ageCond isValid]) ||
            (self.brandSeriesCond && [self.brandSeriesCond isValid]) ||
            (self.priceCond && [self.priceCond isValid]) ||
            (self.gearboxCond && [self.gearboxCond isValid]) ||
            (self.emissionCond && [self.emissionCond isValid]) ||
            (self.milesCond && [self.milesCond isValid]) ||
            (self.structureCond && [self.structureCond isValid]) ||
            (self.countyrCond && [self.countyrCond isValid]) ||
            (self.emissionStandarCond && [self.emissionStandarCond isValid])||
            self.searchString!=nil;
}

- (DataFilter *)cleanAllData{
    if ([self isValid]) {
        self.pattenCond.from = - 1;
        self.pattenCond.to = - 1;
        self.colorCond = [[ColorCond alloc]initDesc:nil imageName:nil];
        self.priceCond = [[PriceCond getPriceCondData]HCObjectAtIndex:0];
        self.countyrCond = [[CountryCond getCountryCondData]objectAtIndex:0];
        self.brandSeriesCond.brandId = -1;
        self.ageCond = [[AgeCond getAgeCondData]HCObjectAtIndex:0];
        self.emissionCond = [[EmissionCond getEmissionCondData]HCObjectAtIndex:0];
        self.structureCond = [[StructureCond getSturctureCondData]HCObjectAtIndex:0];
        self.emissionStandarCond = [[EmissionStandarCond getEmissionStandarCondData]HCObjectAtIndex:0];
        self.gearboxCond = [[GearboxCond getGearboxCondData]HCObjectAtIndex:0];
        self.milesCond = [[MilesCond getMilesCondData]HCObjectAtIndex:0];

    }
    return self;
}

#pragma mark 刷新控件
- (NSMutableDictionary*)setSortType
{
    NSMutableDictionary *sortDic = [[NSMutableDictionary alloc]init];
    if (self.sortCond ==nil || self.sortCond.sortType==SortTypeDefault)
    {
        [sortDic setObject:@1 forKey:@"desc"];
        [sortDic setObject:@"refresh_time" forKey:@"order_by"];
    }
    if (self.sortCond && [self.sortCond isValid])
    {
        switch (self.sortCond.sortType)
        {
            case SortTypeAgeAsc:
                [sortDic setObject:@1 forKey:@"desc"];
                [sortDic setObject:@"register_time" forKey:@"order_by"];
                break;
            case SortTypeMilesAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"miles" forKey:@"order_by"];
                break;
            case SortTypePriceAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"seller_price" forKey:@"order_by"];
                break;
            default:
                break;
        }
    }
    return sortDic;
}
- (DataFilter*)removeQueryCond:(id)cond withdatafile:(DataFilter*)datafilter{
    
        if ([cond isKindOfClass:[NSString class]]) {
            datafilter.searchString = nil;
            datafilter.city = [[CityElem alloc]init];
            datafilter.city.cityId = [BizCity getCurCity].cityId;
        }
        if ([cond isKindOfClass:[BrandSeriesCond class]]) {
            datafilter.brandSeriesCond.brandId=-1;
            datafilter.brandSeriesCond.seriesId=-1;
            datafilter.brandSeriesCond.brandName= @"";
            datafilter.brandSeriesCond.seriesName = @"";
        }
    
        if ([cond isKindOfClass:[PriceCond class]]) {
            datafilter.priceCond = [[PriceCond getPriceCondData]objectAtIndex:0];
        }
        if ([cond isKindOfClass:[AgeCond class]]) {
            datafilter.ageCond = [[AgeCond getAgeCondData]objectAtIndex:0];
        }
        if ([cond isKindOfClass:[GearboxCond class]]) {
            datafilter.gearboxCond = [[GearboxCond alloc]initByType:GearBoxTypeNone desc:@"不限" ];
        }
        if ([cond isKindOfClass:[EmissionCond class]]) {
            datafilter.emissionCond = [[EmissionCond alloc] initByEmissionFrom:-1 to:-1 desc:@"不限"];
        }
        if ([cond isKindOfClass:[MilesCond class]]) {
            datafilter.milesCond = [[MilesCond alloc] initByMilesFrom:-1 to:-1 desc:@"不限"] ;
        }
        if ([cond isKindOfClass:[StructureCond class]]) {
            datafilter.structureCond = [[StructureCond alloc] initByType:StructTypeNone desc:@"不限" image:@""];
        }
        if ([cond isKindOfClass:[EmissionStandarCond class]]) {
            datafilter.emissionStandarCond = [[EmissionStandarCond alloc] initByESFrom:-1 to:-1 desc:@"不限"];
        }
        if ([cond isKindOfClass:[ColorCond class]]) {
            datafilter.colorCond = [[ColorCond alloc]initDesc:nil imageName:nil];
        }
        if ([cond isKindOfClass:[CountryCond class]]) {
            datafilter.countyrCond = [[CountryCond getCountryCondData]objectAtIndex:0];
        }
        if ([cond isKindOfClass:[PatternCond class]]) {
            datafilter.pattenCond =[[PatternCond alloc]initPatternCond:-1 to:-1 desc:@""];
        }
    
    return datafilter;
}
- (NSString *)getCondeDescString{
    if ([self isValid]) {
       NSMutableArray *titleArr = [[NSMutableArray alloc]init];
    if ([self.brandSeriesCond isValid]) {
        NSString*brandName = [self getBrandNameFrom:self.brandSeriesCond.brandId];
        NSString*serieName = [AutoSeries getSeriesNamesByseries_id:self.brandSeriesCond.seriesId];
        if (serieName) {
            [titleArr addObject: [NSString stringWithFormat:@"%@·%@",brandName,serieName]];
        }else{
            [titleArr addObject:brandName];
        }
    }
    if ([self.priceCond isValid]) {
        [titleArr addObject:self.priceCond.desc];
    }
    if ([self.emissionStandarCond isValid]) {
        [titleArr addObject:self.emissionStandarCond.desc];
    }
    if ([self.structureCond isValid]) {
        [titleArr addObject:self.structureCond.desc];
    }
    if ([self.ageCond isValid]) {
        [titleArr addObject:self.ageCond.desc];
    }
    if ([self.gearboxCond isValid]) {
        [titleArr addObject:self.gearboxCond.desc];
    }
    if ([self.emissionCond isValid]) {
        [titleArr addObject:self.emissionCond.desc];
    }
    
    if ([self.milesCond isValid]) {
        [titleArr addObject:self.milesCond.desc];
    }
    if ([self.colorCond isValid]) {
        [titleArr addObject:self.colorCond.desc];
    }
    if ([self.pattenCond isValid]) {
        [titleArr addObject:self.pattenCond.desc];
    }
    if ([self.countyrCond isValid]) {
        [titleArr addObject:self.countyrCond.desc];
    }
        return [titleArr componentsJoinedByString:@","];
    }
    return @"";
}
- (NSArray *)getCondDescArray{
    [self getFilterRequestParam:1];
    if ([self isValid]) {
        NSMutableArray *titleArr = [[NSMutableArray alloc]init];
        if ([self.brandSeriesCond isValid]) {
            [titleArr addObject:self.brandSeriesCond];
        }
        if ([self.priceCond isValid]) {
            [titleArr addObject:self.priceCond];
        }
        if ([self.emissionStandarCond isValid]) {
            [titleArr addObject:self.emissionStandarCond];
        }
        if ([self.structureCond isValid]) {
            [titleArr addObject:self.structureCond];
        }
        if ([self.ageCond isValid]) {
            [titleArr addObject:self.ageCond];
        }
        if ([self.gearboxCond isValid]) {
            [titleArr addObject:self.gearboxCond];
        }
        if ([self.emissionCond isValid]) {
            [titleArr addObject:self.emissionCond];
        }
       
        if ([self.milesCond isValid]) {
            [titleArr addObject:self.milesCond];
        }
        if ([self.colorCond isValid]) {
            [titleArr addObject:self.colorCond];
        }
        if ([self.pattenCond isValid]) {
            [titleArr addObject:self.pattenCond];
        }
        if ([self.countyrCond isValid]) {
            [titleArr addObject:self.countyrCond];
        }
        if (self.searchString ) {
            [titleArr addObject:self.searchString];
        }
        
        return titleArr;
    }
    return nil;
}
- (void)setCondValuesByData:(NSDictionary*)dict{
    if ([dict objectForKey:@"city"]) {
        self.city = [[CityElem alloc]init];
        self.city.cityId = [[dict objectForKey:@"city"]integerValue];
    }
    if ([dict objectForKey:@"brand_id"]) {
        NSInteger branid = [[dict objectForKey:@"brand_id"]integerValue];
        self.brandSeriesCond = [[BrandSeriesCond alloc]init];
        self.brandSeriesCond.brandId = branid;
        self.brandSeriesCond.brandName =[self getBrandNameFrom:branid];
        if ([dict objectForKey:@"class_id"]) {
            NSInteger classid = [[dict objectForKey:@"class_id"]integerValue];
            self.brandSeriesCond.seriesId = classid;
            self.brandSeriesCond.seriesName = [AutoSeries getSeriesNamesByseries_id:classid];
        }else{
            self.brandSeriesCond.seriesId = -1;
            self.brandSeriesCond.seriesName = @"";
        }
    }
    if ([dict objectForKey:@"price"]) {
        NSArray *priceArr = [dict objectForKey:@"price"];
        self.priceCond = [[PriceCond alloc]init];
        self.priceCond.priceFrom = [[priceArr objectAtIndex:0]integerValue];
        self.priceCond.priceTo = [[priceArr objectAtIndex:1]integerValue];
        if (self.priceCond.priceFrom==self.priceCond.priceTo) {
            self.priceCond.desc = [NSString stringWithFormat:@"%ld万",(long)self.priceCond.priceFrom];
        }else{
            if (self.priceCond.priceTo ==1000) {
                self.priceCond.desc = [NSString stringWithFormat:@"%ld万以上",(long)self.priceCond.priceFrom];
            }else if(self.priceCond.priceFrom == 0){
                self.priceCond.desc = [NSString stringWithFormat:@"%ld万以内",(long)self.priceCond.priceTo];
            }else{
                self.priceCond.desc = [NSString stringWithFormat:@"%ld-%ld万",(long)self.priceCond.priceFrom,(long)self.priceCond.priceTo];
            }
        }

    }
    if ([dict objectForKey:@"structure"]) {
        self.structureCond = [[StructureCond alloc]init];
        self.structureCond.type = [[dict objectForKey:@"structure"]integerValue];
        self.structureCond.desc =  [self getVehicleStruct:self.structureCond.type];
    }
    if ([dict objectForKey:@"gear"]) {
        NSArray *gear = [dict objectForKey:@"gear"];
        self.gearboxCond = [[GearboxCond alloc]init];
        self.gearboxCond.type = [[gear objectAtIndex:0]integerValue];
        self.gearboxCond.desc = [self getVehicleGearBox:self.gearboxCond.type];
    }
    if ([dict objectForKey:@"color"]) {
        self.colorCond = [[ColorCond alloc]init];
        self.colorCond.desc = [dict objectForKey:@"color"];
    }
    if ([dict objectForKey:@"es"]) {
        NSArray *es = [dict objectForKey:@"es"];
        self.emissionStandarCond = [[EmissionStandarCond alloc]init];
        self.emissionStandarCond.from = [[es objectAtIndex:0]integerValue];
        self.emissionStandarCond.to = [[es objectAtIndex:1]integerValue];
        self.emissionStandarCond.desc = [self getEmissionStandarCond:self.emissionStandarCond.from];
    }
    if ([dict objectForKey:@"emission"]) {
        NSArray *es = [dict objectForKey:@"emission"];
        self.emissionCond = [[EmissionCond alloc]init];
        self.emissionCond.from = [[es objectAtIndex:0]floatValue];
        self.emissionCond.to = [[es objectAtIndex:1]floatValue];
        if (self.emissionCond.from==self.emissionCond.to) {
            self.emissionCond.desc = [NSString stringWithFormat:@"%.1f升",self.emissionCond.from];
        }else{
            self.emissionCond.desc =[NSString stringWithFormat:@"%.1f-%.1f年",self.emissionCond.from,self.emissionCond.to];
        }
    }
    if ([dict objectForKey:@"register_time"]) {
        NSArray *year = [dict objectForKey:@"register_time"];
        NSInteger from = [[year objectAtIndex:0]integerValue];
        NSInteger to = [[year objectAtIndex:1]integerValue];
        self.ageCond = [[AgeCond alloc]init];
        self.ageCond.yearTo = [NSDate yearago:from];
        self.ageCond.yearFrom = [NSDate yearago:to];
        if (self.ageCond.yearFrom==self.ageCond.yearTo) {
            self.ageCond.desc = [NSString stringWithFormat:@"%ld年",(long)self.ageCond.yearFrom];
        }else{
            if (self.ageCond.yearTo ==100) {
                self.ageCond.desc = [NSString stringWithFormat:@"%ld年以上",(long)self.ageCond.yearFrom];
            }else if(self.ageCond.yearFrom == 0){
                self.ageCond.desc = [NSString stringWithFormat:@"%ld年以内",(long)self.ageCond.yearTo];
            }else{
                self.ageCond.desc = [NSString stringWithFormat:@"%ld-%ld年",(long)self.ageCond.yearFrom,(long)self.ageCond.yearTo];
            }
        }
    }
    
}
- (NSMutableDictionary *)getFilterRequestParams
{
   // NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    //添加排序条件
    if (self.sortCond && [self.sortCond isValid]) {
        switch (self.sortCond.sortType) {
            case SortTypeAgeAsc:
                [paramsDic setObject:@"1" forKey:@"age_order"];
                break;
            case SortTypeMilesAsc:
                [paramsDic setObject:@"-1" forKey:@"age_order"];
                break;
            case SortTypePriceAsc:
                [paramsDic setObject:@"-1" forKey:@"price_order"];
                break;
            default:
                break;
        }
    }
    //添加品牌车系
    if (self.brandSeriesCond && [self.brandSeriesCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithInteger:self.brandSeriesCond.brandId] forKey:@"brand_id"];
        if (self.brandSeriesCond.seriesId > 0) {
            [paramsDic setObject:[NSNumber numberWithInteger:self.brandSeriesCond.seriesId] forKey:@"series_id"];
        }
        
        //[dict setObject:[self addMark:[self getVehicleBrandAndClass:self.brandSeriesCond.brandId series:self.brandSeriesCond.seriesId]] forKey:@"vehicleName"];
    }
    //添加价格筛选
    if (self.priceCond && [self.priceCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithFloat:self.priceCond.priceFrom] forKey:@"low_price"];
        [paramsDic setObject:[NSNumber numberWithFloat:self.priceCond.priceTo] forKey:@"high_price"];
        // [dict setObject:[self addMark:[self getVehiclePrice:self.priceCond.priceFrom]] forKey:@"vehiclePrice"];
    }
    //添加车龄筛选
    if (self.ageCond && [self.ageCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithFloat:self.ageCond.yearFrom] forKey:@"from_year"];
        [paramsDic setObject:[NSNumber numberWithFloat:self.ageCond.yearTo] forKey:@"to_year"];
      //  [dict setObject:[self addMark:[self getVehicleYear:self.ageCond.yearFrom]] forKey:@"vehicleYear"];
        
    }
    
    //添加变速箱
    if (self.gearboxCond && [self.gearboxCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithFloat:self.gearboxCond.type] forKey:@"gearbox"];
       // [dict setObject:[self addMark:[self getVehicleGearBox:self.gearboxCond.type]] forKey:@"gearbox"];
    }
    //排量
    if (self.emissionCond && [self.emissionCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithFloat:self.emissionCond.from] forKey:@"from_emission"];
        [paramsDic setObject:[NSNumber numberWithFloat:self.emissionCond.to] forKey:@"to_emission"];
      //[dict setObject:[self addMark:[self getVehicleEmission:self.emissionCond.from]] forKey:@"emission"];
        
     //   [dict setObject:[self addMark:[NSString stringWithFormat:@"%d.0~%d.0升",(int)self.emissionCond.from,(int)self.emissionCond.to]] forKey:@"emission"];
    }
    //里程
    if (self.milesCond && [self.milesCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithInteger:self.milesCond.from] forKey:@"from_miles"];
        [paramsDic setObject:[NSNumber numberWithInteger:self.milesCond.to] forKey:@"to_miles"];
        //[dict setObject:[self addMark:[self getVehicleMiles:self.milesCond.from]] forKey:@"miles"];
    }
    //车身结构
    if (self.structureCond && [self.structureCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithFloat:self.structureCond.type] forKey:@"vehicle_structure"];
        //[dict setObject:[self addMark:[self getVehicleStruct:self.structureCond.type]] forKey:@"vehicle_struct"];
    }
    //排放标准
    if (self.emissionStandarCond && [self.emissionStandarCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithInteger:self.emissionStandarCond.from] forKey:@"femission_standard"];
        [paramsDic setObject:[NSNumber numberWithInteger:self.emissionStandarCond.to] forKey:@"temission_standard"];
        //[dict setObject:[self addMark:[self getEmissionStandarCond:self.emissionStandarCond.from]] forKey:@"standard"];
    }
    
    //国别
    if (self.countyrCond && [self.countyrCond isValid]) {
        [paramsDic setObject:self.countyrCond.imageName forKey:@"country"];
        //[dict setObject:[self addMark:[self getEmissionStandarCond:self.emissionStandarCond.from]] forKey:@"standard"];
    }
    //车身颜色
    if (self.colorCond && [self.colorCond isValid]) {
        [paramsDic setObject:self.colorCond.desc forKey:@"color"];
      
        //[dict setObject:[self addMark:[self getEmissionStandarCond:self.emissionStandarCond.from]] forKey:@"standard"];
    }
    return paramsDic;
}



- (NSMutableDictionary *)getFilterRequestParam:(NSInteger)type{
      NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
     NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    
    //添加车龄筛选
    if (self.ageCond && [self.ageCond isValid]) {
        NSInteger  yearFrom =[self changeAgeToTimestamp:self.ageCond.yearTo];
        NSInteger yearTo = [self changeAgeToTimestamp:self.ageCond.yearFrom];
        NSArray *year = [NSArray arrayWithObjects:[NSNumber numberWithInteger:yearFrom],[NSNumber numberWithInteger:yearTo], nil];
        [paramsDic setObject:year forKey:@"register_time"];
        if (self.ageCond.yearFrom==self.ageCond.yearTo) {
            self.ageCond.desc = [NSString stringWithFormat:@"%ld年",(long)self.ageCond.yearFrom];
        }else{
            if (self.ageCond.yearTo ==100) {
                self.ageCond.desc = [NSString stringWithFormat:@"%ld年以上",(long)self.ageCond.yearFrom];
            }else if(self.ageCond.yearFrom == 0){
                self.ageCond.desc = [NSString stringWithFormat:@"%ld年以内",(long)self.ageCond.yearTo];
            }else{
                self.ageCond.desc = [NSString stringWithFormat:@"%ld-%ld年",(long)self.ageCond.yearFrom,(long)self.ageCond.yearTo];
            }
        }
        if (self.ageCond.desc!=nil) {
          [dict setObject:self.ageCond.desc forKey:@"register_time"];  
        }
        
    }
    //添加品牌车系
    
    //2.8.1版本发生奔溃的地方已fix
    if (self.brandSeriesCond && [self.brandSeriesCond isValid]) {
        [paramsDic setObject:[NSNumber numberWithInteger:self.brandSeriesCond.brandId] forKey:@"brand_id"];
        if (self.brandSeriesCond.seriesId > 0) {
            [paramsDic setObject:[NSNumber numberWithInteger:self.brandSeriesCond.seriesId] forKey:@"class_id"];
        }
        [dict setObject:[self addMark:[self getVehicleBrandAndClass:self.brandSeriesCond.brandId series:self.brandSeriesCond.seriesId]] forKey:@"vehicleName"];
    }

    if (self.priceCond && [self.priceCond isValid]) {
       
        NSArray *priceArr = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.priceCond.priceFrom],[NSNumber numberWithFloat:self.priceCond.priceTo], nil];
        if (self.priceCond.priceFrom==self.priceCond.priceTo) {
            self.priceCond.desc = [NSString stringWithFormat:@"%ld万",(long)self.priceCond.priceFrom];
        }else{
            if (self.priceCond.priceTo ==1000) {
                self.priceCond.desc = [NSString stringWithFormat:@"%ld万以上",(long)self.priceCond.priceFrom];
            }else if(self.priceCond.priceFrom == 0){
                 self.priceCond.desc = [NSString stringWithFormat:@"%ld万以内",(long)self.priceCond.priceTo];
            }else{
                self.priceCond.desc = [NSString stringWithFormat:@"%ld-%ld万",(long)self.priceCond.priceFrom,(long)self.priceCond.priceTo];
            }
        }
        
        [paramsDic setObject:priceArr forKey:@"price"];
        [dict setObject:self.priceCond.desc forKey:@"price"]; //更改过
        
    }
    
    //添加变速箱
    if (self.gearboxCond && [self.gearboxCond isValid]) {
        NSArray *gear;
        if ([[NSNumber numberWithFloat:self.gearboxCond.type] intValue] == 2) {
            gear = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.gearboxCond.type],@"5", nil];
        }else{
            gear = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.gearboxCond.type],[NSNumber numberWithFloat:self.gearboxCond.type], nil];
        }
        [paramsDic setObject:gear forKey:@"gear"];
        [dict setObject:[self addMark:[self getVehicleGearBox:self.gearboxCond.type]] forKey:@"gear"];
    }
    //排量
    if (self.emissionCond && [self.emissionCond isValid]) {
        NSArray *emission = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.emissionCond.from],[NSNumber numberWithFloat:self.emissionCond.to], nil];
        [paramsDic setObject:emission forKey:@"emission"];
        [dict setObject:[self addMark:[self getVehicleEmission:self.emissionCond.from]] forKey:@"emission"];
        
        //   [dict setObject:[self addMark:[NSString stringWithFormat:@"%d.0~%d.0升",(int)self.emissionCond.from,(int)self.emissionCond.to]] forKey:@"emission"];
    }
    //里程
    if (self.milesCond && [self.milesCond isValid]) {
        NSArray *miles = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.milesCond.from],[NSNumber numberWithInteger:self.milesCond.to] , nil];
         [paramsDic setObject:miles forKey:@"miles"];
        if (self.milesCond.from==self.milesCond.to) {
            self.milesCond.desc = [NSString stringWithFormat:@"%ld万公里",(long)self.milesCond.from];
        }else{
            if (self.milesCond.to ==100) {
                self.milesCond.desc = [NSString stringWithFormat:@"%ld万公里以上",(long)self.milesCond.from];
            }else if(self.milesCond.from == 0){
                self.milesCond.desc = [NSString stringWithFormat:@"%ld万公里以内",(long)self.milesCond.to];
            }else{
                self.milesCond.desc = [NSString stringWithFormat:@"%ld-%ld万公里",(long)self.milesCond.from,(long)self.milesCond.to];
            }
        }

        [dict setObject: self.milesCond.desc  forKey:@"miles"];
    }
    //车身结构
    if (self.structureCond && [self.structureCond isValid]) {
       
        [paramsDic setObject:[NSNumber numberWithFloat:self.structureCond.type] forKey:@"structure"];
        [dict setObject:[self addMark:[self getVehicleStruct:self.structureCond.type]] forKey:@"structure"];//改过
    }
    //排放标准
    if (self.emissionStandarCond && [self.emissionStandarCond isValid]) {
        NSArray *es = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.emissionStandarCond.from],[NSNumber numberWithInteger:self.emissionStandarCond.to], nil];
        [paramsDic setObject:es forKey:@"es"];
       
        [dict setObject:[self addMark:[self getEmissionStandarCond:self.emissionStandarCond.from]] forKey:@"es"]; //改过
    }
    if (self.colorCond && [self.colorCond isValid]) {
        [paramsDic setObject:self.colorCond.desc forKey:@"color"];
        [dict setObject:self.colorCond.desc forKey:@"color"];
    }
    [paramsDic setObject:[NSNumber numberWithInteger:self.city.cityId] forKey:@"city"];
    [dict setObject:[NSNumber numberWithInteger:self.city.cityId] forKey:@"city"];
    if (self.pattenCond && [self.pattenCond isValid]) {
        NSArray *year = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.pattenCond.from],[NSNumber numberWithInteger:self.pattenCond.to], nil];
        [paramsDic setObject:year forKey:@"year"];
        
        if (self.pattenCond.to>self.pattenCond.from) {
            NSString *patt = [NSString stringWithFormat:@"%ld-%ld款",(long)self.pattenCond.from,(long)self.pattenCond.to];
            [dict setObject:patt forKey:@"year"];
        }else if(self.pattenCond.to==self.pattenCond.from){
             NSString *patt = [NSString stringWithFormat:@"%ld款",(long)self.pattenCond.from];
            [dict setObject:patt forKey:@"year"];
        }
    }
    if (self.countyrCond && [self.countyrCond isValid]) {
       // NSArray *year = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.pattenCond.from],[NSNumber numberWithInteger:self.pattenCond.to], nil];
        [paramsDic setObject:self.countyrCond.imageName forKey:@"country"];
        [dict setObject:self.countyrCond.desc  forKey:@"country"];
        
    }
    if (self.searchString) {
        [paramsDic setObject:self.searchString forKey:@"searchString"];
    }
  /*  if (type==1) {
        NSNotification *carInfo =[NSNotification notificationWithName:@"CarInformation" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:carInfo];
    }else if (type==3){
        NSNotification *carInfo =[NSNotification notificationWithName:@"LowCarInformation" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:carInfo];
    }*/
    return paramsDic;
}
- (NSInteger)changeAgeToTimestamp:(NSInteger)year{
    NSInteger  timestamp = [[NSString getnowMonthFirstDay:year]integerValue] ;
    
    return  timestamp;
}


- (NSString *)getVehicleMiles:(NSInteger)vehicleMiles{
    for (MilesCond *cond in [MilesCond getMilesCondData]) {
        if (cond.from == vehicleMiles) {
            return cond.desc;
        }
    }
    return nil;
}

- (NSString *)getVehicleEmission:(CGFloat)vehicleEmission{
    for (EmissionCond *cond in [EmissionCond getEmissionCondData]) {
        if (cond.from == vehicleEmission) {
            return cond.desc;
        }
    }
    return nil;
}

- (NSString *)getVehiclePrice:(NSInteger)vehiclePriceLow{
    for (PriceCond *cond in [PriceCond getPriceCondData]) {
        if (cond.priceFrom == vehiclePriceLow) {
            return cond.desc;
        }
    }
    return nil;
}
- (NSString*)getYearCondDesc:(NSInteger)vehicleYearTo{
    AgeCond *cond;
    cond = [[AgeCond getAgeCondData]HCObjectAtIndex:vehicleYearTo];
    return cond.desc;
    
}
- (NSString*)getVehicleYear:(NSInteger)vehicleYearLow{
    
    for (AgeCond *cond in [AgeCond getAgeCondData]) {
        if (cond.yearFrom == vehicleYearLow) {
            return cond.desc;
        }
    }
    return nil;
}

- (NSString *)getVehicleStruct:(NSInteger)structType{
    StructureCond*cond;
    cond =  [[StructureCond getSturctureCondData]HCObjectAtIndex:structType];
    
    return cond.desc;
}
- (NSString*)getVehicleGearBox:(NSInteger)gearType{
    GearboxCond *boxCond;
    boxCond= [[GearboxCond getGearboxCondData]HCObjectAtIndex:gearType];
    return boxCond.desc;
}


- (NSString*)getEmissionStandarCond:(NSInteger)emissionType{
    EmissionStandarCond *cond;
    cond = [[EmissionStandarCond getEmissionStandarCondData]HCObjectAtIndex:emissionType];
    
    return cond.desc;
}

- (NSString *)getVehicleBrandAndClass:(NSInteger)brand series:(NSInteger)series{
   
    NSString*brandName = [self getBrandNameFrom:brand];
    NSString*serieName = [AutoSeries getSeriesNamesByseries_id:series];
    if (serieName) {
        return [NSString stringWithFormat:@"%@·%@",brandName,serieName];
    }else{
        return brandName;
    }    
}
- (NSString *)getBrandNameFrom:(NSInteger)brand_id;
{
    NSString *strName;
    NSArray *arrr = [BrandSeries getBrandSeriesList:self.city.cityId];
    for (BrandSeries *seee in arrr) {
        if (seee.brandId == brand_id) {
            strName = seee.brandName;
            //NSLog(@"brand Name %@",seee.brandName);
        }
    }
    return strName;
}
- (NSString *)addMark:(NSString*)str{
    
    NSString *markStr = [NSString stringWithFormat:@"%@",str];
    return markStr;
}
@end
