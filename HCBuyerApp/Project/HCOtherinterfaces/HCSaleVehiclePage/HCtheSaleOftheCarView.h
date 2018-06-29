//
//  HCtheSaleOftheCarView.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/10.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HCtheSaleOftheCarViewDelegate

@required

- (void)submitTelephoneNum:(NSString *)errMge and:(NSString *)service;

@end
@interface HCtheSaleOftheCarView : UIView
- (id)initWithFrame:(CGRect)frame peopleNum:(NSString *)sellNum coverImage:(NSString *)url phoneNum:(NSString *)phoneNum;
- (void)reloadViewData:(NSString *)teleNum PeoNum:(NSString*)peoNum coverurl:(NSString*)cover;
@property (strong, nonatomic) id<HCtheSaleOftheCarViewDelegate> delegate;
@property (nonatomic,strong) NSString *telephoneNum;
@property (nonatomic,strong) NSString *coverImageUrl;
@property (nonatomic,strong) NSString *sellNum;
@property (nonatomic,strong)UITextField *telTextFleld;
//@property (nonatomic,strong) NSString *submitPhone;
@end
