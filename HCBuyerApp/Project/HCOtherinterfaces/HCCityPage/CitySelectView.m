//
//  CitySelectView.m
//  HCBuyerApp
//
//  Created by wj on 15/6/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "CitySelectView.h"
#import "BizCity.h"
#import "City.h"

#define HC_City_Cell_Width_Padding 15
#define HC_City_Cell_Btn_Height_Padding 10
#define HC_City_Cell_Height 45
#define HC_City_More_Cell_Height (HC_City_Cell_Height+5)
#define HC_City_Cell_Elem_Num 4.0f

@interface CitySelectView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) UIView *gapView;
@property (nonatomic, strong) UIView *mSuperView;

@property (nonatomic, strong) CityElem *recommendCity;

@property (nonatomic, strong) NSDictionary *cityData;

@end

@implementation CitySelectView

-(id)initWithFrame:(CGRect)frame forSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mSuperView = superView;
        self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)];
        self.cityTableView.delegate = self;
        self.cityTableView.dataSource = self;
        self.cityTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cityTableView.top + self.cityTableView.height, frame.size.width, frame.size.height - self.cityTableView.height)];
        
        self.gapView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
        
        self.cityData = [BizCity getCityListOrderedFromLocal];
        if ([self.cityData count] > 0) {
            //
            [self recomputeLayout];
        }
        
        self.recommendCity = nil;
        //从服务端更新数据
      //  [self updateCityData];
    }
    return self;
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self show:NO];
}

- (void)recomputeLayout
{
    //计算新的城市下拉列表的高度
    CGFloat height = HC_City_More_Cell_Height + HC_City_Cell_Height; //陆续开通中的高度 + 推荐城市
    NSArray *keyset = [self.cityData allKeys];
    for (NSString *k in keyset) {
        NSArray *arr = [self.cityData objectForKey:k];
        height += ceil([arr count]/ HC_City_Cell_Elem_Num) * HC_City_Cell_Height;
    }
    CGRect cityViewRect = self.cityTableView.frame;
    cityViewRect.size.height = height;
    if (cityViewRect.size.height > self.height) {
        cityViewRect.size.height = self.height;
    }
    CGRect gapViewRect = self.gapView.frame;
    gapViewRect.origin.y = cityViewRect.origin.y + cityViewRect.size.height;
    gapViewRect.size.height = self.frame.size.height - cityViewRect.size.height;
    if (gapViewRect.size.height < 0) gapViewRect.size.height = 0;
    
    self.cityTableView.frame = cityViewRect;
    self.gapView.frame = gapViewRect;
}

-(void)toggle
{
    if (self.cityTableView.superview == nil) {
        [self show:YES];
    } else {
        [self show:NO];
    }
}

- (void)show:(BOOL)isShow
{
    if (isShow) {
        self.gapView.alpha = 0.6;
        CGRect rect = self.cityTableView.frame;
        CGRect oldRect = rect;
        rect.size.height = 0;
        CGRect gapViewRect = self.gapView.frame;
        CGRect oldGapViewRect = gapViewRect;
        gapViewRect.origin.y -= oldRect.size.height;
        gapViewRect.size.height += oldRect.size.height;
        self.cityTableView.frame = rect;
        self.gapView.frame = gapViewRect;
        [self.mSuperView addSubview:self.gapView];
        [self.mSuperView addSubview:self.cityTableView];
        [UIView animateWithDuration:0.2 animations:^{
            self.gapView.alpha = 0.3f;
            self.cityTableView.alpha = 1.0f;
            self.cityTableView.frame = oldRect;
            self.gapView.frame = oldGapViewRect;
        } completion:^(BOOL finished) {
        }];
    }else{
        //暂时不添加动画效果   影响效率
        [self.cityTableView removeFromSuperview];
        [self.gapView removeFromSuperview];
        self.gapView.alpha = 0.3f;
    }
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //推荐定位城市
        return HC_City_Cell_Height;
    }
    if (indexPath.row == [[self.cityData allKeys] count] + 1) {
        return HC_City_More_Cell_Height;
    }
    NSString *key = [[self.cityData allKeys] HCObjectAtIndex:indexPath.row - 1];//allkey  可加也可以去掉
    NSInteger lines = ceil([[self.cityData objectForKey:key] count] / HC_City_Cell_Elem_Num);
    return lines * HC_City_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.recommendCity != nil) {
        //选择推荐城市
        CityElem *elem = self.recommendCity;
        NSLog(@"get city: %@", elem.cityName);
        //save
        [BizCity saveSelectedCity:elem];
        //广播通知
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:elem forKey:@"city"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:param];
        [self show:NO];
    }
}

#pragma mark -- UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cityData allKeys] count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示车源信息的cell
    UITableViewCell *cell = [self getTableViewCellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)getTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[self.cityData allKeys] count] + 1) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.width, HC_City_More_Cell_Height)];
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, HC_City_More_Cell_Height) text:@"其他城市陆续开通中..." textColor:ColorWithRGB(153, 153, 153) font:[UIFont systemFontOfSize:11] tag:0 hasShadow:NO isCenter:YES];
        [cell addSubview:label];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, HC_City_More_Cell_Height - 1, self.width, 1.0f)];
        [bottomLine setBackgroundColor:ColorWithRGB(221, 221, 221)];
        [cell addSubview:bottomLine];
        return cell;
    }
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.width, HC_City_More_Cell_Height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HC_City_Cell_Width_Padding, 0, self.width - 2 * HC_City_Cell_Width_Padding, HC_City_More_Cell_Height)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = ColorWithRGB(153, 153, 153);
        [label setText:[NSString stringWithFormat:@"当前推荐城市: %@", self.recommendCity == nil ? @"未知" : self.recommendCity.cityName]];
        [cell addSubview:label];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(HC_City_Cell_Width_Padding, HC_City_More_Cell_Height - 1, self.frame.size.width - 2 * HC_City_Cell_Width_Padding, 1.0f)];
        [bottomLine setBackgroundColor:ColorWithRGB(221, 221, 221)];
        [cell addSubview:bottomLine];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.width, HC_City_Cell_Height)];
    NSString *key = [[self.cityData allKeys] HCObjectAtIndex:indexPath.row - 1];
    NSArray *cities = [self.cityData objectForKey:key];
    CGFloat btn_width = (self.frame.size.width - HC_City_Cell_Width_Padding * 2 ) / (HC_City_Cell_Elem_Num + 1);
    CGFloat btn_height = HC_City_Cell_Height - 2 * HC_City_Cell_Btn_Height_Padding;
    NSInteger lines = ceil([cities count] / HC_City_Cell_Elem_Num);
    for (NSInteger i = 0; i < lines; ++i) {
        NSInteger minIdx = i * HC_City_Cell_Elem_Num;
        if (i == 0) {
            //放入区域数据
            CGFloat x = HC_City_Cell_Width_Padding;
            CGFloat y = HC_City_Cell_Btn_Height_Padding;
            UIButton *btn = [UIButton buttonWithFrame:CGRectMake(x, y, btn_width, btn_height) title:key  titleColor:ColorWithRGB(153, 153, 153) bgColor:nil titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:self action:@selector(cityBtnClick:) tag:-1];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [cell addSubview:btn];
        }
        NSInteger maxIdx = MIN((i + 1) * (NSInteger)HC_City_Cell_Elem_Num, [cities count]);
        for (NSInteger idx = minIdx; idx < maxIdx; ++idx) {
            CGFloat x = HC_City_Cell_Width_Padding  + btn_width +  btn_width * (idx % (NSInteger)HC_City_Cell_Elem_Num);
            CGFloat y =  (i * 2 + 1) * HC_City_Cell_Btn_Height_Padding + btn_height * i;
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, y, btn_width, btn_height);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            NSString *title = ((CityElem *)[cities HCObjectAtIndex:idx]).cityName;
            [btn setTitle:title forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //[btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [btn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = indexPath.row * 1000000 + idx;
            [cell addSubview:btn];
        }
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(HC_City_Cell_Width_Padding, lines * HC_City_Cell_Height - 0.5, self.frame.size.width - 2 * HC_City_Cell_Width_Padding, 0.5)];
    [bottomLine setBackgroundColor:ColorWithRGB(221, 221, 221)];
    [cell addSubview:bottomLine];
    return cell;
}

- (void)cityBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag >= 0) {
        NSInteger row = btn.tag / 1000000 - 1;
        NSInteger idx = btn.tag % 1000000;
        NSArray *keys = [self.cityData allKeys];
        if (row < [keys count]) {
            NSString *key = [keys HCObjectAtIndex:row];
            NSArray *cities = [self.cityData objectForKey:key];
            if (idx < [cities count]) {
                CityElem *elem = [cities HCObjectAtIndex:idx];
                NSLog(@"get city: %@", elem.cityName);  //筛选城市打印，暂时留着
                //save
                [BizCity saveSelectedCity:elem];
                //广播通知
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:elem forKey:@"city"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:param];
                [self show:NO];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
