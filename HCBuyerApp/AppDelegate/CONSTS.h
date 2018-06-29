//
//  CONSTS.h
//  Hupan
//
//  Copyright 2015 iTotem Studio. All rights reserved.
//


#define VEHICLE_SELL_URL @"http://m.haoche51.com/vehicle_sell.html?channel=app&udid=%ld"
#define BANGMAI_URL @"http://m.haoche51.com/bangmai.html?channel=app&udid=%ld"
#define ABOUTUS @"http://m.haoche51.com/service.html?channel=app"
#define Token @"haoche51@572"
#define COUPON @"http://m.haoche51.com/coupon/detail?id="
#define USERCOUPON @"http://m.haoche51.com/coupon/bank_card?"      
#define TONGJI @"https://tongji.haoche51.com/ios.gif?"
#define FUWUBAOZHANG @"http://m.haoche51.com/service.html?channel=app"
#define MORESHARE @"http://bbs.haoche51.com/forum.php?mod=forumdisplay&fid=82&filter=typeid&typeid=11"

#define kDistribution 1



#if  kDistribution == 0
//src1 是统计用户关闭问题浮层方面  v详情页底部按钮
#define DETAIL_URL @"http://m.haoche51.com/details/%ld.html?channel=app&udid=%ld&src1=%@"
#define BaseURLString @"http://182.92.242.166:10002/"  //线上测试环境
#define Forum_URL @"http://bbs.haoche51.com/?channel=ios"
#define HC_PUSH_MODE  BPushModeDevelopment
#define HC_SERVER_URL @"http://101.200.145.87:8006/sa"
#define HC_CONFIGURE_URL @"http://101.200.145.87:8007/api/vtrack/config"
#define HC_DEBUG SensorsAnalyticsDebugAndTrack

#elif kDistribution == 1

#define DETAIL_URL @"http://m.haoche51.com/details/%ld.html?channel=app&udid=%ld&src1=%@"
#define BaseURLString @"https://buyer.app.haoche51.com/"   //线上接口
//#define HC_PUSH_MODE  BPushModeDevelopment
#define Forum_URL @"http://bbs.haoche51.com/?channel=ios"

#define HC_PUSH_MODE  BPushModeProduction
#define HC_SERVER_URL @"http://101.200.145.87:8006/sa"
#define HC_CONFIGURE_URL @"http://101.200.145.87:8007/api/vtrack/config"
#define HC_DEBUG SensorsAnalyticsDebugOff
#else

#define DETAIL_URL @"http://m.haoche51.com/details/%ld.html?channel=app&udid=%ld&src1=%@"
#define BaseURLString @"http://192.168.50.183:8011/"//内部测试
#define Forum_URL @"http://bbs.haoche51.com/?channel=ios"
#define HC_PUSH_MODE  BPushModeDevelopment
#define HC_SERVER_URL @"http://101.200.145.87:8006/sa"
#define HC_CONFIGURE_URL @"http://101.200.145.87:8007/api/vtrack/config"
#define HC_DEBUG SensorsAnalyticsDebugOnly
#endif


/*富文本实现图片和字体混编
 NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.vehicleTitleLabel.text];
 NSTextAttachment *attach = [[NSTextAttachment alloc]init];
 //设置 图片的image,和bounds
 UIImage *stateImage = [UIImage imageNamed:@"zhiyingdian"];
 attach.image = stateImage;
 attach.bounds = CGRectMake(0, 0, stateImage.size.width, stateImage.size.height);
 NSAttributedString *imageString = [NSMutableAttributedString attributedStringWithAttachment:attach];
 [attributedString insertAttributedString:imageString atIndex:0];
 self.vehicleTitleLabel.attributedText = attributedString;
 self.vehicleTitleLabel.backgroundColor = [UIColor cyanColor];
*/




