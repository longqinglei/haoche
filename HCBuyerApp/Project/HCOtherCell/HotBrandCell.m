//
//  HotBrandCell.m
//  HCBuyerApp
//
//  Created by wj on 15/5/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HotBrandCell.h"
#import "BrandSeries.h"

#define HC_HOTBRAND_ELEM_GAP 10

#define HC_HOTBRAND_CELL_WIDTH_PADDING 10
#define HC_HOTBRAND_CELL_HEIGHT_PADDING 5
#define HC_HOTBRAND_BTN_TAG_BEGIN 6000
#define HC_LABEL_BTN_TAG_BEGIN 7000

#define HC_HOTBRAND_LABEL_HEIGHT 8
@interface HotBrandCell ()

@property (strong, nonatomic) NSArray *hotBrandInfo;

//@property (nonatomic) NSInteger idx;
//@property NSMutableArray *imgBtnSet;
@end

@implementation HotBrandCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSArray *)hotBrandInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.hotBrandInfo = hotBrandInfo;
        NSInteger maxNumInRow = HC_MAX_HOT_BRAND_NUM / 2;
        NSInteger curNumInRow = [self.hotBrandInfo count];
        //self.imgBtnSet = [[NSMutableArray alloc] initWithCapacity:curNumInRow];
       CGFloat btnWidth = (frame.size.width - HC_HOTBRAND_CELL_WIDTH_PADDING * 2 - HC_HOTBRAND_ELEM_GAP * (maxNumInRow - 1)) / 5.5;
        //CGFloat btnHeight = HC_LIST_ROW_HEIGHT - 10;
        self.btnGap = btnWidth + HC_HOTBRAND_ELEM_GAP;
        //NSLog(@"frame height : %f", frame.size.height);
       // CGFloat btnHeight = (frame.size.height - HC_HOTBRAND_CELL_HEIGHT_PADDING * 2 - HC_HOTBRAND_LABEL_HEIGHT);
        
      //  CGFloat imgHeightPad = 0;
        //CGFloat imgWidthPad = 0;
//        if (btnHeight / btnWidth > 0.75) {
//            imgHeightPad = (btnHeight - btnWidth * 0.75) / 2;
//        } else if (btnHeight /btnWidth < 0.75) {
//            imgWidthPad = (btnWidth - btnHeight/0.75) / 2;
//        }
        CGFloat btnKuan = (HCSCREEN_WIDTH*0.85-38)/4;
        CGFloat btnGao = HCSCREEN_WIDTH*0.19;
        for (int i = 0; i < curNumInRow; ++i) {
            int row = i/4;
            int list =i%4;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+list*(btnKuan+1), 15+row*(btnGao+1), btnKuan, btnGao);
            btn.backgroundColor = MTABLEBACK;
            UIImageView *imageview = [[UIImageView alloc]init];
             BrandSeries *brandSeries = [self.hotBrandInfo HCObjectAtIndex:i];
            imageview.frame = CGRectMake(btnKuan/4, 5, btnKuan/2, btnKuan/2);
             NSString *imageName = [NSString stringWithFormat:@"%ld", (long)brandSeries.brandId];
            imageview.image = [UIImage imageNamed:imageName];
            
            //btn.frame = CGRectMake(HC_HOTBRAND_CELL_WIDTH_PADDING + i *(btnWidth + HC_HOTBRAND_ELEM_GAP), HC_HOTBRAND_CELL_HEIGHT_PADDING, btnHeight, btnHeight);
            
           
            //CGFloat imgEdgePad = (btnWidth - btn.frame.size.height) /2.0 ;
            
            if (i == 0) {
                self.imgBtnXpos = btn.frame.origin.x + btn.frame.size.width / 2;
            }
            //btn.backgroundColor = [UIColor cyanColor];
            //图片居中
            //btn.imageEdgeInsets = UIEdgeInsetsMake(imgHeightPad, imgWidthPad, imgHeightPad , imgWidthPad);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview.bottom+5, btnKuan, 15)];
        
            [label setText:brandSeries.brandName];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.font = [UIFont systemFontOfSize:12];
            /*
            label.tag = HC_LABEL_BTN_TAG_BEGIN + i;
            UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTappedAction:)];
            [label addGestureRecognizer:labelTap];
            */
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = HC_HOTBRAND_BTN_TAG_BEGIN+i;
            //[self.imgBtnSet addObject:btn];
            [btn addSubview:imageview];

            [self addSubview:btn];
            [btn addSubview:label];
        }

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

/*
-(void)labelTappedAction:(UITapGestureRecognizer *)tap
{
    NSInteger curIdx = tap.view.tag - HC_LABEL_BTN_TAG_BEGIN;
    if (self.delegate) {
        UITableView *tb = (UITableView *)self.superview.superview;
        [self.delegate touchAtIndex:curIdx forIndexPath:[tb indexPathForCell:self]];
    }
}
*/              

- (void)btnClick:(UIButton *)btn
{
    //NSLog(@"btn click");
    NSInteger curIdx = btn.tag - HC_HOTBRAND_BTN_TAG_BEGIN;
    if (self.delegate) {
        
        UITableView *tb = (UITableView *)self.superview;
        [self.delegate touchAtIndex:curIdx forIndexPath:[tb indexPathForCell:self]];
        
    }
}



@end
