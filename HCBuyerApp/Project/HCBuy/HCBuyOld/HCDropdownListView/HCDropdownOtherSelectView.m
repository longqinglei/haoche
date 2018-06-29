//
//  HCDropdownOtherSelectView.m
//  HCBuyerApp
//
//  Created by wj on 15/5/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCDropdownOtherSelectView.h"
#import "DataFilter.h"
#import "ListPageDropdownView.h"
#import "HCOtherSelectCell.h"
#import "HCOtherCell.h"
#define Start_X 10.0f           // 第一个按钮的X坐标
#define Start_Y 12.0f           // 第一个按钮的Y坐标
#define Width_Space 10.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 35    // 高
#define Button_Width HCSCREEN_WIDTH/4.9      // 宽

#define HC_DOUBLE_SELECT_VIEW_TAG_BEGIN 5000


#import "UIButton+ITTAdditions.h"

static HCDropdownOtherSelectView *clearInde = nil;
@interface HCDropdownOtherSelectView()<UITableViewDelegate,UITableViewDataSource,HCSelectCondDelegate,HCOtherCellDelegate>

@property (nonatomic, strong) UIView *mSuperView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *mainSelectView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic,strong)UIView *gapView;

@property (nonatomic,strong)AgeCond *customAge;//车龄
@property (nonatomic,strong)MilesCond *customMile;//公里
@property (nonatomic,strong)EmissionCond *customEmission;//排量
@property (nonatomic,strong)GearboxCond *customGear;//变速箱
@property (nonatomic,strong)EmissionStandarCond *customStandar;//排放标准
@property (nonatomic,strong)StructureCond *customStruct;//车身结构
@property (nonatomic,strong)CountryCond *coustomCountry;//国别
@property (nonatomic,strong)ColorCond *coustomColor;//车身颜色

@property (nonatomic,strong) NSMutableDictionary *vehicleNumDic;
@property (nonatomic)BOOL SructCellShow;
@property (nonatomic)BOOL emissionStandShow;
@property (nonatomic)BOOL emissionShow;
@property (nonatomic)BOOL colorShow;
@property (nonatomic)BOOL countryShow;
@property (strong,nonatomic)UIView *mView;
@property (nonatomic,strong)UIView*navgation;
@property (nonatomic)BOOL countrySlider;
@property (nonatomic)BOOL colorSlider;
@property (nonatomic,strong)UILabel *vehicleNumlabel;
@property (nonatomic)NSInteger type;
@end

@implementation HCDropdownOtherSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView suitable:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        self.type = type;
        self.filterCondDic = [[NSMutableDictionary alloc] init];
        self.vehicleNumDic = [[NSMutableDictionary alloc] init];
        self.navgation= [[UIView alloc]init];
        self.navgation.backgroundColor = [UIColor whiteColor];
        self.navgation.frame = CGRectMake(frame.origin.x, 0, self.width, 64);
        UILabel *titleLabel= [[UILabel alloc]init];
        titleLabel.text = @"筛选";
        titleLabel.frame = CGRectMake(0, 20, self.width, 44);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        [self.navgation addSubview:titleLabel];
        UIButton *chongzhi  = [UIButton buttonWithType:UIButtonTypeCustom];
        chongzhi.frame = CGRectMake(self.width-58, 20, 58, 44);
        [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
        [chongzhi setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
        chongzhi.titleLabel.font = [UIFont systemFontOfSize:14];
        [chongzhi addTarget:self action:@selector(chongzhi:) forControlEvents:UIControlEventTouchUpInside];
        [self.navgation addSubview:chongzhi];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
        [self.navgation addSubview:line];
        CGFloat tableViewHeight = frame.size.height;
        CGRect tableViewRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, HCSCREEN_HEIGHT);
        self.mainSelectView = [[UIView alloc]initWithFrame:tableViewRect];
        self.mainSelectView.backgroundColor = [UIColor whiteColor];
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,HCSCREEN_WIDTH- tableViewRect.size.width, HCSCREEN_HEIGHT)];
        self.gapView.backgroundColor = UIColorFromRGBValue(0x000000);
        self.gapView.alpha = 0.6;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, HCSCREEN_WIDTH, tableViewHeight-113)];
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.mainTableView.dataSource = self;
        self.mainTableView.delegate = self;
        self.mainTableView.separatorColor= UIColorFromRGBValue(0xe0e0e0);
        [self.mainSelectView addSubview:self.mainTableView];///后头加的,为了下面的button
        self.mSuperView = superView;
        if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        _mView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mainTableView.bottom, HCSCREEN_WIDTH, 49)];
        _mView.layer.borderColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:0.40f].CGColor;
        _mView.backgroundColor = [UIColor whiteColor];
        [self.mainSelectView addSubview:_mView];
        [[_mView layer] setShadowOffset:CGSizeMake(1, 1)];
        [[_mView layer] setShadowRadius:3];
        [[_mView layer] setShadowOpacity:1];
        [[_mView layer] setShadowColor:[UIColor lightGrayColor].CGColor];
        [self AddUIbutton:_mView];
    
        

       [self performSelector:@selector(delayMethod) withObject: nil afterDelay:1.0f];
    }
    return self;
}
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
}
- (void)delayMethod {
    [self requestNum];
}

- (void)AddUIbutton:(UIView *)view{
    
    self.vehicleNumlabel = [[UILabel alloc]init];
    self.vehicleNumlabel.frame = CGRectMake(0, 0, HCSCREEN_WIDTH*0.61, 49);
    self.vehicleNumlabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.vehicleNumlabel];
    UIButton *makeSure = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSure.frame = CGRectMake(self.vehicleNumlabel.right, 0, HCSCREEN_WIDTH*0.24, 49);
    makeSure.backgroundColor = PRICE_STY_CORLOR;
    makeSure.titleLabel.font = [UIFont systemFontOfSize:16];
    [makeSure addTarget:self action:@selector(makesurevehicle:) forControlEvents:UIControlEventTouchUpInside];
    [makeSure setTitle:@"查看" forState:UIControlStateNormal];
    //_chongzhi = [UIButton TwoButtoFrame:CGRectMake(10,18,HCSCREEN_WIDTH/4.5,36) title:@"重置" titleColor:PRICE_STY_CORLOR backColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:13] target:self action:@selector(chongzhi:) tag:0];
    //_mSure = [UIButton TwoButtoFrame:CGRectMake(_chongzhi.right+5,18,HCSCREEN_WIDTH-_chongzhi.width-25,36) title:@"" titleColor:[UIColor whiteColor] backColor:PRICE_STY_CORLOR titleFont:[UIFont systemFontOfSize:13] target:self action:@selector(mSure:) tag:0];
    [view addSubview:makeSure];
}

/**
 *  <#Description#>
 */

- (void)getCondValuesFromDatafilter:(DataFilter*)datafilter{
     [self.vehicleNumDic removeAllObjects];
    self.customAge = datafilter.ageCond;
    
    self.customMile = datafilter.milesCond;
    
    self.customGear = datafilter.gearboxCond;
    
    self.customStandar = datafilter.emissionStandarCond;
    
    self.customStruct = datafilter.structureCond;
    
    self.customEmission = datafilter.emissionCond;
    
    self.coustomColor = datafilter.colorCond;
    
    self.coustomCountry = datafilter.countyrCond;
    [self setrequestnumdict];
    [self.mainTableView reloadData];
    [self requestNum];
 
}

- (void)setrequestnumdict{
    [self.vehicleNumDic setObject:self.customAge forKey:@"车龄"];
    [self.vehicleNumDic setObject:self.customMile forKey:@"里程"];
    [self.vehicleNumDic setObject:self.customStruct forKey:@"车身结构"];
    [self.vehicleNumDic setObject:self.coustomCountry forKey:@"国别"];
    [self.vehicleNumDic setObject:self.customGear forKey:@"变速箱"];
    [self.vehicleNumDic setObject:self.customStandar forKey:@"排放标准"];
    [self.vehicleNumDic setObject:self.coustomColor forKey:@"车身颜色"];
    [self.vehicleNumDic setObject:self.customEmission forKey:@"排量"];
}
//重置
- (void)chongzhi:(UIButton *)btn
{
    
    self.customAge=[[AgeCond getAgeCondData]HCObjectAtIndex:0];
    
    self.customMile = [[MilesCond getMilesCondData]HCObjectAtIndex:0];
    
    self.customGear = [[GearboxCond getGearboxCondData]HCObjectAtIndex:0];
    
    self.customStandar = [[EmissionStandarCond getEmissionStandarCondData]HCObjectAtIndex:0];
    
    self.customStruct = [[StructureCond getSturctureCondData]HCObjectAtIndex:0];
    
    self.customEmission = [[EmissionCond getEmissionCondData]HCObjectAtIndex:0];
    
    self.coustomColor = [[ColorCond getColorCondData]objectAtIndex:0];
    
    self.coustomCountry = [[CountryCond getCountryCondData]objectAtIndex:0];
    [self setrequestnumdict];
    [self.mainTableView reloadData];
    [self requestNum];
}


//筛选完成
- (void)makesurevehicle:(UIButton *)btn
{
    [self hide:NO];
    [self getValuesFrom:self.vehicleNumDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
    if (self.delegate) {
        [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:self.filterCondDic];
    }

}


- (void)getValuesFrom:(NSDictionary*)dict{
    [self.filterCondDic setObject:[dict objectForKey:@"车龄"] forKey:@"车龄"];
    [self.filterCondDic setObject:[dict objectForKey:@"里程"] forKey:@"里程"];
    [self.filterCondDic setObject:[dict objectForKey:@"车身结构"] forKey:@"车身结构"];
    [self.filterCondDic setObject:[dict objectForKey:@"国别"] forKey:@"国别"];
    [self.filterCondDic setObject:[dict objectForKey:@"变速箱"] forKey:@"变速箱"];
    [self.filterCondDic setObject:[dict objectForKey:@"排放标准"] forKey:@"排放标准"];
    [self.filterCondDic setObject:[dict objectForKey:@"车身颜色"] forKey:@"车身颜色"];
    [self.filterCondDic setObject:[dict objectForKey:@"排量"] forKey:@"排量"];
    
    
}
- (void)requestNum{
    if (self.numDelegate) {
        [self.numDelegate requestvehicleNum:self.vehicleNumDic];
    }
}

- (void)resetVehicleNum:(NSInteger)num{
    if (num!=-1) {
        self.vehicleNumlabel.attributedText = [NSString setselectVehicleNum:[NSString stringWithFormat:@"为您找到%ld辆车",(long)num]];
    }else{
        self.vehicleNumlabel.attributedText = [NSString setselectVehicleNum:@"为您找到0辆车"];
    }
}

- (void)resetData:(NSDictionary *)dict
{
    self.filterCondDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    self.vehicleNumDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [self getCustomCondFromDict:dict];
    [self hide:NO];
    [self.mainTableView reloadData];
}

- (void)getCustomCondFromDict:(NSDictionary*)dict{
    self.customGear = [dict objectForKey:@"变速箱"];
    self.customStruct = [dict objectForKey:@"车身结构"];
    self.customAge = [dict objectForKey:@"车龄"];
    self.customMile = [dict objectForKey:@"里程"];
    self.customEmission = [dict objectForKey:@"排量"];
    self.customStandar = [dict objectForKey:@"排放标准"];
    self.coustomCountry = [dict objectForKey:@"国别"];
    self.coustomColor = [dict objectForKey:@"车身颜色"];
}
- (void)show
{
    self.mainSelectView.alpha = 1.0;
    self.gapView.alpha = 0.5;
    [self.mSuperView addSubview:self.mainSelectView];
    [self.mSuperView addSubview:self.gapView];
    [self.mSuperView addSubview:self.navgation];
    //[self requestNum];
    //[self.mainTableView reloadData];
}

- (void)hide:(BOOL)animate;
{
    CGRect rect = self.mainSelectView.frame;
    CGRect oldRect = rect;
    rect.size.height = 0;
    if (!animate) {
        [self.mainSelectView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.mainSelectView.alpha = 0.2;
        self.mainSelectView.frame = rect;
    }completion:^(BOOL finished) {
        [self.mainSelectView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        self.mainSelectView.frame = oldRect;
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 304;
    }else if (indexPath.row == 1){
        return 133;
    }else if (indexPath.row == 4){
        if (_emissionStandShow == YES) {
            return 91;
        }else{
            return 44;
        }
    }else if(indexPath.row == 5){
        if (_emissionShow == YES) {
            return 133;
        }else{
            return 44;
        }
    }else if(indexPath.row == 3){
        if (_SructCellShow == YES) {
            return 91;
        }else{
            return 44;
        }
    }else if(indexPath.row==2){
        return 133;
    }else if(indexPath.row==7){
        if (_colorShow == YES) {
            return 217;
        }else{
            return 44;
        }
    }else{
        if (_countryShow == YES) {
            return 217;
        }else{
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *cellid = @"StructureCell";
        HCOtherSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            
            NSArray *structArray = [StructureCond getSturctureCondData];
            cell = [[HCOtherSelectCell alloc]initWithStruCond:structArray withTitle:@"车身结构" withreuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.customStruct isValid]) {
            [cell resetCondBtnColor];
        }else{
            [cell setSelectStruCond:self.customStruct];
        }
        
        return cell;
    }else if (indexPath.row == 1) {
        NSString *cellid = @"AgeCell";
        HCOtherSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {

            
            NSArray *ageArray = [AgeCond getAgeCondData];
            cell = [[HCOtherSelectCell alloc]initWithCondArray:ageArray withTitle:@"车龄" withreuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.customAge isValid]) {
            [cell resetCondBtnColor];
        }else{
            [cell setSelectCond:self.customAge];
        }

        return cell;
        //[self BJRangeSliderWithProgress:self.sliderMiles and:cell  delegate:2];
    }else if (indexPath.row == 2) {
        NSString *cellid = @"MliesCell";
        HCOtherSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            //NSRange range = NSMakeRange(1, [MilesCond getMilesCondData].count-1);
            NSArray *milesArray = [MilesCond getMilesCondData];
            cell = [[HCOtherSelectCell alloc]initWithCondArray:milesArray withTitle:@"里程" withreuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.customMile isValid]) {
            [cell resetCondBtnColor];
        }else{
             [cell setSelectCond:self.customMile];
        }
        return cell;
    }else if (indexPath.row == 3){
        NSString *cellid = @"GearBoxCell";
        HCOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
          
            NSArray *milesArray = [GearboxCond getGearboxCondData];
            cell = [[HCOtherCell alloc]initWithCondArray:milesArray withTitle:@"变速箱" type:0 withReuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightBth addTarget:self action:@selector(structBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.customGear isValid]) {
            [cell resetCondBtnState];
            [cell.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
            [cell.rightBth setTitle:@"不限" forState:UIControlStateNormal];
        }else{
            [cell setSelectCond:self.customGear];
            [cell.rightBth setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            [cell.rightBth setTitle:self.customGear.desc forState:UIControlStateNormal];
        }
        if (_SructCellShow == YES) {
            cell.rightImage.image = [UIImage imageNamed:@"pullup"];
            cell.mainView.hidden = NO;
        }else{
            cell.rightImage.image = [UIImage imageNamed:@"pulldown"];
            cell.mainView.hidden = YES;
        }
        return cell;
    }else if (indexPath.row == 4){
        NSString *cellid = @"EmissionStandarBoxCell";
        HCOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            NSArray *milesArray = [EmissionStandarCond getEmissionStandarCondData] ;
            cell = [[HCOtherCell alloc]initWithCondArray:milesArray withTitle:@"排放标准" type:0 withReuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightBth addTarget:self action:@selector(emissionStandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            cell.delegate =self;
        }
        if (![self.customStandar isValid]) {
            [cell resetCondBtnState];
            [cell.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
            [cell.rightBth setTitle:@"不限" forState:UIControlStateNormal];
        }else{
            [cell setSelectCond:self.customStandar];
             [cell.rightBth setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            [cell.rightBth setTitle:self.customStandar.desc forState:UIControlStateNormal];
        }
        if (_emissionStandShow == YES) {
            cell.rightImage.image = [UIImage imageNamed:@"pullup"];
            cell.mainView.hidden = NO;
        }else{
            cell.rightImage.image = [UIImage imageNamed:@"pulldown"];
            cell.mainView.hidden = YES;
        }
        return cell;

    }else if (indexPath.row==5){
        NSString *cellid = @"EmissionCell";
        HCOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {

            NSArray *milesArray = [EmissionCond getEmissionCondData];
            cell = [[HCOtherCell alloc]initWithCondArray:milesArray withTitle:@"排量" type:0 withReuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightBth addTarget:self action:@selector(emissionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            }
        if (![self.customEmission isValid]) {
            [cell resetCondBtnState];
            [cell.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
             [cell.rightBth setTitle:@"不限" forState:UIControlStateNormal];
        }else{
            [cell setSelectCond:self.customEmission];
             [cell.rightBth setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            [cell.rightBth setTitle:self.customEmission.desc forState:UIControlStateNormal];
        }
        if (_emissionShow == YES) {
            cell.rightImage.image = [UIImage imageNamed:@"pullup"];
            cell.mainView.hidden = NO;
        }else{
            cell.rightImage.image = [UIImage imageNamed:@"pulldown"];
            cell.mainView.hidden = YES;
        }
        
        return cell;
    }else if (indexPath.row==6){
        NSString *cellid = @"CountryCell";
        HCOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            //NSRange range = NSMakeRange(0, [CountryCond getCountryCondData].count);
            NSArray *countryArray = [CountryCond getCountryCondData];
            cell = [[HCOtherCell alloc]initWithCondArray:countryArray withTitle:@"国别" type:2 withReuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightBth addTarget:self action:@selector(countryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.coustomCountry isValid]) {
            [cell resetCondBtnState];
            [cell.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
            [cell.rightBth setTitle:@"不限" forState:UIControlStateNormal];
        }else{
            [cell setSelectCond:self.coustomCountry];
             [cell.rightBth setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            [cell.rightBth setTitle:self.coustomCountry.desc forState:UIControlStateNormal];
        }
        
        if (_countryShow == YES) {
            if (_countrySlider == YES) {
                [self.mainTableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionNone animated:                                                                                                                      YES];
                _countrySlider = NO;
            }
            cell.rightImage.image = [UIImage imageNamed:@"pullup"];
            cell.mainView.hidden = NO;
        }else{
            
            cell.rightImage.image = [UIImage imageNamed:@"pulldown"];
            cell.mainView.hidden = YES;
        }
        
        return cell;
    }else if (indexPath.row==7){
        NSString *cellid = @"ColorCell";
        HCOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            NSArray *milesArray = [ColorCond getColorCondData];
             cell = [[HCOtherCell alloc]initWithCondArray:milesArray withTitle:@"车身颜色" type:1 withReuseid:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.rightBth addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate =self;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (![self.coustomColor isValid]) {
            [cell resetCondBtnState];
            [cell.rightBth setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
            [cell.rightBth setTitle:@"不限" forState:UIControlStateNormal];
        }else{
            [cell setSelectCond:self.coustomColor];
            [cell.rightBth setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
            [cell.rightBth setTitle:self.coustomColor.desc forState:UIControlStateNormal];
        }
      
        if (_colorShow == YES) {
            if (_colorSlider == YES) {
                [self.mainTableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionNone animated:YES];
                _colorSlider = NO;
            }
            cell.rightImage.image = [UIImage imageNamed:@"pullup"];
            cell.mainView.hidden = NO;
        }else{
            cell.rightImage.image = [UIImage imageNamed:@"pulldown"];
            cell.mainView.hidden = YES;
        }
        return cell;
    }

    return nil;
}
- (void)countryBtnClick:(UIButton*)btn{
   
    if (_countryShow == YES) {
        _countryShow =NO;
    }else{
        _countrySlider = YES;
        _countryShow =YES;
    }
    [self.mainTableView reloadData];
    
}
- (void)colorBtnClick:(UIButton*)btn{
    
    if (_colorShow == YES) {
        _colorShow =NO;
    }else{
        _colorSlider = YES;
        _colorShow =YES;
       
        
    }
   [self.mainTableView reloadData];
}
- (void)emissionBtnClick:(UIButton*)btn{
    if (_emissionShow == YES) {
        _emissionShow =NO;
    }else{
        
        _emissionShow =YES;
    }
    [self.mainTableView reloadData];
}
- (void)emissionStandBtnClick:(UIButton*)btn{
    if (_emissionStandShow == YES) {
        _emissionStandShow =NO;
    }else{
        
        _emissionStandShow =YES;
    }
    [self.mainTableView reloadData];
        
        
}
- (void)structBtnClick:(UIButton*)btn{
    if (_SructCellShow == YES) {
        _SructCellShow =NO;
    }else{
        _SructCellShow =YES;
    }
    [self.mainTableView reloadData];
    
}

-(void)cellBtnClick:(id)cond{
    if ([cond isKindOfClass:[AgeCond class]]) {
        self.customAge =  (AgeCond *)cond;
        [self.vehicleNumDic setObject:self.customAge forKey:@"车龄"];
        
    }
    if ([cond isKindOfClass:[MilesCond class]]) {
        self.customMile =(MilesCond *)cond;
         [self.vehicleNumDic setObject:self.customMile forKey:@"里程"];
    }
    if ([cond isKindOfClass:[StructureCond class]]) {
        self.customStruct =(StructureCond *)cond;
         [self.vehicleNumDic setObject:self.customStruct forKey:@"车身结构"];
    }
    [self.mainTableView reloadData];
    [self requestNum];
}

- (void)cellcolorClick:(id)cond{
    
    if ([cond isKindOfClass:[CountryCond class]]){
        self.coustomCountry = (CountryCond *)cond;
        [self.vehicleNumDic setObject:self.coustomCountry forKey:@"国别"];
    }
    if ([cond isKindOfClass:[ColorCond class]]){
        self.coustomColor = (ColorCond *)cond;
        [self.vehicleNumDic setObject:self.coustomColor forKey:@"车身颜色"];
    }
    [self.mainTableView reloadData];
    [self requestNum];
}
- (void)othercellBtnClick:(id)cond{
    if ([cond isKindOfClass:[GearboxCond class]]){
        self.customGear = (GearboxCond *)cond;
        [self.vehicleNumDic setObject:self.customGear forKey:@"变速箱"];
    }
    if ([cond isKindOfClass:[EmissionStandarCond class]]) {
        self.customStandar = (EmissionStandarCond *)cond;
        [self.vehicleNumDic setObject:self.customStandar forKey:@"排放标准"];
    }
    if ([cond isKindOfClass:[EmissionCond class]]) {
        self.customEmission = (EmissionCond *)cond;
        [self.vehicleNumDic setObject:self.customEmission forKey:@"排量"];
    }
    [self.mainTableView reloadData];
    [self requestNum];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

//- (NSString *)getTextFromMainIdx:(NSInteger)mainIdx subIdx:(NSInteger)subIdx
//{
//    id data = [[[self.data objectAtIndex:mainIdx] objectAtIndex:1] objectAtIndex:subIdx];
//    switch (mainIdx) {
//        case 0:
//            return ((AgeCond *)data).desc;
//        case 1:
//            return ((GearboxCond *)data).desc;
//        case 2:
//            return ((EmissionCond *)data).desc;
//        case 3:
//            return ((MilesCond *)data).desc;
//        case 4:
//            return ((StructureCond *)data).desc;
//        case 5:
//            return ((EmissionStandarCond *)data).desc;
//        default:
//            break;
//    }
//    return  @"";
//}


@end
