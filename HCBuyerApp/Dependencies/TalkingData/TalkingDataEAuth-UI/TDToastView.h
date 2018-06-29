//
//  TDToastView.h
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDToastView : UIView
 

+ (void)makeToastWithText:(NSString *)message completion:(void (^)(BOOL finished))completion;

@end
