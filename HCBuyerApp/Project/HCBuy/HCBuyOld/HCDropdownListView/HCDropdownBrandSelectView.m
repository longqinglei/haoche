//
//  HCDropdownBrandSelectView.m
//  HCBuyerApp
//
//  Created by wj on 15/5/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCDropdownBrandSelectView.h"
#import "HotBrandCell.h"
#import "BrandCell.h"
#include "BrandSeries.h"
#import "DataFilter.h"
#import "BizBrandSeries.h"
#import "HCDropdownSeriesView.h"

#define HC_HOTBRAND_CELL_HEIGHT HCSCREEN_WIDTH*0.19*2+32

@interface HCDropdownBrandSelectView()<HCHotBrandCellTouchDelegate, SeriesSelectedDelegate >

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *gapView;
@property (nonatomic, strong) UIView *mSuperView;

@property(nonatomic, strong) HCDropdownSeriesView *seriesView;

//@property (nonatomic,strong)MJNIndexView *mjIndexView;
@property (nonatomic, strong) NSArray *hotBrandSeriesData;
@property (nonatomic, strong) NSArray *brandSereiesSectionData;
@property (nonatomic, strong) NSDictionary *brandSeriesMap;
@property (nonatomic) NSInteger cityId;
@property (nonatomic)CGRect seriesRect;
@property (nonatomic, strong) BrandSeriesCond *brandSeriesCond;
@property (nonatomic, strong)UILabel *showLabel;
@property (nonatomic,strong)UIView *navgation;
//当前页面选中的品牌
@property (nonatomic) NSInteger selectedBrandId;


@property (nonatomic)BOOL isClean;

@end

@implementation HCDropdownBrandSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)createShowLabel{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
//   self.showLabel = [[UILabel alloc]init];
//    self.showLabel.backgroundColor = [UIColor orangeColor];
//    self.showLabel.frame = CGRectMake(window.center.x-25, window.center.y-25, 50, 50);
//    self.showLabel.hidden=  YES;
//    [window addSubview:self.showLabel];
//    
//}
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data city:(NSInteger)cityId superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.navgation= [[UIView alloc]init];
        self.navgation.backgroundColor = [UIColor whiteColor];
        self.navgation.frame = CGRectMake(frame.origin.x, 0, self.width, 64);
        UILabel *titleLabel= [[UILabel alloc]init];
        titleLabel.text = @"品牌";
        titleLabel.frame = CGRectMake(0, 20, self.width, 44);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        [self.navgation addSubview:titleLabel];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
        [self.navgation addSubview:line];
        //  [self createShowLabel];
        //计算tableview高度
        //CGFloat tableViewHeight = frame.size.height - HC_FRAME_GAP;
        //全屏覆盖
       // CGFloat tableViewHeight = frame.size.height;
        
        CGRect tableViewRect = CGRectMake(frame.origin.x, 64, frame.size.width, HCSCREEN_HEIGHT-64);
        self.seriesRect = frame;
        
        self.mTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , HCSCREEN_WIDTH*0.15, HCSCREEN_HEIGHT)];
        self.gapView.backgroundColor = UIColorFromRGBValue(0x000000);
        self.gapView.alpha = 0.6;
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
        
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.sectionIndexColor = PRICE_STY_CORLOR;
        self.mSuperView = superView;
        
        self.cityId = cityId;
        [self setBrandSeriesData:data];
        self.brandSeriesCond = [[BrandSeriesCond alloc] initByBrand:-1 brandName:@"" series:-1 seriesName:@""];
        
        self.selectedBrandId = -1;
        
        self.seriesView = [[HCDropdownSeriesView alloc] initWithFrame:tableViewRect superView:self.mSuperView];
        self.seriesView.delegate = self;
//        
//        self.mjIndexView = [[MJNIndexView alloc]initWithFrame:self.mTableView.frame];
//        self.mjIndexView.dataSource = self;
//        self.mjIndexView.fontColor = [UIColor blueColor];
//        [self firstAttributesForMJNIndexView];
        
        
        
        
    }
    return self;
}
//
//- (void)firstAttributesForMJNIndexView
//{
//    
//    self.mjIndexView.getSelectedItemsAfterPanGestureIsFinished = YES;
//    self.mjIndexView.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
//    self.mjIndexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
//    self.mjIndexView.backgroundColor = [UIColor clearColor];
//    self.mjIndexView.curtainColor = nil;
//    self.mjIndexView.curtainFade = 0.0;
//    self.mjIndexView.curtainStays = NO;
//    self.mjIndexView.curtainMoves = YES;
//    self.mjIndexView.curtainMargins = NO;
//    self.mjIndexView.ergonomicHeight = NO;
//    self.mjIndexView.upperMargin = 10.0;
//    self.mjIndexView.lowerMargin = 10.0;
//    self.mjIndexView.rightMargin = 2.5;
//    self.mjIndexView.itemsAligment = NSTextAlignmentCenter;
//    self.mjIndexView.maxItemDeflection = 100.0;
//    self.mjIndexView.rangeOfDeflection = 5;
//    self.mjIndexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
//    self.mjIndexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
//    self.mjIndexView.darkening = NO;
//    self.mjIndexView.fading = YES;
//    
//}


- (void)resetData:(BrandSeriesCond *)cond
{
    if (cond == nil) {
        self.brandSeriesCond.brandId = -1;
        self.brandSeriesCond.seriesId = -1;
        self.brandSeriesCond.seriesName = @"";
        self.brandSeriesCond.brandName = @"";
        self.selectedBrandId = -1;
    } else {
        self.brandSeriesCond = cond;
        self.selectedBrandId = cond.brandId;
        
    }
    [self hide:NO];
}

//根据传入的数据，设置当前的品牌车系相关的变量
- (void)setBrandSeriesData:(NSArray *)data
{
    self.hotBrandSeriesData = [data HCObjectAtIndex:0];
    NSArray *brandSeriesData = [data HCObjectAtIndex:1];
    NSMutableArray *allGroupedData = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *brandSeriesMap = [[NSMutableDictionary alloc] init];
    
    //brandSeriesData 是根据品牌首字母升序排列的
    NSString *lastLabel = @"";
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (BrandSeries *info in brandSeriesData) {
        NSString *label = info.brandFirstLetter;
        //第一次初始化
        if ([lastLabel length] == 0) {
            lastLabel = label;
        }
        if (![label isEqualToString:lastLabel]) {
            //进入下一个组
            NSMutableArray *groupData = [[NSMutableArray alloc] init];
            [groupData addObject:lastLabel];
            [groupData addObject:arr];
            [allGroupedData addObject:groupData];
            
            arr = [[NSMutableArray alloc] init];
            [arr addObject:info];
            lastLabel = label;
        } else {
            [arr addObject:info];
        }
        [brandSeriesMap setValue:info.seriesInfo forKey:[NSString stringWithFormat:@"%ld", (long)info.brandId]];
    }
    //final
    NSMutableArray *groupData = [[NSMutableArray alloc] init];
    [groupData addObject:lastLabel];
    [groupData addObject:arr];
    [allGroupedData addObject:groupData];
    self.brandSereiesSectionData = allGroupedData;
    self.brandSeriesMap = brandSeriesMap;
}



- (void)resetBrandSeriesData:(NSArray *)data forCity:(NSInteger)cityId
{
    [self setBrandSeriesData:data];
    self.cityId = cityId;
    [self.mTableView reloadData];
}


-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
}

- (void)show
{
   
    self.gapView.alpha = 0.3;
    self.mTableView.alpha = 1.0;
    [self.mTableView reloadData];
    [self.mSuperView addSubview:self.navgation];
    [self.mSuperView addSubview:self.gapView];
    [self.mSuperView addSubview:self.mTableView];
    //[self.mSuperView addSubview:self.mjIndexView];
    
    NSInteger city = self.cityId;
    [BizBrandSeries getBrandSeriesListOrderedRemote:self.cityId localEmpty:([self.brandSereiesSectionData count] == 0 || [self.hotBrandSeriesData count] == 0) byfinish:^(NSArray *ret) {
        if (ret != nil && [ret count] > 0 && city == self.cityId) {
            [self resetBrandSeriesData:ret forCity:self.cityId];
        }
    }];
    
    if (self.selectedBrandId != -1) {
        if (self.brandSeriesCond.brandId != self.selectedBrandId && self.brandSeriesCond.brandId != -1) {
            //如果前次筛选条件与当前选择的品牌不一致，再次出现视图的时候以筛选条件为主
            self.selectedBrandId = self.brandSeriesCond.brandId;
        }
        //滚动到当前的品牌
      //  NSIndexPath *scrollIndexPath = [self getTableIndexPathByBrandId:self.selectedBrandId];
       // if (scrollIndexPath != nil) {
         //   [self.mTableView scrollToRowAtIndexPath:scrollIndexPath
                                  // atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //显示车系
//            BrandSeries *brandSeries = [[[self.brandSereiesSectionData HCObjectAtIndex:scrollIndexPath.section - 2] HCObjectAtIndex:1] HCObjectAtIndex:scrollIndexPath.row];
 //           [self.seriesView showWithBrandSeriesData:brandSeries animate:NO isSelectedUnlimit:(self.brandSeriesCond.brandId != -1 && self.brandSeriesCond.seriesId == -1)];
    //    }
    }
}

- (void)hide:(BOOL)animate;
{
    
    CGRect rect = self.mTableView.frame;
    CGRect oldRect = rect;
    rect.size.height = 0;
    
    if (!animate) {
        [self.mTableView removeFromSuperview];
      //  [self.mjIndexView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        //if (self.selectedBrandId != -1) {
            [self.seriesView hide:NO];
        //}
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.gapView.alpha = 0.3f;
        self.mTableView.alpha = 0.2;
        self.mTableView.frame = rect;
    }completion:^(BOOL finished) {
        [self.mTableView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        self.mTableView.frame = oldRect;
    }];
    //if (self.selectedBrandId != -1) {
        [self.seriesView hide:NO];
    //}
}


- (NSIndexPath *)getTableIndexPathByBrandId:(NSInteger)brandId
{
    NSInteger section = -1;
    NSInteger row = -1;
    NSInteger sectionCont = [self.brandSereiesSectionData count];
    for (NSInteger i = 0; i < sectionCont; ++i) {
        NSArray *brandArr = [[self.brandSereiesSectionData HCObjectAtIndex:i] HCObjectAtIndex:1];
        NSInteger brandCnt = [brandArr count];
        for (NSInteger j = 0; j < brandCnt; ++j) {
            BrandSeries *data = [brandArr HCObjectAtIndex:j];
            if (data.brandId == brandId) {
                section = i;
                row = j;
                break;
            }
            if (section != -1 && row != -1) {
                break;
            }
        }
    }
    if (section != -1 && row != -1) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:section + 2];
        return scrollIndexPath;
    }
    return nil;
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HC_HOTBRAND_CELL_HEIGHT;
    } else if (indexPath.section == 1) {
        //全部车源的section，高度调整
        return HC_LIST_ROW_HEIGHT + 10;
    }
    return HC_LIST_ROW_HEIGHT;
}

#pragma notClean
- (void)clearFilterCond
{
 //   if([self.brandSeriesCond isValid]){
    self.selectedBrandId = -1;
    self.brandSeriesCond.brandId = -1;
    self.brandSeriesCond.brandName = @"";
    self.brandSeriesCond.seriesId = -1;
    if (self.delegate) {
        [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:-1 fromViewTag:self.tag conditon:self.brandSeriesCond];
    }
    [self hide:NO];
//}
    // [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"click row");
    if (indexPath.section == 1) {
        //点击全部车源
        //重置筛选条件
        [self clearFilterCond];
    }
    if (indexPath.section >= 2) {
        //获取当前品牌信息
        BrandSeries *brandSeries = [[[self.brandSereiesSectionData HCObjectAtIndex:indexPath.section - 2] HCObjectAtIndex:1] HCObjectAtIndex:indexPath.row];
        
        //self.selectedBrandId = brandSeries.brandId;

        //[self.mTableView scrollToRowAtIndexPath:indexPath
        //                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.seriesView showWithBrandSeriesData:brandSeries animate:YES isSelectedUnlimit:NO];
    }
}

#pragma mark -- UITableView DataSource


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"🔥", @"#"]];
    for (NSArray *arr in self.brandSereiesSectionData) {
        [array addObject:[arr HCObjectAtIndex:0]];
    }
    return array;
}

//- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
//{
//    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"🔥", @"#"]];
//    for (NSArray *arr in self.brandSereiesSectionData) {
//        [array addObject:[arr HCObjectAtIndex:0]];
//    }
//    return array;
//}

//- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
//{
//    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:index] atScrollPosition: UITableViewScrollPositionTop     animated:NO];
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + [self.brandSereiesSectionData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    } else if (section == 0) {
        return 1;
    } else {
        NSInteger brandSection = section - 2;
        NSArray *arr = [[self.brandSereiesSectionData HCObjectAtIndex:brandSection] HCObjectAtIndex:1];
        NSInteger cnt = [arr count];
        return cnt;
    }
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView*)customHeaderViewWithTitle:(NSString*)title{
    UIView *sectionview = [[UIView alloc]init];
    sectionview .frame = CGRectMake(0, 0, HCSCREEN_WIDTH*0.85, 20);
    sectionview.backgroundColor = MTABLEBACK;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 0, HCSCREEN_WIDTH*0.85-10, 20);
    label.backgroundColor = MTABLEBACK;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = UIColorFromRGBValue(0x9f9f9f);
    label.text = title;
    [sectionview addSubview:label];
    return sectionview;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return [self customHeaderViewWithTitle:@"🔥热门"];
    }else if (section==1){
        return [self customHeaderViewWithTitle:@"#"];
    }else{
        NSInteger brandSection = section - 2;
        return [self customHeaderViewWithTitle:[[self.brandSereiesSectionData HCObjectAtIndex:brandSection] HCObjectAtIndex:0]];;
    }
    
    return nil;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return @"#";
//    } else if (section == 0) {
//        return @"热门品牌";
//    } else {
//        NSInteger brandSection = section - 2;
//        return  [[self.brandSereiesSectionData HCObjectAtIndex:brandSection] HCObjectAtIndex:0];
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    self.showLabel.hidden = NO;
//   
//    self.showLabel.text = title;
    NSLog(@"当前点击的 %@",title);
    // 让table滚动到对应的indexPath位置
    // [self performSelector:@selector(hideShowLabel) withObject:nil afterDelay:2.0f];
  //  [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return index;
}
//- (void)hideShowLabel{
//    self.showLabel.hidden = YES;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //热门品牌
        if (self.hotBrandSeriesData.count>=HC_MAX_HOT_BRAND_NUM) {
            NSRange range = NSMakeRange(0, HC_MAX_HOT_BRAND_NUM);
            NSArray *hotBrandInfo = [self.hotBrandSeriesData subarrayWithRange:range];
            HotBrandCell *hotBrandCell = [[HotBrandCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HC_HOTBRAND_CELL_HEIGHT) data:hotBrandInfo];
            hotBrandCell.delegate = self;
            return hotBrandCell;
        }
        
    } else if (indexPath.section >= 2) {
        //全部品牌
        NSInteger rowIdx = indexPath.row;
        NSArray *brandArr = [[self.brandSereiesSectionData HCObjectAtIndex:indexPath.section - 2] HCObjectAtIndex:1];
        BrandSeries *brandSeriesInfo = [brandArr HCObjectAtIndex:rowIdx];
        NSString *cellIdentifier = @"brandListCell";
        BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[BrandCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HC_LIST_ROW_HEIGHT) image:brandSeriesInfo.brandId   text:brandSeriesInfo.brandName needBottomLine:(rowIdx != [brandArr count] - 1)];
            //NSLog(@"new brand list cell");
            return cell;
        }
        if (self.selectedBrandId==brandSeriesInfo.brandId) {
            [cell setCellSelected:YES];
        }else{
            [cell setCellSelected:NO];
        }
        //NSLog(@"reused brandListCell");
        [cell setDataWithImageId:brandSeriesInfo.brandId  text:brandSeriesInfo.brandName needBottomLine:(rowIdx != [brandArr count] - 1)];
        
        return cell;
    }
    //全部车源
    NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = @"全部品牌";
    cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma 热门品牌点击
- (void)touchAtIndex:(NSInteger)index forIndexPath:(NSIndexPath *)indexPath
{
    //确定所在的热门区的行数
    if (indexPath.row >= 1) {
        index += 5;
    }
    //NSLog(@"touch at index : %ld. last idx:%ld", index, self.selectIdxInHotBrandRow);
    //获取当前的品牌信息
    BrandSeries *brandSeriesInfo = [self.hotBrandSeriesData HCObjectAtIndex:index];
    NSInteger section = -1;
    NSInteger secitonCnt = [self.brandSereiesSectionData count];
    for (NSInteger i = 0; i < secitonCnt; ++i) {
        NSString *brandFirstLetter = [[self.brandSereiesSectionData HCObjectAtIndex:i] HCObjectAtIndex:0];
        if ([brandFirstLetter isEqualToString:brandSeriesInfo.brandFirstLetter]) {
            section = i;
            break;
        }
    }
    if (section >= 0) {
        //获取当前品牌的位置
        NSInteger idxInSection = -1;
        NSArray *brands = [[self.brandSereiesSectionData HCObjectAtIndex:section] HCObjectAtIndex:1];
        for (NSInteger i = 0; i < [brands count]; ++i ) {
            if (((BrandSeries *)[brands HCObjectAtIndex:i]).brandId == brandSeriesInfo.brandId) {
                idxInSection = i;
                break;
            }
        }
        if (idxInSection >= 0) {
            section += 2;
            
            //self.selectedBrandId = brandSeriesInfo.brandId;

            //滚动到指定位置
          //  NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:idxInSection inSection:section];
            //[self.mTableView scrollToRowAtIndexPath:scrollIndexPath
                                    //atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.seriesView showWithBrandSeriesData:brandSeriesInfo animate:YES isSelectedUnlimit:NO];
        }
    }
}

#pragma 车系选择的事件回调
- (void)doNoneSelected
{
    //self.selectedBrandId = -1;
}


#pragma mark - 品牌回调
- (void)selected:(BrandSeriesCond *)cond
{
    if ([cond isValid]) {
        self.brandSeriesCond = cond;
        self.selectedBrandId = self.brandSeriesCond.brandId;
        
        [self.mTableView reloadData];
        //通知主列表页刷新数据
        if (self.delegate) {
            [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:-1 fromViewTag:self.tag conditon:self.brandSeriesCond];
        }
        [self hide:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
    }
}

@end
