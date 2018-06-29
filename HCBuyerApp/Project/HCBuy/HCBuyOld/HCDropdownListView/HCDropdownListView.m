//
//  HCDropdownListView.m
//  HCBuyerApp
//
//  Created by wj on 15/5/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCDropdownListView.h"
#import "DataFilter.h"
#import "HCPriceCell.h"

#import "VehicleListViewController.h"

@interface HCDropdownListView()<BJRangeSliderWithProgressDemoViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *gapView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic) NSInteger selectedIdx;
@property (nonatomic, strong) PriceCond *customPriceCond;
@property (nonatomic, strong) PriceCond *sliderPriceCond;
@property (nonatomic, strong) UIView *navgation;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) NSInteger type; //type =0 排序条件 =1 价格
@property (nonatomic)BOOL hideBtn;
@property (nonatomic, strong)UILabel *customPriceLabel;
@end



@implementation HCDropdownListView

//static NSInteger allVehicle= 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView typeEnum:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _max = 1000;
        self.backgroundColor = [UIColor whiteColor];
        self.navgation= [[UIView alloc]init];
        self.navgation.backgroundColor = [UIColor whiteColor];
        self.navgation.frame = CGRectMake(frame.origin.x, 0, self.width, 64);
        UILabel *titleLabel= [[UILabel alloc]init];
        titleLabel.text = @"价格";
        titleLabel.frame = CGRectMake(0, 20, self.width, 44);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        [self.navgation addSubview:titleLabel];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
        [self.navgation addSubview:line];
        //计算tableview高度
        //CGFloat tableViewHeight = HCSCREEN_WIDTH*0.84;
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HomePriceCurDx:) name:@"HomePriceCurDx" object:nil];
       
        CGRect tableViewRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, HCSCREEN_HEIGHT);
        self.bgView = [[UIView alloc]init];
        self.bgView.frame = tableViewRect;
        self.bgView.backgroundColor = MTABLEBACK;
        //self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
       // self.bgView.layer.shadowOpacity = 0.0;
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,HCSCREEN_WIDTH- tableViewRect.size.width, HCSCREEN_HEIGHT)];
        self.gapView.backgroundColor = UIColorFromRGBValue(0x000000);
        self.gapView.alpha = 0.6;
        UIPanGestureRecognizer *bgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewPan:)];
        [self.bgView addGestureRecognizer:bgPan];
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
         self.data = data;
        PriceCond *selectcond = [self.data objectAtIndex:0];
        self.customPriceCond = selectcond;
        self.mSuperView = superView;
        CGRect tableRect = CGRectMake(0, 64, frame.size.width, HCSCREEN_HEIGHT-66);
        [self createTableViewFrame:tableRect];
         self.type = type;
//        CGFloat lineX;
//        if (HCSCREEN_WIDTH>320) {
//            lineX =self.bgView.height/2;
//        }else{
//            lineX= self.bgView.height/1.8;
//        }
    }
    return self;
}
- (void)createTableViewFrame:(CGRect)frame{
    self.mTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mTableView   setSeparatorColor:UIColorFromRGBValue(0xe0e0e0)];  //设置分割线为蓝色
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = MTABLEBACK;
    _hideBtn = YES;
    self.mTableView.tableFooterView = [[UIView alloc]init];
    if ([self.mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.bgView addSubview:self.mTableView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *array = [tableView visibleCells];
    

    if (indexPath.section==0) {
        return;
    }else if (indexPath.section==1){
        PriceCond *selectcond = [self.data objectAtIndex:0];
        HCPriceCell *cell = (HCPriceCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.customPriceCond = selectcond;
        for (HCPriceCell *cell in array)
        {
            cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
            cell.selectView.hidden = YES;
        }
        cell.textLabel.textColor = PRICE_STY_CORLOR;
        cell.selectView.hidden = NO;
      [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:selectcond];
    }else {
        
        PriceCond *selectcond = [self.data objectAtIndex:indexPath.row+1];
        self.customPriceCond = selectcond;
        HCPriceCell *cell = (HCPriceCell*)[tableView cellForRowAtIndexPath:indexPath];
        for (HCPriceCell *cell in array)
        {
            cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
            cell.selectView.hidden = YES;
        }
        cell.textLabel.textColor = PRICE_STY_CORLOR;
        cell.selectView.hidden = NO;
       
       [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:selectcond];
    }
    [self emptyPr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else{
        return self.data.count-1;
    }

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
      return [self customHeaderViewWithTitle:@"自定义价格"];
    }else if (section==1){
      return [self customHeaderViewWithTitle:@"#"];
    }else{
        return [self customHeaderViewWithTitle:@"选择价格"];;
    }
  
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (_hideBtn == YES) {
            return 100;
        }else{
            return 135;
        }
    }else{
        return 44;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
         HCPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell"];
            if (cell == nil) {
                cell = [[HCPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sliderCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.slider = [[BJRangeSliderWithProgress alloc]initWithFrame:CGRectMake(0, 10, HCSCREEN_WIDTH*0.85,70)];
                [self emptyPr];
                self.slider.delegate = self;
                [cell addSubview:self.slider];
                cell.accessoryType = UITableViewCellAccessoryNone;
                _button = [UIButton buttonWithType:UIButtonTypeCustom];
                _button.backgroundColor = PRICE_STY_CORLOR;
                _button.frame = CGRectMake((HCSCREEN_WIDTH*0.85-HCSCREEN_WIDTH/5)/2, self.slider.bottom+10, HCSCREEN_WIDTH/5, HCSCREEN_WIDTH/12);
                [_button setTitle:@"确定" forState:UIControlStateNormal];
                _button.titleLabel.font = [UIFont systemFontOfSize:15];
                _button.hidden = YES;
                _hideBtn = YES;
                [_button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_button];
            }
            return cell;
    }else if (indexPath.section==1){
        PriceCond *price = [self.data objectAtIndex:0];
        HCPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"none"];
            if (cell == nil) {
                cell = [[HCPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
            }
            if ([price isEqual:self.customPriceCond]) {
                cell.selectView.hidden = NO;
                cell.textLabel.textColor = PRICE_STY_CORLOR;
            }else{
                cell.selectView.hidden = YES;
                cell.textLabel.textColor =  UIColorFromRGBValue(0x424242);
            }
            cell.textLabel.text =  price.desc;
            return cell;
    }else{
        HCPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pricecell"];
        
        PriceCond *price = [self.data objectAtIndex:indexPath.row+1];
            if (cell == nil) {
                cell = [[HCPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pricecell"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
            }
            if ([price isEqual:self.customPriceCond]) {
                cell.selectView.hidden = NO;
                cell.textLabel.textColor = PRICE_STY_CORLOR;
            }else{
                cell.selectView.hidden = YES;
                cell.textLabel.textColor =  UIColorFromRGBValue(0x424242);
            }
            cell.textLabel.text =  price.desc;
            return cell;
    }
    return nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
}

- (void)bgViewPan:(UITapGestureRecognizer *)tap{
    if (tap.state ==UIGestureRecognizerStateBegan) {
        NSLog(@"开始滑动");
    }else if(tap.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束滑动");
    }
}

- (void)emptyPr
{
    self.slider.maxValue = 35;
    self.slider.rightValue = 35;
    self.slider.leftValue = 0;
    _min = 0;
    _max = 1000;
//    self.slider.lablePriceMin.text = @"0";
//    self.slider.LablePriceMax.text = @"不限";
}

- (void)maxString:(NSString *)str{
    
     _max = [str intValue];
    if (_max == 1000 || _max == 0) {
        _max = 1000;
    }
    [self maxFromTo];
}


- (void)maxFromTo
{
    if (!self.sliderPriceCond) {
        self.sliderPriceCond = [[PriceCond alloc]init];
    }
    
    if (_min == 0 && _max == 1000) {
        [self.sliderPriceCond setPriceFrom:-1];
        [self.sliderPriceCond setPriceTo:-1];
    }else{
        [self.sliderPriceCond setPriceFrom:_min];
        [self.sliderPriceCond setPriceTo:_max];
    }
    
  // self.slider.customPriceInfo.text = [NSString stringWithFormat:@"%d~%d万",_min,_max];
    [self hidden];
}

- (void)Nsstring:(NSString *)str{
    
    _min = [str intValue];
    [self maxFromTo];
}

- (void)hidden
{
    if (_min == 0 && _max == 1000)  {
         _button.hidden = YES;
        _hideBtn = YES;
    }else{
        _button.hidden = NO;
        _hideBtn = NO;
    }
    [self.mTableView reloadData];
}


//确定
- (void)btnclick:(UIButton *)btn
{
    self.customPriceCond = [self.data objectAtIndex:0];
    [self.mTableView reloadData];
    if (self.delegate) {
       [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:self.sliderPriceCond];
    }
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
    
}


////将选中状态设置为当前的idx
- (void)resetData:(NSInteger)idx
{
    //self.data = [PriceCond getPriceCondData];
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
    self.selectedIdx = idx;
    self.customPriceCond = [self.data objectAtIndex:idx];
   // [self emptyPr];
    [self.mTableView reloadData];
    
}

- (void)show
{
    self.gapView.alpha = 0.5;
    [self.mSuperView addSubview:self.gapView];
    [self.mSuperView addSubview:self.bgView];
    [self.mSuperView addSubview:self.navgation];
}

- (void)hide:(BOOL)animate;
{
    CGRect rect = self.bgView.frame;
    CGRect oldRect = rect;
    rect.size.height = 0;
    if (!animate) {
        [self.bgView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.gapView.alpha = 0.3f;
        self.bgView.frame = rect;
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        self.bgView.frame = oldRect;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
