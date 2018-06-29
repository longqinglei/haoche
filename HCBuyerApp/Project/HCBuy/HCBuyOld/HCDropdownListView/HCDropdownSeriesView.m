//
//  HCDropdownSeriesView.m
//  HCBuyerApp
//
//  Created by wj on 15/6/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCDropdownSeriesView.h"
#import "AutoSeries.h"
#import "DataFilter.h"

#define HC_Series_BrandRow_Height 80
#define HC_Series_Row_Height 50

#define HC_Series_Row_Width_Padding HCSCREEN_WIDTH * 0.093f

#define HC_Series_BackImag_Padding HCSCREEN_WIDTH * 0.03f

#define HC_Series_BrandImg_Height_Padding 20

@interface HCDropdownSeriesView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *gapView;

@property (nonatomic, strong) BrandSeries *data;
@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) BrandSeriesCond *cond;
@property (nonatomic,strong)UIView *navgation;
@property (nonatomic) NSInteger selectRowIdx;
@property (nonatomic) NSInteger selectSectionIdx;
@end

@implementation HCDropdownSeriesView


-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectRowIdx = -1;
        self.superView = superView;
        self.data = [[BrandSeries alloc] init];
        self.navgation= [[UIView alloc]init];
        self.navgation.backgroundColor = [UIColor whiteColor];
        self.navgation.frame = CGRectMake(frame.origin.x, 0, self.width, 64);
        UILabel *titleLabel= [[UILabel alloc]init];
        titleLabel.text = @"车系";
        titleLabel.frame = CGRectMake(0, 20, self.width, 44);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        [self.navgation addSubview:titleLabel];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
        [self.navgation addSubview:line];
        UIButton *chongzhi  = [UIButton buttonWithType:UIButtonTypeCustom];
        chongzhi.frame = CGRectMake(0, 20, 58, 44);
        [chongzhi setTitle:@"返回" forState:UIControlStateNormal];
        [chongzhi setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
        chongzhi.titleLabel.font = [UIFont systemFontOfSize:14];
        [chongzhi addTarget:self action:@selector(seriesBack:) forControlEvents:UIControlEventTouchUpInside];
        [self.navgation addSubview:chongzhi];

        self.cond = [[BrandSeriesCond alloc] init];
       // CGRectMake(frame.origin.x + x, frame.origin.y, frame.size.width - x, frame.size.height-48)
        self.mTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH*0.15, HCSCREEN_HEIGHT)];
        self.gapView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0];//[UIColor clearColor];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        UISwipeGestureRecognizer *gapRightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        [self.mTableView addGestureRecognizer:rightSwipe];
        [self.gapView addGestureRecognizer:gapRightSwipe];
    }
    return self;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self hide:YES];
    }
}


-(void)showWithBrandSeriesData:(BrandSeries *)data animate:(BOOL)animate isSelectedUnlimit:(BOOL)isSelectedUnlimit
{
    if (data != nil) {
        self.data = data;
    }
    if (isSelectedUnlimit) {
        self.selectRowIdx = 1;
        self.cond.brandId = self.data.brandId;
        self.cond.brandName = self.data.brandName;
        self.cond.seriesId = -1;
        self.cond.seriesName = @"";
    }
    [self.mTableView reloadData];
    
    if (!animate) {
        [self.superView addSubview:self.gapView];
        [self.superView addSubview:self.mTableView];
        [self.superView addSubview:self.navgation];
        return;
    }
    
    self.mTableView.alpha = 0.1;
    self.gapView.alpha = 0.1;
    CGRect rect = self.mTableView.frame;
    CGRect oldRect = rect;
    rect.origin.x = HCSCREEN_WIDTH;
    rect.size.width = 0;
    
    CGRect rect1 = self.navgation.frame;
    CGRect oldRect1 = rect1;
    rect1.origin.x = HCSCREEN_WIDTH;
    rect1.size.width = 0;
    
    CGRect gapViewRect = self.gapView.frame;
    CGRect oldGapViewRect = gapViewRect;
    gapViewRect.size.width = HCSCREEN_WIDTH*0.15;
    
    
    self.mTableView.frame = rect;
    self.gapView.frame = gapViewRect;
    self.navgation.frame = rect1;
    [self.superView addSubview:self.gapView];
    [self.superView addSubview:self.mTableView];
    [self.superView addSubview:self.navgation];
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableView.alpha = 1.0f;
        self.gapView.alpha = 0.3f;
        self.mTableView.frame = oldRect;
        self.gapView.frame = oldGapViewRect;
       self.navgation.frame = oldRect1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide:(BOOL)animate
{
    if(!animate) {
        [self.mTableView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        return;
    }
    
    CGRect rect = self.mTableView.frame;
    CGRect oldRect = rect;
    rect.size.width = 0;
    rect.origin.x = HCSCREEN_WIDTH;
    
    CGRect rect1 = self.navgation.frame;
    CGRect oldRect1 = rect1;
    rect1.size.width = 0;
    rect1.origin.x = HCSCREEN_WIDTH;
    
    CGRect gapViewRect = self.gapView.frame;
    CGRect oldGapViewRect = gapViewRect;
    gapViewRect.size.width = HCSCREEN_WIDTH*0.15;
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableView.alpha = 0.1f;
        self.gapView.alpha = 0.1f;
        self.mTableView.frame = rect;
        self.gapView.frame = gapViewRect;
      self.navgation.frame = rect1;
    }completion:^(BOOL finished) {
        [self.mTableView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        self.mTableView.frame = oldRect;
        self.gapView.frame = oldGapViewRect;
        self.navgation.frame = oldRect1;
        self.mTableView.alpha = 1.0f;
        self.gapView.alpha = 0.3f;
    }];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap hide");
    [self hide:YES];
    if (self.delegate) {
        [self.delegate doNoneSelected];
    }
}


#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HC_Series_BrandRow_Height;
    }
    return HC_Series_Row_Height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    } else if (section == 0) {
        return 1;
    } else {
        return [self.data.seriesInfo count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark - 车辆信息回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1){
        self.cond.brandId = self.data.brandId;
        self.cond.brandName = self.data.brandName;
        self.cond.seriesId = -1;
        self.selectSectionIdx = indexPath.section;
        self.selectRowIdx = indexPath.row;
        self.cond.seriesName = @"";
        if (self.delegate) {
            [self.delegate selected:self.cond];
        }

    }else{
        self.cond.brandId = self.data.brandId;
        self.cond.brandName = self.data.brandName;
        self.selectRowIdx = indexPath.row;
        self.selectSectionIdx = indexPath.section;
        AutoSeries *series = [self.data.seriesInfo HCObjectAtIndex:indexPath.row];
        self.cond.seriesId = series.seriesId;
        self.cond.seriesName = series.seriesName;
        
        if (self.delegate) {
            [self.delegate selected:self.cond];
        }

    }
}

#pragma mark -- UITableView DataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return nil;
    }else if (section==1){
        return [self customHeaderViewWithTitle:@"#"];
    }else{
        return [self customHeaderViewWithTitle:@"选择车系"];
    }
    
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 20;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self getBrandCell];
    }else if(indexPath.section==1){
         return [self getSeriesCellForRowAtIndexPath:indexPath];
    }else{
        return [self getSeriesCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)getBrandCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.frame.size.width, HC_Series_BrandRow_Height)];
    
    CGFloat brandImgHeight =  HC_Series_BrandRow_Height - 2 * HC_Series_BrandImg_Height_Padding;
    CGFloat brandImgWidth = brandImgHeight ;
    
    CGFloat imgXPadding = (self.mTableView.frame.size.width - brandImgWidth) / 2;
    //添加品牌图片
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(imgXPadding, HC_Series_BrandImg_Height_Padding, brandImgWidth, brandImgHeight)];
    NSString *imageName = [NSString stringWithFormat:@"%ld", (long)self.data.brandId];
    UIImage *brandImage = [UIImage imageNamed:imageName];
    if (brandImage == nil) {
        brandImage = [UIImage imageNamed:@"no_brand"];
    }
    [iv setImage:brandImage];
    [cell addSubview:iv];
    

//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(HC_Series_BackImag_Padding, HC_Series_BackImag_Padding, HC_Series_Row_Width_Padding - HC_Series_BackImag_Padding - 1, HC_Series_Row_Width_Padding - HC_Series_BackImag_Padding -1);
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"sback"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(seriesBack:) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:backBtn];
    

    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, HC_Series_BrandRow_Height - 0.5, self.mTableView.width, 0.5)];
    [bottom setBackgroundColor:UIColorFromRGBValue(0xe0e0e0)];
    
    [cell addSubview:bottom];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)getSeriesCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.frame.size.width, HC_Series_Row_Height)];
    
    NSString *text = @"";
    
    if (indexPath.section == 1) {
        text = @"不限";
    } else if (indexPath.section ==2) {
        NSInteger idx = indexPath.row;
        AutoSeries *series = [self.data.seriesInfo HCObjectAtIndex:idx];
        text = series.seriesName;
    }
    
    //添加label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.mTableView.width -  30, HC_Series_Row_Height)];
    label.font = [UIFont systemFontOfSize:14];
    [label setTextAlignment:NSTextAlignmentLeft]; 
    label.textColor = UIColorFromRGBValue(0x424242);
    [label setText:text];
    
    if (self.selectRowIdx != -1 && self.selectRowIdx == indexPath.row&&self.selectSectionIdx==indexPath.section) {
        if (self.cond.brandId == self.data.brandId) {
            //设置选中的颜色
            [label setTextColor:PRICE_STY_CORLOR];
        }
    }
    
    [cell addSubview:label];
    //添加下划线
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, HC_Series_Row_Height - 0.5, self.mTableView.width, 0.5)];
    [bottom setBackgroundColor:UIColorFromRGBValue(0xe0e0e0)];
    [cell addSubview:bottom];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)seriesBack:(id)sender
{
    [self hide:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
