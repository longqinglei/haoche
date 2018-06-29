//
//  NSString+ITTAdditions.h
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (ITTAdditions)

- (BOOL)isStartWithString:(NSString*)start;
- (BOOL)isEndWithString:(NSString*)end;

//- (NSInteger)numberOfLinesWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;

//- (CGFloat)heightWithFont:(UIFont*)font withLineWidth:(NSInteger)lineWidth;
+(NSString *)fixStringForDate:(NSDate *)date;
- (NSString*)md5;
- (NSString*)urlEncodedString;
- (NSString*)urlDecodedString;

+ (NSString*)changeTimeTodate:(NSInteger)time formatter:(NSString*)matter;

+ (NSMutableAttributedString*)addBottomLine:(NSString*)str;
+ (NSMutableAttributedString*)setPriceFormat:(NSString*)mStr;
+ (NSMutableAttributedString*)setPriceText:(NSString*)mStr;
+ (NSString*)getNowTimestamps;
+ (NSString*)getnowMonthFirstDay;
+ (NSString*)getNowTimestamp;
+ (NSString *)getnowMonthFirstDay:(NSInteger )year;

+ (NSString *)getTimeNow;
+ (NSString *)appendudidandphone:(NSString *)url;
//正则匹配URl地址
-(BOOL)isValidUrl;
//更改的url 全局
+ (NSString *)getFixedSolutionImageUrl:(NSString *)imgUrl;
+ (NSString *)getFixedSolutionImageAllurl:(NSString *)imgUrl w:(int)w h:(int)h;
+ (NSString *)getFixedSolutionImageUrlBizStory:(NSString *)imgUrl;
+ (NSString *)cutPicture:(NSString *)imgUrl W:(int)w H:(int)h;

+ (NSMutableAttributedString*)setHomeVehicleNum:(NSString*)mStr;
+ (NSMutableAttributedString*)setHomePrice:(NSString*)mStr;
//+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;
+(NSString *)UIImageToBase64Str:(UIImage *) image;
//返回字段做处理和判断
+ (NSMutableAttributedString*)setselectVehicleNum:(NSString*)mStr;
+ (NSString *)isEqualTo:(NSDictionary *)data key:(NSString *)key;
+ (NSMutableAttributedString*)setFund:(NSString*)mStr;
+ (NSMutableAttributedString*)setCheckedVehicle:(NSString*)mStr;
@end

