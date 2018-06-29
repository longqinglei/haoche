 //
//  CityViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/1/4.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "CityViewController.h"
#import "BizCity.h"
static CityViewController *citySelectView;
@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)NSInteger tagBtnClick;
@property (nonatomic)NSInteger cityId;
@property (nonatomic,strong)NSMutableArray *buttonArr;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)CityElem *recommendCitys;



@end

@implementation CityViewController

+(CityViewController*)shareCity
{
    if (citySelectView==nil) {
        citySelectView = [[self alloc]init];
    }
    return citySelectView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#define FONT [UIFont systemFontOfSize:15]

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_buttonArr==nil) {
        _buttonArr = [[NSMutableArray alloc]init];
    }
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 50)];
    mView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mView];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/10, mView.bottom-0.5, HCSCREEN_WIDTH-HCSCREEN_WIDTH/5, 0.5)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    viewLine.alpha = 0.5;
    [mView addSubview:viewLine];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(HCSCREEN_WIDTH/9, 0, HCSCREEN_WIDTH/4, mView.height) text:@"推荐城市" textColor:[UIColor darkGrayColor] font:FONT tag:0 hasShadow:NO isCenter:NO];
    [mView addSubview:label];
    mView.userInteractionEnabled = YES;
    
    self.cityName = [[UILabel alloc]initWithFrame:CGRectMake(label.right+20, 0, HCSCREEN_WIDTH/4, mView.height)];
    self.cityName.textColor = [UIColor lightGrayColor];
    self.cityName.font = [UIFont systemFontOfSize:15];
    self.cityName.userInteractionEnabled = YES;
    UITapGestureRecognizer* sortBgRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recommendCityClick)];
    [self.cityName addGestureRecognizer:sortBgRecognizer];
    [mView addSubview:self.cityName];
    self.mTavleView =[[UITableView alloc]initWithFrame:CGRectMake(0, mView.bottom, HCSCREEN_WIDTH, _arrayHeight)];
    self.mTavleView.separatorStyle = UITableViewStylePlain;
    
    
    UILabel *labelkaiTong = [UILabel labelWithFrame:CGRectMake(0, self.mTavleView.bottom, HCSCREEN_WIDTH, 60) text:@"其他城市陆续开通中" textColor:[UIColor lightGrayColor] font:FONT tag:0 hasShadow:NO isCenter:YES];
    labelkaiTong.tag = 111;
    labelkaiTong.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelkaiTong];
    self.mTavleView.delegate = self;
    self.mTavleView.dataSource = self;
    [self.view addSubview:self.mTavleView];

    [self getRecommendCity];
}

- (void)getRecommendCity
{
    if ([BizCity getRecommendCity] != nil)
    {
        self.recommendCitys = [BizCity getRecommendCity];
        self.cityName.text = self.recommendCitys.cityName;
        if ([BizCity getCurCity].cityId==self.recommendCitys.cityId) {
            self.cityName.textColor = PRICE_STY_CORLOR;
        }else{
            self.cityName.textColor = UIColorFromRGBValue(0x666666);
        }
    }else{
        self.cityName.text = @"未知";
        self.cityName.textColor = UIColorFromRGBValue(0x666666);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadVIew
{
    [self.mTavleView reloadData];
    [self.mTavleView setHeight:_arrayHeight];
    UILabel *label = (UILabel *)[self.view viewWithTag:111];
    [label setTop:self.mTavleView.bottom];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_arrayData.count > 0)
    {
        return _arrayHeight ;
    }else{
         return 100;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (void)button:(UITableViewCell *)cell
{
    //_arrayData = [[NSArray alloc]init];
    for (int i= 0; i<_arrayData.count; i++) {
    NSString *title = ((CityElem *)[_arrayData HCObjectAtIndex:i]).cityName;
    CGFloat wSpace = HCSCREEN_WIDTH/3;
    UIButton *cityBtn = [UIButton buttonWithFrame:CGRectMake((i%3)*wSpace,(i/3)*HCSCREEN_HEIGHT/10, HCSCREEN_WIDTH/3, HCSCREEN_HEIGHT/10) title:title titleColor:UIColorFromRGBValue(0x666666) bgColor:nil titleFont:[UIFont systemFontOfSize:15] image:nil selectImage:nil target:self action:@selector(btnClick:) tag:200+i];
        if (((CityElem *)[_arrayData HCObjectAtIndex:i]).cityId==[BizCity getCurCity].cityId) {
            cityBtn.selected = YES;
            self.selectBtn = cityBtn;
            [cityBtn setTitleColor:PRICE_STY_CORLOR forState:UIControlStateSelected];
        }else{
            cityBtn.selected = NO;
        }
        [_buttonArr addObject:cityBtn];
        [cell.contentView addSubview:cityBtn];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"UITableViewCell";
    UITableViewCell *cityCell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cityCell) {
        cityCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self button:cityCell];
    return cityCell;
}

- (void)btnClick:(UIButton *)btn
{
    self.selectBtn = btn;
    self.cityName.textColor = UIColorFromRGBValue(0x666666);
    CityElem *selectCity = [_arrayData HCObjectAtIndex:btn.tag-200];
    [BizCity saveSelectedCity:selectCity];
    for (UIButton *select in _buttonArr) {
        if (select != self.selectBtn) {
            select.selected =NO;
           [select setTitleColor:UIColorFromRGBValue(0x666666)forState:UIControlStateNormal];
        }else{
            select.selected =YES;
            [select setTitleColor:PRICE_STY_CORLOR forState:UIControlStateSelected];
        }
    }
    if (selectCity.cityId == self.recommendCitys.cityId) {
        self.cityName.textColor = PRICE_STY_CORLOR;

    }else{
         self.cityName.textColor = UIColorFromRGBValue(0x666666);
    }
    
    [self.delegate pushViewController:btn.tag CityName:selectCity.cityName CityId:selectCity.cityId];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:selectCity forKey:@"city"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:param];
}
- (void)resetCityColor:(NSInteger)cityid{
    NSString *cityName = [City getCityNameById:cityid];
    for (UIButton *select in _buttonArr) {
        if ([select.titleLabel.text isEqualToString:cityName]) {
            select.selected =YES;
            [select setTitleColor:PRICE_STY_CORLOR forState:UIControlStateSelected];
        }else{
            select.selected =NO;
            [select setTitleColor:UIColorFromRGBValue(0x666666)forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)recommendCityClick
{
    if ([BizCity getRecommendCity] != nil) {
        self.cityName.textColor = PRICE_STY_CORLOR;
        CityElem *selectCity = self.recommendCitys;
        if (selectCity!=nil) {
          [BizCity saveSelectedCity:selectCity];
        }
        for (UIButton *select in _buttonArr) {
            if ([select.titleLabel.text isEqualToString:selectCity.cityName]) {
            
                select.selected =YES;
                [select setTitleColor:PRICE_STY_CORLOR forState:UIControlStateSelected];
            }else{
                select.selected =NO;
                [select setTitleColor:UIColorFromRGBValue(0x666666)forState:UIControlStateNormal];
            }
        }
        [self.delegate pushViewController:0 CityName:selectCity.cityName CityId:selectCity.cityId];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        if (selectCity!=nil) {
            [param setObject:selectCity forKey:@"city"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:param];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
