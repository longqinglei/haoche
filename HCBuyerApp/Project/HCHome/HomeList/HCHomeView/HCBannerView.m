//
//  HCBannerView.m
//  HCBuyerApp
//
//  Created by wj on 15/6/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCBannerView.h"
#import "SDCycleScrollView.h"
#import "AppClient.h"

@interface HCBannerView()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) NSArray *bannerData;
@property (strong, nonatomic) SDCycleScrollView *bannerScrollView;
@property (nonatomic) CGRect bannerFrame;
@property (nonatomic,strong)UILabel *spacelabel;
@end

@implementation HCBannerView

- (id)initWithFrame:(CGRect)frame data:(NSArray *)bannerData controlStyle:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerFrame = frame;
        self.bannerData = bannerData;
        NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:[self.bannerData count]];
        for (Banner *b in self.bannerData) {
            if (b.pic_url != nil && b.pic_url.length != 0) {
                [urls addObject:b.pic_url];
            }
        }
        _controlStyle = type;
        if (urls.count!=0) {
            if (_controlStyle==0) {
                self.bannerScrollView = [self createBannerScrollView:urls];
                [self addSubview:self.bannerScrollView];
            }else{
                self.bannerScrollView = [self createTopBannerScrollView:urls];
                [self addSubview:self.bannerScrollView];
            }
            

        }
    }
    return self;
}

- (SDCycleScrollView *)createTopBannerScrollView:(NSArray *)urls
{
    SDCycleScrollView * bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.933) imageURLStringsGroup:urls ];
    
    if (_controlStyle!=0) {
        bannerScrollView.sysPageControl.frame =  CGRectMake(0, self.height-20, 20*urls.count+20, 20);
        bannerScrollView.sysPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        bannerScrollView.sysPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //bannerScrollView.sysPageControl.backgroundColor = [UIColor cyanColor];
    }
    self.spacelabel.frame = CGRectMake(0, bannerScrollView.bottom, HCSCREEN_WIDTH, 10);

    bannerScrollView.delegate = self;

    [bannerScrollView setAutoScrollTimeInterval:7];
    if ([self.bannerData count] == 1) {
        [bannerScrollView setAutoScrollTimeInterval:1000000000];
    }

    return bannerScrollView;
}

- (SDCycleScrollView *)createBannerScrollView:(NSArray *)urls
{
    SDCycleScrollView * bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.24) imageURLStringsGroup:urls ];
    
    if (_controlStyle!=0) {
       bannerScrollView.sysPageControl.frame =  CGRectMake(0, self.height-20, 100, 20);
        
    }
    if (!self.spacelabel) {
        self.spacelabel = [[UILabel alloc]init];
        self.spacelabel.backgroundColor = MTABLEBACK;
    }
    [self addSubview:self.spacelabel];
    self.spacelabel.frame = CGRectMake(0, bannerScrollView.bottom, HCSCREEN_WIDTH, 10);
    // bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    bannerScrollView.delegate = self;
    //  bannerScrollView.currentPageDotColor = PAGE_STYLE_COLOR;
    [bannerScrollView setAutoScrollTimeInterval:7];
    if ([self.bannerData count] == 1) {
        [bannerScrollView setAutoScrollTimeInterval:1000000000];
    }
    //[bannerScrollView setPageControlDotSize:CGSizeMake(4, 4)];
    return bannerScrollView;
}
- (void)networkerror{
    NSArray *imageArr = [NSArray arrayWithObject:LOADIMAGE(@"defaulterrornet",@"png")];
    self.bannerScrollView  = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.933)  imagesGroup:imageArr];
    [self addSubview:self.bannerScrollView];
}

- (void)setTopBannerData:(NSArray*)bannerData{
    if (bannerData.count==0) {
//        NSArray *imageArr = [NSArray arrayWithObject:LOADIMAGE(@"defaulterrornet",@"png")];
//        self.bannerScrollView  = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.933)  imagesGroup:imageArr];
//        [self addSubview:self.bannerScrollView];
        return;
    }
    self.bannerData = bannerData;
    self.frame  = self.bannerFrame;
    NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:[self.bannerData count]];
    for (Banner *b in self.bannerData) {
        [urls addObject:b.pic_url];
    }
    if (self.bannerScrollView.superview == self) {
        [self.bannerScrollView removeFromSuperview];
    }
    NSLog(@"urls %@",urls);
    self.bannerScrollView = [self createTopBannerScrollView:urls];
    [self addSubview:self.bannerScrollView];
}
- (void)setBannersData:(NSArray *)bannerData
{
    if (bannerData.count==0) {
        self.frame = CGRectZero;
        [self.bannerScrollView removeFromSuperview];
        self.spacelabel.frame = CGRectZero;
        [self.spacelabel removeFromSuperview];
        self.spacelabel.frame = CGRectZero;
        return;
    }
    self.bannerData = bannerData;
    self.frame  = self.bannerFrame;
    NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:[self.bannerData count]];
    for (Banner *b in self.bannerData) {
        [urls addObject:b.pic_url];
    }
    if (self.bannerScrollView.superview == self) {
        [self.bannerScrollView removeFromSuperview];
    }
    NSLog(@"urls %@",urls);
    self.bannerScrollView = [self createBannerScrollView:urls];
   [self addSubview:self.bannerScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    @try {
        if (self.delegate) {
            [AppClient tongji:[NSString stringWithFormat:@"&click=banner_%ld",(long)index]];
            [self.delegate bannerClick:[self.bannerData HCObjectAtIndex:index]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception occure where click banner:%@", exception.description);
    }
    @finally {
        
    }
}


@end
