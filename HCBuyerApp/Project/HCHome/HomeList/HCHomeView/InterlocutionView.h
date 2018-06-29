//
//  InterlocutionView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/3/29.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InterlocutionViewDelegate <NSObject>
- (void)choice:(NSString*)weburl;
@end

@interface InterlocutionView : UIView

@property(nonatomic,assign)id<InterlocutionViewDelegate>delegate;

@property (nonatomic,strong)UIView *mInterlocutionView;
@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,strong)UIImageView *operationChartImage;
@property (nonatomic,strong)UIView *mViewTitle;

- (id)initInterframeRec:(CGRect)frame dataArray:(NSArray *)array title:(NSString *)title b:(BOOL)b;


@end
