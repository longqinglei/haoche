//
//  BrandCell.m
//  HCBuyerApp
//
//  Created by wj on 15/5/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BrandCell.h"

#define HC_BRAND_CELL_HEIGHT_PADDING 5

@interface BrandCell()

@property (nonatomic) NSInteger brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, strong) UILabel *mTextView;

@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation BrandCell

-(NSString *)reuseIdentifier
{
    return @"brandListCell";
}

- (id)initWithFrame:(CGRect)frame image:(NSInteger)imageId text:(NSString *)name needBottomLine:(BOOL)needBottomLine;
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        CGFloat imgHeight = frame.size.height - 2 * HC_BRAND_CELL_HEIGHT_PADDING;

        self.mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, HC_BRAND_CELL_HEIGHT_PADDING, imgHeight, imgHeight)];
        self.brandId = imageId;
        self.brandName = name;
        NSString *imageName = [NSString stringWithFormat:@"%ld", (long)self.brandId];
        UIImage *brandImage =  LOADIMAGE(imageName, @"png");// [UIImage getImageFromLocalNamed:imageName Type:@"png"];
        if (brandImage == nil) {
            brandImage = [UIImage imageNamed:@"no_brand"];//LOADIMAGE(@"no_brand", @"png");//[UIImage getImageFromLocalNamed:@"no_brand" Type:@"png"];
        }
        [self.mImageView setImage:brandImage];
        
        self.mTextView = [[UILabel alloc] initWithFrame:CGRectMake(5 + self.mImageView.frame.size.width + 15, HC_BRAND_CELL_HEIGHT_PADDING, 100, frame.size.height - 2 * HC_BRAND_CELL_HEIGHT_PADDING)];
        self.mTextView.text = self.brandName;
        self.mTextView.font = [UIFont systemFontOfSize:14];
        self.mTextView.textColor = UIColorFromRGBValue(0x424242);
        [self addSubview:self.mImageView];
        [self addSubview:self.mTextView];
        
        self.arrowXPos = self.mImageView.frame.origin.x + self.mImageView.frame.size.width / 2;
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.mTextView.frame.origin.x, frame.size.height - 0.5, frame.size.width - self.mTextView.frame.origin.x, 0.5f)];
        [self.bottomLine setBackgroundColor:ColorWithRGB(224, 224, 224)];
        if (needBottomLine) {
            [self addSubview:self.bottomLine];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setCellSelected:(BOOL)select{
    if (select==YES) {
        self.mTextView.textColor = PRICE_STY_CORLOR;
    }else{
        self.mTextView.textColor = UIColorFromRGBValue(0x424242);
    }
    
}

- (void)setDataWithImageId:(NSInteger)imageId text:(NSString *)name needBottomLine:(BOOL)needBottomLine;
{
    self.brandId = imageId;
    self.brandName = name;
    
    NSString *imageName = [NSString stringWithFormat:@"%ld", (long)self.brandId];
    UIImage *brandImage =  LOADIMAGE(imageName, @"png");// [UIImage getImageFromLocalNamed:imageName Type:@"png"];
    if (brandImage == nil) {
        brandImage = [UIImage imageNamed:@"no_brand"]; // LOADIMAGE(@"no_brand", @"png"); //[UIImage getImageFromLocalNamed:@"no_brand" Type:@"png"];
    }
    if (needBottomLine) {
        if (self.bottomLine.superview != self) {
            [self addSubview:self.bottomLine];
        }
    } else {
        if (self.bottomLine.superview == self) {
            [self.bottomLine removeFromSuperview];
        }
    }
    [self.mImageView setImage:brandImage];
    self.mTextView.text = self.brandName;
}

@end
