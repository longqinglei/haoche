//
//  TDBaseViewController.h
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingDataEAuth.h"

#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]

#define kCountryCode @"86"
#define kLawTipMessage @"轻触“下一步”即表示阅读并同意 隐私政策"
#define kLawTipHightlight @"隐私政策"

@interface TDBaseViewController : UIViewController<TalkingDataEAuthDelegate>
 

@end
