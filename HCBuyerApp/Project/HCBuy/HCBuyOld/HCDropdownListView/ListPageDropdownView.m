//
//  ListPageDropdownView.m
//  HCBuyerApp
//
//  Created by wj on 15/6/11.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ListPageDropdownView.h"
#import "UIImage+RTTint.h"
#import "HCDropdownListView.h"
#import "HCDropdownBrandSelectView.h"
#import "HCDropdownOtherSelectView.h"
#import "DataFilter.h"
#import "BizBrandSeries.h"
#import "HCDropdowListViewDataDelegate.h"
#import "BizCity.h"
#import "BizVehicleSource.h"
#import "FVCustomAlertView.h"
#import "HCDropSortListView.h"
//分段按钮的全局变量定义
#define HCSegmentedControl_Height 44.0
//#define HCSegmentedControl_Width ([UIScreen mainScreen].bounds.size.width)
#define Min_Width_4_Button 75.0
#define HCSegmentedControl_Width_Padding 0
#define HCSegmentedBottomLine_Padding 15.0f
#define Define_Tag_add 1000
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))
#define SECTION_IV_TAG_BEGIN    3000

#define HCSegment_BtnText_LeftPadding 35

#define HCSegmentSelectedColor [UIColor colorWithRed:0.87f green:0.00f blue:0.01f alpha:1.00f]


//下拉视图
#define HC_DROPDOWN_VIEW_TAG_BEGIN    4000

@interface ListPageDropdownView()<HCDropdowListViewDataDelegate,HCDropdownOtherSelectView>

@property (strong, nonatomic) UIView *superView;

//分段按钮
@property (strong, nonatomic) UIView *segmentControlView;
//@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) NSMutableArray *array4Btn;
@property (strong, nonatomic) NSArray *titles;

//下拉视图

@property (strong, nonatomic) HCDropdownListView *priceFilterView;
@property (strong, nonatomic) HCDropdownBrandSelectView *brandFilterView;
@property (strong, nonatomic) HCDropdownOtherSelectView *otherFilterView;
@property (strong, nonatomic) HCDropSortListView *sortFilterView;
//@property (strong, nonatomic) NSArray *orderData;
//@property (strong, nonatomic) NSArray *priceData;
//@property (strong, nonatomic) NSArray *brandSeriesData;
//@property (strong, nonatomic) NSArray *otherFilterData;
@property (nonatomic)NSInteger type;


@property (nonatomic) BOOL isCoverTabbar;
@end

@implementation ListPageDropdownView

- (id)initWithframe:(CGRect)frame forData:(DataFilter *)filter forSuperView:(UIView *)superView delegate:(id)delegate coverTabbar:(BOOL)coverTabbar suitable:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.superView = superView;
        self.delegate = delegate;
        self.dataFilter = filter;
        self.isCoverTabbar = coverTabbar;
        
        self.segmentViewMaxYPos = frame.origin.y;
        self.segmentViewHeight = HCSegmentedControl_Height;
        self.segmentViewMinYPos = frame.origin.y - self.segmentViewHeight;
        self.type = type;
        [self initSegmentControl];
        [self initDropdownView:type];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissDropdownView:) name:@"DismissDropdownView" object:nil];
    }
    return self;
}


- (void)initSegmentControl
{
//    self.titles = @[@"综合排序",@"品牌", @"价格", @"筛选"];
    self.titles = @[@"综合排序",@"品牌", @"价格"];
    self.segmentControlView = [[UIView alloc] initWithFrame:CGRectMake(HCSegmentedControl_Width_Padding, 0, self.frame.size.width, HCSegmentedControl_Height)];  //按钮添加到的View
   
    NSInteger btnCnt = [self.titles count];
    self.array4Btn = [[NSMutableArray alloc] initWithCapacity:btnCnt];
    CGFloat width4btn = self.segmentControlView.frame.size.width / btnCnt;
    if (width4btn < Min_Width_4_Button) {
        width4btn = Min_Width_4_Button;
    }
    for (NSInteger i = 0; i < btnCnt; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width4btn, 0.0f, width4btn, HCSegmentedControl_Height);
        [btn setTitleColor:UIColorFromRGBValue(0x9b9b9b) forState:UIControlStateNormal];
       // btn.backgroundColor = [UIColor cyanColor];
        if (HCSCREEN_WIDTH <= 320) {
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
        }else{
            btn.titleLabel.font = [UIFont systemFontOfSize:14]; 
        }
        [btn setTitle:[self.titles HCObjectAtIndex:i] forState:UIControlStateNormal];
        
        if(i==3){
            [btn setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
              
        }else{
            [btn setImage:[UIImage imageNamed:@"pulldown"] forState:UIControlStateNormal];
        }
            
//      
//        CGFloat imageLeft;
//        if (HCSCREEN_WIDTH>375) {
//          //  btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
//            imageLeft = btn.right-35;
//        }else{
//           // btn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
//            imageLeft = btn.right-30;
//            
//        }
        [btn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateSelected];
       
        
        [btn  horizontalCenterTitleAndImage];
        //btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = Define_Tag_add+i;
        [self.array4Btn addObject:btn];
        [self.segmentControlView addSubview:btn];
       
//        UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, btn.frame.origin.y + btn.frame.size.height / 2  - 1, 8, 4)];
//        if (i == 0) {
//            sectionBtnIv.frame = CGRectMake(imageLeft, btn.frame.origin.y +btn.frame.size.height/2, 8, 4);
//            [sectionBtnIv setImage:[[UIImage imageNamed:@"pulldown"] rt_tintedImageWithColor:UICOLOC]];
//        } else {
//            if(i==3){
//                sectionBtnIv.frame = CGRectMake(imageLeft-4, (btn.frame.size.height-3.5)/2, 11, 7);
//                [sectionBtnIv setImage:[[UIImage imageNamed:@"shaixuan"] rt_tintedImageWithColor:UICOLOC]];
//            }else{
//                [sectionBtnIv setImage:[[UIImage imageNamed:@"pulldown"] rt_tintedImageWithColor:UICOLOC]];
//            }
//            
//        }
        if (i != btnCnt - 1) {
            UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width, 13, 0.5, 17)];
            [seperatorLine setBackgroundColor:UIColorFromRGBValue(0xeeeeee)];
            [self.segmentControlView addSubview:seperatorLine];
        }
        
           // sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
        //[self.segmentControlView addSubview:sectionBtnIv];
    }
   
        _segmentBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, HCSegmentedControl_Height - 0.5, self.frame.size.width, 0.5)];
        [_segmentBottomLineView setBackgroundColor:UIColorFromRGBValue(0xe0e0e0)];
        [self addSubview:_segmentBottomLineView];

   

    self.selectedIdx = -1;
    [self addSubview:self.segmentControlView];
}

//初始化下拉视图
- (void)initDropdownView:(NSInteger)type
{
    //初始化排序筛选数据
    self.orderData = [SortCond getSortCondData];
    
    //初始化价格筛选数据
    self.priceData = [PriceCond getPriceCondData];
    
    //初始化其他复合筛选数据
    NSMutableArray *otherFilterData = [[NSMutableArray alloc] init];
  //  NSMutableArray *ageCond = [[NSMutableArray alloc] init];
    //[ageCond addObject:@"车龄"];
    [otherFilterData addObject:[AgeCond getAgeCondData]];
   // [otherFilterData addObject:ageCond];
    
   // NSMutableArray *milesCond = [[NSMutableArray alloc] init];
   // [milesCond addObject:@"里程"];
    [otherFilterData addObject:[MilesCond getMilesCondData]];
    //[otherFilterData addObject:milesCond];
    
   // NSMutableArray *gearboxCond = [[NSMutableArray alloc] init];
   // [gearboxCond addObject:@"变速箱"];
    [otherFilterData addObject:[GearboxCond getGearboxCondData]];
   // [otherFilterData addObject:gearboxCond];
    
    //NSMutableArray *emissionStandar = [[NSMutableArray alloc] init];
   // [emissionStandar addObject:@"排放标准"];
    [otherFilterData addObject:[EmissionStandarCond getEmissionStandarCondData]];
    //[otherFilterData addObject:emissionStandar];
    
   // NSMutableArray *structCond = [[NSMutableArray alloc] init];
   // [structCond addObject:@"车身结构"];
    [otherFilterData addObject:[StructureCond getSturctureCondData]];
  //  [otherFilterData addObject:structCond];
    
   // NSMutableArray *emissionCond = [[NSMutableArray alloc] init];
    //[emissionCond addObject:@"排量"];
    [otherFilterData addObject:[EmissionCond getEmissionCondData]];
    //[other    FilterData addObject:emissionCond];
    
    
    self.otherFilterData = otherFilterData;
    //初始化品牌数据
    self.brandSeriesData = [BizBrandSeries getBrandSeriesListOrderedLocal:self.dataFilter.city.cityId];
    
    //64 + self.segmentControlView.frame.origin.y + self.segmentControlView.frame.size.height
    //[UIScreen mainScreen].bounds.size.height - (64 + HCSegmentedControl_Height) - (self.isCoverTabbar ? 0 : 48)
    CGRect dropdownViewRect = CGRectMake(HCSCREEN_WIDTH*0.15, 0, HCSCREEN_WIDTH*0.85, HCSCREEN_HEIGHT );
    self.sortFilterView = [[HCDropSortListView alloc]initWithFrame:dropdownViewRect dataArray:self.orderData superView:[UIApplication sharedApplication].keyWindow typeEnum:0];
    self.sortFilterView.tag = HC_DROPDOWN_VIEW_TAG_BEGIN ;
    self.sortFilterView.delegate = self;
    self.priceFilterView = [[HCDropdownListView alloc] initWithFrame:dropdownViewRect dataArray:self.priceData superView:[UIApplication sharedApplication].keyWindow typeEnum:1];
    self.priceFilterView.tag = HC_DROPDOWN_VIEW_TAG_BEGIN + 2;
    self.priceFilterView.delegate = self;
    
    self.brandFilterView = [[HCDropdownBrandSelectView alloc] initWithFrame:dropdownViewRect dataArray:self.brandSeriesData city:self.dataFilter.city.cityId superView:[UIApplication sharedApplication].keyWindow];
    self.brandFilterView.tag = HC_DROPDOWN_VIEW_TAG_BEGIN + 1;
    self.brandFilterView.delegate = self;
    
    self.otherFilterView = [[HCDropdownOtherSelectView alloc] initWithFrame:dropdownViewRect dataArray:self.otherFilterData superView:[UIApplication sharedApplication].keyWindow suitable:type];
    
    self.otherFilterView.tag = HC_DROPDOWN_VIEW_TAG_BEGIN + 3;
    self.otherFilterView.delegate = self;
    self.otherFilterView.numDelegate = self;
    [self updateBrandSeriesData];
    
}


////搜索出数据  把之前的所有筛选条件清空
- (void)empMoreAll
{
     //滑动年龄
    //[self.otherFilterView EmpAll];
    [self emptyBrand];
    [self.dataFilter setGearboxCond:[[GearboxCond getGearboxCondData]HCObjectAtIndex:0]];
    [self.dataFilter setEmissionStandarCond:[[EmissionStandarCond getEmissionStandarCondData]HCObjectAtIndex:0]];
    [self.dataFilter setStructureCond:[[StructureCond getSturctureCondData]HCObjectAtIndex:0]];
    [self.dataFilter setEmissionCond:[[EmissionCond getEmissionCondData]HCObjectAtIndex:0]];
    [self resetSegmentTextColor];
}

- (void)emptyPrice
{
    [self.priceFilterView hidden];
    self.dataFilter.priceCond = [[PriceCond getPriceCondData]HCObjectAtIndex:0];
    [self.priceFilterView emptyPr];
    [self resetSegmentTextColor];
    [self.priceFilterView resetData:0];
    [self.priceFilterView hide:NO];
}

- (void)emptyBrand
{
    if ([self.dataFilter.brandSeriesCond isValid] == YES) {
        self.dataFilter.brandSeriesCond.brandId = -1;
        self.dataFilter.brandSeriesCond.seriesId = -1;
        self.dataFilter.brandSeriesCond.brandName = @"";
        self.dataFilter.brandSeriesCond.seriesName = @"";
    }
    [self resetSegmentTextColor];
    [self.brandFilterView resetData:self.dataFilter.brandSeriesCond];
}

//- (void)emptyMore:(NSString *)strName
//{
//    
//    if ([strName isEqualToString:@"register_time"]) {
//        [self.dataFilter setAgeCond:[[AgeCond getAgeCondData]HCObjectAtIndex:0]];
//        [self.otherFilterView EmpAge];
//    }else if ([strName isEqualToString:@"miles"]) {
//        [self.dataFilter setMilesCond:[[MilesCond getMilesCondData]HCObjectAtIndex:0]];
//        [self.otherFilterView EmpMile];
//    }else if ([strName isEqualToString:@"gear"]) {
//        [self.dataFilter setGearboxCond:[[GearboxCond getGearboxCondData]HCObjectAtIndex:0]];
//    }else if ([strName isEqualToString:@"es"]) {
//        [self.dataFilter setEmissionStandarCond:[[EmissionStandarCond getEmissionStandarCondData]HCObjectAtIndex:0]];
//    }else if ([strName isEqualToString:@"structure"]) {
//        [self.dataFilter setStructureCond:[[StructureCond getSturctureCondData]HCObjectAtIndex:0]];
//    }else if ([strName isEqualToString:@"emission"]) {
//          [self.dataFilter setEmissionCond:[[EmissionCond getEmissionCondData]HCObjectAtIndex:0]];
//    }else if([strName isEqualToString:@"year"]){
//        [self.dataFilter setPattenCond:[[PatternCond alloc]initPatternCond:-1 to:-1 desc:nil]];
//        
//    }
//    [self.otherFilterView resetViewBtnSelect:strName];
//     [self resetSegmentTextColor];
//}

- (DataFilter* )getNumRequestDict:(NSDictionary *)dic{
    DataFilter *dataFilter = [[DataFilter alloc]init];
    [dataFilter setBrandSeriesCond:self.dataFilter.brandSeriesCond];
    [dataFilter setPriceCond:self.dataFilter.priceCond];
    [dataFilter setAgeCond:[dic objectForKey:@"车龄"]];
    [dataFilter setGearboxCond:[dic objectForKey:@"变速箱"]];
    [dataFilter setEmissionCond:[dic objectForKey:@"排量"]];
    [dataFilter setMilesCond:[dic objectForKey:@"里程"]];
    [dataFilter setEmissionStandarCond:[dic objectForKey:@"排放标准"]];
    [dataFilter setStructureCond:[dic objectForKey:@"车身结构"]];
    [dataFilter setCountyrCond:[dic objectForKey:@"国别"]];
    [dataFilter setColorCond:[dic objectForKey:@"车身颜色"]];
    return dataFilter;
}

- (void)requestvehicleNum:cond{
   
    if (self.isTodayNew == YES) {
        [BizVehicleSource getNewVehicleNumQuery:[[self getNumRequestDict:cond] getFilterRequestParam:1] byfinish:^(NSInteger count, NSInteger code) {
            if (code !=0) {
                NSLog(@"失败");
                [self.otherFilterView resetVehicleNum:-1];
            }else{
                [self.otherFilterView resetVehicleNum:count];
            }
        }];
    }else{
        
        if (self.type==2) {
            [BizVehicleSource getZhiyingdianVehiclesNumQuery:[[self getNumRequestDict:cond] getFilterRequestParam:1] byfinish:^(NSInteger count, NSInteger code) {
                if (code !=0) {
                    NSLog(@"失败");
                    [self.otherFilterView resetVehicleNum:-1];
                }else{
                    [self.otherFilterView resetVehicleNum:count];
                }
            }];
        }else{
        [BizVehicleSource getVehiclesNumQuery:[[self getNumRequestDict:cond] getFilterRequestParam:1] suitable:self.type byfinish:^(NSInteger count, NSInteger code) {
            if (code !=0) {
                NSLog(@"失败");
                [self.otherFilterView resetVehicleNum:-1];
            }else{
                [self.otherFilterView resetVehicleNum:count];
            }
        }];
        }
    }
}
//- (void)showMsg:(NSString *)title type:(FVAlertType)type
//{
//    [FVCustomAlertView showAlertOnView:self.window
//                             withTitle:title
//                            titleColor:[UIColor whiteColor]
//                                 width:120.0
//                                height:100.0
//                       backgroundImage:nil
//                       backgroundColor:[UIColor blackColor]
//                          cornerRadius:10.0
//                           shadowAlpha:0.1
//                                 alpha:0.8
//                           contentView:nil
//                                  type:type];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [FVCustomAlertView hideAlertFromView:self.window fading:YES];
//    });
//}
- (void)updateBrandSeriesData
{
    [BizBrandSeries getBrandSeriesListOrderedRemote:self.dataFilter.city.cityId localEmpty:([[self.brandSeriesData HCObjectAtIndex:1] count] == 0) byfinish:^(NSArray *ret) {
        if (ret != nil && [[ret HCObjectAtIndex:1] count] > 0) {
            self.brandSeriesData = ret;
            //通知品牌视图刷新
            [self.brandFilterView resetBrandSeriesData:self.brandSeriesData forCity:self.dataFilter.city.cityId];
        }
    }];
}

- (void)showDropDownViewByIdx:(NSInteger)index
{
    switch (index) {
        case 0:
            [self.sortFilterView show];
            break;
        case 1:
            [self.brandFilterView show];
            break;
        case 2:
            [self.priceFilterView show];
            break;
        case 3:
            [self.otherFilterView show];
            [self.otherFilterView getCondValuesFromDatafilter:self.dataFilter];
            break;
        default:
            break;
    }
}

- (void)hideDropDownViewByIdx:(NSInteger)index animate:(BOOL)animate
{

    switch (index) {
        case 0:
            [self.sortFilterView hide:animate];
            break;
        case 1:
            [self.brandFilterView hide:animate];
            break;
        case 2:
             [self.priceFilterView hide:animate];
            break;
        case 3:
            [self.otherFilterView hide:animate];
            break;
        default:
            break;
    }
}


//segment button
- (void)segmentedControlChange:(UIButton *)btn
{
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            [subBtn setSelected:NO];
        } else {
            btn.selected = !btn.selected;
        }
    }
    NSInteger curSection = btn.tag - Define_Tag_add;
    
    if (curSection == self.selectedIdx) {
        [self hideDropDownViewByIdx:self.selectedIdx animate:NO];
    } else {
        if (self.selectedIdx != -1) {
            [self hideDropDownViewByIdx:self.selectedIdx animate:NO];
        }
        [self showDropDownViewByIdx:curSection];
    }
    

    if (curSection != self.selectedIdx) {
        [self setSegmentSelected:curSection];
    } else {
        [self setSegmentUnselected:curSection];
    }

}

- (void)showBrandDropdownView
{
    NSInteger idx = 1;
    //显示当前品牌视图
    [self showDropDownViewByIdx:idx];
    [self setSegmentSelected:idx];
    self.selectedIdx = idx;
    [[self.array4Btn HCObjectAtIndex:idx] setSelected:YES];
}

- (void)showPriceDropdownView
{
    NSInteger idx = 2;
    [self showDropDownViewByIdx:idx];
    [self setSegmentSelected:idx];
    self.selectedIdx = idx;
    //显示当前品牌视图
   [[self.array4Btn HCObjectAtIndex:idx] setSelected:YES];
}

- (void)RotateImageView:(UIImageView*)img type:(NSInteger)type{
    
    if (type==1) {
        [UIView animateWithDuration:0.3 animations:^{
            img.image = [img.image rt_tintedImageWithColor:UICOLOC];
            img.transform = CGAffineTransformRotate(img.transform, DEGREES_TO_RADIANS(180));
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            img.image = [img.image rt_tintedImageWithColor:PRICE_STY_CORLOR];
            img.transform = CGAffineTransformRotate(img.transform, DEGREES_TO_RADIANS(180));
        }];
    }
    
    
}

- (void)setSegmentSelected:(NSInteger)segIdx
{
    if (segIdx != self.selectedIdx) {
        //旋转当前图标
        UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +segIdx)];
        [self RotateImageView:currentIV type:0];
        if (self.selectedIdx != -1) {
            //将之前选定的图标恢复
            currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + self.selectedIdx];
            [self RotateImageView:currentIV type:1];
        }
        self.selectedIdx = segIdx;
    }
}
- (void)getCurrentCity{
    UIButton *btn = [self.array4Btn HCObjectAtIndex:0];
    [btn setTitle:[BizCity getCurCity].cityName forState:UIControlStateNormal];
    
}
//
- (void)setSegmentUnselected:(NSInteger)segIdx
{
    if (self.selectedIdx == segIdx && self.selectedIdx != -1) {
        UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +segIdx)];
//        if (segIdx == 0) {
//            [UIView animateWithDuration:0.3 animations:^{
//            currentIV.image = [currentIV.image rt_tintedImageWithColor:UICOLOC];
//            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
//                }];
//        } else {
            [UIView animateWithDuration:0.3 animations:^{
                currentIV.image = [currentIV.image rt_tintedImageWithColor:UICOLOC];
                currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
            }];
       // }
        self.selectedIdx = -1;
        //调整当前的btn颜色
        [[self.array4Btn HCObjectAtIndex:segIdx] setSelected:NO];
    }
    
    
    
    [self resetSegmentTextColor];
}

- (void)resetSegmentTextColor
{
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self.array4Btn HCObjectAtIndex:i];
        
        if (i == 0) {
            if ([self.dataFilter.sortCond isValid]) {
                [btn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:UIColorFromRGBValue(0x9b9b9b) forState:UIControlStateNormal];
            }
        }else if (i==1) {
            if ([self.dataFilter.brandSeriesCond isValid]) {
                 [btn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            }else{
                 [btn setTitleColor:UIColorFromRGBValue(0x9b9b9b) forState:UIControlStateNormal];
            }
        }else if (i==2){
            
            if ([self.dataFilter.priceCond isValid]) {
                 [btn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            }else{
                 [btn setTitleColor:UIColorFromRGBValue(0x9b9b9b) forState:UIControlStateNormal];
            }
            
        }else if (i==3){
            if ([self.dataFilter otherViewisValid]) {
                [btn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            }else{
                 [btn setTitleColor:UIColorFromRGBValue(0x9b9b9b) forState:UIControlStateNormal];
            }
        }
    }
}

-(BOOL)otherFilterValid
{
    return (self.dataFilter.ageCond != nil || self.dataFilter.gearboxCond !=nil ||
            self.dataFilter.milesCond != nil || self.dataFilter.emissionCond != nil ||
            self.dataFilter.structureCond != nil || self.dataFilter.emissionStandarCond != nil);
}

#pragma dropdown view 消失事件
- (void)dismissDropdownView:(NSNotification *)notification {
    [self setSegmentUnselected:self.selectedIdx];
}

#pragma 下拉列表选择回调事件
- (void) hcDropDownListViewDidSelectRowAtIndexPath:(NSInteger)idx fromViewTag:(NSInteger)tagId conditon:(id)cond
{
    NSInteger selectedSeg = tagId - HC_DROPDOWN_VIEW_TAG_BEGIN;
    switch (selectedSeg) {
        case 0:
            //排序条件
           //  text = ((SortCond *)cond).sortDesc;
            [self.dataFilter setSortCond:(SortCond *)cond];
            break;
        case 1:
            //品牌筛选
            if (((BrandSeriesCond *)cond).seriesId > 0) {
          //     mBrand = ((BrandSeriesCond *)cond).seriesName;
            } else if (((BrandSeriesCond *)cond).brandId > 0) {
           //     mBrand = ((BrandSeriesCond *)cond).brandName;
            }
            [self.dataFilter setBrandSeriesCond:(BrandSeriesCond *)cond];
            break;
        case 2:
           //  mPrice = ((PriceCond *)cond).desc;
            //替换不限的字符
           // if ([text isEqualToString:@"不限"]) {
            //    mPrice = @"价格";
            //}
            [self.dataFilter setPriceCond:(PriceCond *)cond];
            break;
        case 3:
            //其他多项筛选
            [self setCombinedFilterFromDic:(NSDictionary *)cond];
          //  mMoreArray = cond;
            break;
        default:
            break;
    }
    [self setSegmentUnselected:selectedSeg];
    [self resetSegmentTextColor];
    
    
    //通知主列表页根据datafilter 刷新
    if (self.delegate) {
        [self.delegate listPageUpdateByFilter:self.dataFilter];
    }
    
}


//将其他筛选的过滤规则添加到datafilter里
-(void)setCombinedFilterFromDic:(NSDictionary *)dic
{
        [self.dataFilter setAgeCond:[dic objectForKey:@"车龄"]];
        [self.dataFilter setGearboxCond:[dic objectForKey:@"变速箱"]];
        [self.dataFilter setEmissionCond:[dic objectForKey:@"排量"]];
        [self.dataFilter setMilesCond:[dic objectForKey:@"里程"]];
        [self.dataFilter setEmissionStandarCond:[dic objectForKey:@"排放标准"]];
        [self.dataFilter setStructureCond:[dic objectForKey:@"车身结构"]];
        [self.dataFilter setCountyrCond:[dic objectForKey:@"国别"]];
        [self.dataFilter setColorCond:[dic objectForKey:@"车身颜色"]];
}


- (void)reloadDataByDataFilter:(DataFilter *)filter
{
    self.dataFilter = filter;
    //如果城市发生切换。 则尝试获取本城市下的品牌数据
    self.brandSeriesData = [BizBrandSeries getBrandSeriesListOrderedLocal:filter.city.cityId];
    
    [self.brandFilterView resetBrandSeriesData:self.brandSeriesData forCity:filter.city.cityId];
    [self updateBrandSeriesData];
    
   if (self.dataFilter.priceCond != nil) {
        //获取价格条件所对应的数组idx
      PriceCond *curPC = self.dataFilter.priceCond;
      NSInteger idx = 0;
       for (PriceCond *pc in self.priceData) {
           if ( curPC.priceTo == pc.priceTo) {
                [self.priceFilterView resetData:idx];
               break;
           }else{
               
               idx ++;
            }
           
       }
//        if (idx < [self.priceData count]) {
//            NSLog(@"idx ---%ld",(long)idx);
//            [self.priceFilterView resetData:idx];
//          //  [[self.array4Btn objectAtIndex:2] setTitle:curPC.desc forState:UIControlStateNormal];
//        }
      
  } else {
      [self.priceFilterView resetData:0];
     //[[self.array4Btn objectAtIndex:2] setTitle:[self.titles objectAtIndex:2] forState:UIControlStateNormal];
  }
    
    if (self.dataFilter.sortCond != nil) {
        SortCond *curSC = self.dataFilter.sortCond;
        NSInteger idx = 0;
        for (SortCond *sc in self.orderData) {
            if (curSC.sortType == sc.sortType) {
                break;
            }
            idx += 1;
        }
        if (idx < [self.orderData count]) {
            [self.sortFilterView resetData:idx];
            [[self.array4Btn objectAtIndex:0] setTitle:curSC.sortDesc forState:UIControlStateNormal];
            [[self.array4Btn objectAtIndex:0]  horizontalCenterTitleAndImage];
        }
    } else {
        [self.sortFilterView resetData:0];
        
        [[self.array4Btn objectAtIndex:0] setTitle:[self.titles objectAtIndex:0] forState:UIControlStateNormal];
        [[self.array4Btn objectAtIndex:0]  horizontalCenterTitleAndImage];
    }
    
    //品牌筛选
    if (self.dataFilter.brandSeriesCond != nil) {
        BrandSeriesCond *cond = self.dataFilter.brandSeriesCond;
//        if (cond.seriesId != -1) {
//            
//            //[[self.array4Btn objectAtIndex:1] setTitle:cond.seriesName forState:UIControlStateNormal];
//        } else if (cond.brandId != -1) {
//            //[[self.array4Btn objectAtIndex:1] setTitle:cond.brandName forState:UIControlStateNormal];
//        }
        [self.brandFilterView resetData:cond];
    } else {
        [self.brandFilterView resetData:nil];
       // [[self.array4Btn objectAtIndex:1] setTitle:[self.titles objectAtIndex:1] forState:UIControlStateNormal];
    }
    //其他筛选
    NSMutableDictionary *otherFilterDict = [[NSMutableDictionary alloc] init];
    if (self.dataFilter.ageCond != nil) {
       // NSArray *ageCondArr = [self.otherFilterData HCObjectAtIndex:0];
        [otherFilterDict setObject:self.dataFilter.ageCond forKey:@"车龄"];

    }
    if (self.dataFilter.gearboxCond != nil) {
        NSArray *gearboxCondArr = [self.otherFilterData HCObjectAtIndex:2];
        for (NSInteger i = 1; i < [gearboxCondArr count]; ++i) {
            GearboxCond *gc = [gearboxCondArr HCObjectAtIndex:i];
            if (gc.type == self.dataFilter.gearboxCond.type) {
                [otherFilterDict setObject:self.dataFilter.gearboxCond forKey:@"变速箱"];
            }
        }
    }
    
    if (self.dataFilter.emissionCond != nil) {
       
        [otherFilterDict setObject:self.dataFilter.emissionCond forKey:@"排量"];

    }

    if (self.dataFilter.milesCond != nil) {
        [otherFilterDict setObject:self.dataFilter.milesCond forKey:@"里程"];

    }

    if (self.dataFilter.structureCond != nil) {
        NSArray *structureCondArr = [self.otherFilterData HCObjectAtIndex:4];
        for (NSInteger i = 1; i < [structureCondArr count]; ++i) {
            StructureCond *sc = [structureCondArr HCObjectAtIndex:i];
            if (sc.type == self.dataFilter.structureCond.type) {
                [otherFilterDict setObject:self.dataFilter.structureCond  forKey:@"车身结构"];
            }
        }
    }

    if (self.dataFilter.emissionStandarCond != nil) {
        
        [otherFilterDict setObject:self.dataFilter.emissionStandarCond forKey:@"排放标准"];
        
        
    }
    if (self.dataFilter.countyrCond != nil) {
        [otherFilterDict setObject:self.dataFilter.countyrCond forKey:@"国别"];
    }
    if (self.dataFilter.colorCond != nil) {
        [otherFilterDict setObject:self.dataFilter.colorCond forKey:@"车身颜色"];
        
    }
    [self.otherFilterView resetData:otherFilterDict];
    [self resetSegmentTextColor];
    //重置当前segment为未选中状态
    [self setSegmentUnselected:self.selectedIdx];
    [self.otherFilterView requestNum];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
