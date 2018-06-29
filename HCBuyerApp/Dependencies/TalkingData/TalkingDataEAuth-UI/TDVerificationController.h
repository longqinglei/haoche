//
//  TDVerificationController.h
//  TDRealNameAuth-UI-Demo
//
//  Created by 冯婷婷 on 16/7/12.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDVerificationController : TDBaseViewController

@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *accName;
@property (nonatomic) NSInteger selectedRow;

@end

