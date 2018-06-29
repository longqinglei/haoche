//
//  OperationchartView.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/26.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OperationchartViewDelegate <NSObject>
- (void)pushActivitiDetail:(NSString*)weburl;
@end

@interface OperationchartView : UIView
@property(nonatomic,assign)id<OperationchartViewDelegate>delegate;


@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,strong) UIImageView *operationChartImage;

- (id)initWithframeRec:(CGRect)frame urlImage:(NSString *)string;
@end
