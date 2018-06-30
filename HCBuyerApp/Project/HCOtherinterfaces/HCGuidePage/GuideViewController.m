//
//  GuideViewController.m
//  HCBuyerApp
//
//  Created by  on 15/5/21.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "GuideViewController.h"
#import "VehicleListViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "NSString+ITTAdditions.h"
#import "BizRquestStartPage.h"

@interface GuideViewController ()

@property (nonatomic)NSInteger secondCountdownNumber;

@property (nonatomic,strong)UIButton *goBtn;
@property (nonatomic,strong)NSString *strUrl;
@property (nonatomic,strong)GuideModel *bodyModel;
@property (nonatomic,strong)GuideModel *footModel;

@property (nonatomic,strong)NSMutableArray *modelArray;

@property (nonatomic,strong)NSTimer *validCodeTimer;
@property (nonatomic,strong)UIImageView *guideImageView;
@property (nonatomic,strong)UIImageView *footImageVIew;
@property (nonatomic,strong)UIImageView *compression;

@end

@implementation GuideViewController


#pragma mark - LifeCycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 #pragma mark - bool - statusBar //这个是判断statusBar以上或者有  不加怕（appstore还能下载）
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelArray  = [[NSMutableArray alloc]init];
    NSString * string = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) HCObjectAtIndex:0];
    NSString * filePath = [string stringByAppendingString:@"/modelArr.swh"];
    @try {
        NSMutableArray *modelArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]];
        if (modelArr.count!=0) {
            self.bodyModel = [modelArr HCObjectAtIndex:0];
            self.footModel = [modelArr HCObjectAtIndex:1];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self createGuideViewWithGoBtn];
    
    if (self.footModel){
        [_compression sd_setImageWithURL:[NSURL URLWithString:self.footModel.image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_guideImageView addSubview:_footImageVIew];
        }];
    }
    if (self.bodyModel){
        [_guideImageView sd_setImageWithURL:[NSURL URLWithString:self.bodyModel.image_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_guideImageView addSubview:_goBtn];}];
        [self time];
    }else{
        [self fadeView];
    }
   
    [_footImageVIew addSubview:_compression];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_guideImageView addGestureRecognizer:tapRecognizer];
    [self requestViewPiture];
    
}

#pragma mark - Public
- (void)createGuideViewWithGoBtn
{
    _guideImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    _guideImageView.userInteractionEnabled = YES;
    _guideImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_guideImageView];
    
    _footImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*227/640, HCSCREEN_WIDTH, HCSCREEN_WIDTH*227/640)];
    _footImageVIew.userInteractionEnabled = YES;
    _footImageVIew.backgroundColor = [UIColor whiteColor];
    
    int sloganW =  (HCSCREEN_WIDTH * 512 / 640);
    int sloganH=  (HCSCREEN_WIDTH * 70 / 640);
    
    _compression = [[UIImageView alloc]init];
    _compression.frame = CGRectMake((HCSCREEN_WIDTH-sloganW)/2, (_footImageVIew.height-sloganH)/2, sloganW, sloganH);

    if (self.bodyModel.show_time == 0) {
        self.secondCountdownNumber = 5;
    }else{
        self.secondCountdownNumber = self.bodyModel.show_time;
    }
    CGRect btnRect = CGRectMake(HCSCREEN_WIDTH-HCSCREEN_WIDTH*0.3+5,25+kTabbarBottom,HCSCREEN_WIDTH*0.25,25);
    _goBtn = [UIButton buttonWithFrame:btnRect title:[NSString stringWithFormat:@"%lds点击跳过",(long)self.secondCountdownNumber] titleColor:[UIColor whiteColor]  bgColor:[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.50f] titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:14] image:nil selectImage:nil target:self action:@selector(fadeView) tag:1];
    
}

#pragma mark - requestData
- (void)requestViewPiture
{
    [BizRquestStartPage guideviewRequestFinish:^(NSInteger code, GuideModel * bodyModel, GuideModel *footModel,NSArray *modelArr) {
        if (code==0) {
            if (bodyModel.mid!=self.bodyModel.mid||footModel.mid!=self.footModel.mid) {
                [self.modelArray addObject:bodyModel];
                [self.modelArray addObject:footModel];
                NSString * string = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) HCObjectAtIndex:0];
                NSString * filePath = [string stringByAppendingString:@"/modelArr.swh"];
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:modelArr];
                [data writeToFile:filePath atomically:YES];
            }
        }else{
            
        }
        
    }];
}

#pragma mark - UIGestureRecognizer
- (void)tap:(UIGestureRecognizer *)gesTure
{
    if (self.delegate) {
        if (self.bodyModel.jump != 0) {
            [self.view removeFromSuperview];
            [self.delegate pushViewController:self.bodyModel.jump ];
            return;
        }
        if (!self.bodyModel.redirect || [self.bodyModel.redirect isEqualToString:@""]) {
            return;
        }else{
            [self.delegate pushActiviti:[NSString appendudidandphone:self.bodyModel.redirect]];
        }
    }
}

#pragma mark - countdown
- (void)countDown:(NSTimer *)time
{
    self.secondCountdownNumber --;
    [self.goBtn setTitle:[NSString stringWithFormat:@"%lds点击跳过",(long)self.secondCountdownNumber] forState:UIControlStateNormal];
    if (self.secondCountdownNumber == 0) {
        self.validCodeTimer = nil;
        [time invalidate];
        if ([self.delegate respondsToSelector:@selector(launchViewAction)]) {
            [self.delegate launchViewAction];
        }
    }
}

#pragma mark - fadeView
- (void)fadeView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(launchViewAction)]) {
        [self.delegate launchViewAction];
    }
}

#pragma mark - Time
- (void)time
{
    if (self.validCodeTimer==nil) {
      self.validCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:)userInfo:nil repeats:YES];
    }
}

- (void)URLimageView:(NSString *)key boolIs:(BOOL)isBOOL imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:key] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (isBOOL) {
             [_guideImageView addSubview:_footImageVIew];
        }else{
            [_guideImageView addSubview:_goBtn];
        }
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
