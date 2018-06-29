//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIFont+ITTAdditions.h"
#import "BizUser.h"

@implementation NSString (ITTAdditions)

//以下整体可以分装 有时间在写
+(NSString *)fixStringForDate:(NSDate *)date

{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *fixString = [dateFormatter stringFromDate:date];
    
    
    return fixString;
    
}

+ (NSString *)getFixedSolutionImageUrl:(NSString *)imgUrl
{
    NSString *temp;
    if ([imgUrl rangeOfString:@"?"].location != NSNotFound) {
        temp = [NSString stringWithFormat:@"%@&imageView2/2/w/240/h/180",imgUrl];
    }else{
        temp = [NSString stringWithFormat:@"%@?imageView2/2/w/240/h/180",imgUrl];
    }
    return temp;
}

+ (NSString *)getFixedSolutionImageUrlBizStory:(NSString *)imgUrl
{
    NSRange range = [imgUrl rangeOfString:@"imageView2"];
    if (range.length > 0) {
        NSString *str = [imgUrl substringToIndex:range.location];
        NSMutableString *ret = [[NSMutableString alloc] initWithString:str];
        [ret appendString:@"imageView2/1/w/519/h/519"];
        return ret;
    }
    return @"";
}
//包含某个字符
-(BOOL)containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}
//以某个字符结尾
-(BOOL)isEndssWith:(NSString *)string
{
    return ([self hasSuffix:string]) ? YES : NO;
}
//以某个字符开头
-(BOOL)isBeginsWith:(NSString *)string
{
    return ([self hasPrefix:string]) ? YES : NO;
}
//判断url
-(BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
//替换某个字符串
-(NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar
{
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}
//截取字符串
-(NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end
{
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}
//添加拼接字符
-(NSString *)addString:(NSString *)string
{
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}
//移除某个字符
-(NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString])
    {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}
//删除空格
-(NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}
//data转字符
+(NSString *)getStringFromData:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
//字符转data
-(NSData *)convertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
//+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
//{
//    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
//    UIImage *_decodedImage     = [UIImage imageWithData:_decodedImageData];
//    return _decodedImage;
//}

/**
 *  计算属性字符文本占用的宽高
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *  @param lineSpacing 行间距
 *  @return 占用的宽高
 */
-(CGSize)attrStrSizeWithFont:(UIFont *)font andmaxSize:(CGSize)maxSize lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    NSDictionary *dict = @{NSFontAttributeName: font,
                           NSParagraphStyleAttributeName: paragraphStyle};
    CGSize sizeToFit = [self boundingRectWithSize:maxSize // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:dict        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit;
}
+(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}



+ (NSString *)getFixedSolutionImageAllurl:(NSString *)imgUrl w:(int)w h:(int)h
{
    NSString *temp;
    if ([imgUrl rangeOfString:@"?"].location != NSNotFound) {              //把4改成了2
        temp = [NSString stringWithFormat:@"%@&imageView2/2/w/%d/h/%d",imgUrl,w,h];
    }else{
        temp = [NSString stringWithFormat:@"%@?imageView2/2/w/%d/h/%d",imgUrl,w,h];
    }
    return temp;
}


+ (NSString *)cutPicture:(NSString *)imgUrl W:(int)w H:(int)h
{
    NSString *temp;
    if ([imgUrl rangeOfString:@"?"].location != NSNotFound) {
        temp = [NSString stringWithFormat:@"%@&imageView2/2/w/%d/h/%d",imgUrl,w,h];
    }else{
        temp = [NSString stringWithFormat:@"%@?imageView2/2/w/%d/h/%d",imgUrl,w,h];
    }
    return temp;
}



+ (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString* timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}
//[searchStr rangeOfString:@"substr"].location != NSNotFound

+(NSString *)appendudidandphone:(NSString *)url
{
    NSString *urlstr;
    NSString *udidPhone = [NSString stringWithFormat:@"phone=%@&udid=%ld",IPHONE,(long)[BizUser getUserId]];
    if ([url rangeOfString:@"?"].location!= NSNotFound) {
        urlstr = [NSString stringWithFormat:@"%@&%@",url,udidPhone];
    }else{
        urlstr = [NSString stringWithFormat:@"%@?%@",url,udidPhone];
    }
    return urlstr;
}


+ (NSString *)getnowMonthFirstDay:(NSInteger )year{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:timeZone];
    NSDateFormatter  *yearmonthformatter=[[NSDateFormatter alloc] init];
    [yearmonthformatter setDateFormat:@"YYYY-MM"];
    [yearmonthformatter setTimeZone:timeZone];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"YYYY"];
    [yearFormatter setTimeZone:timeZone];
    NSDateFormatter  *monthformatter=[[NSDateFormatter alloc] init];
    [monthformatter setDateFormat:@"MM"];
    [monthformatter setTimeZone:timeZone];
    NSString *yearNow = [yearFormatter stringFromDate:[NSDate date]];
    NSString *monthNow = [monthformatter stringFromDate:[NSDate date]];
    NSInteger diffYear = [yearNow intValue]-year;
    NSString *firstdateStr = [NSString stringWithFormat:@"%ld-%@-01 00:00:00",(long)diffYear,monthNow];
    NSDate *firstDate = [dateFormatter dateFromString:firstdateStr];
    NSString *last_time = [NSString stringWithFormat:@"%ld",(long)[firstDate timeIntervalSince1970]];
    return last_time;
}




+(NSString*)getnowMonthFirstDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeZone:timeZone];
    [dateformatter setDateFormat:@"YYYY-MM"];
    NSString *strDate = [dateformatter stringFromDate:[NSDate date]];
    NSString *firstday = [NSString stringWithFormat:@"%@-01 00:00:00",strDate];
   // NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
   // NSDate *  senddate=[NSDate date];
    NSDate *firstDate = [dateFormatter dateFromString:firstday];
    NSString *last_time = [NSString stringWithFormat:@"%ld",(long)[firstDate timeIntervalSince1970]];
    return last_time;
}
+(NSString*)getNowTimestamps{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeZone:timeZone];
    [dateformatter setDateFormat:@"YYYY-MM"];
    NSString *last_time = [NSString stringWithFormat:@"%ld",(long)[senddate timeIntervalSince1970]];
    return last_time;
}
//获取当前时间戳
+(NSString*)getNowTimestamp{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    [dateformatter setTimeStyle:NSDateFormatterShortStyle];
    [dateformatter setTimeZone:timeZone];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *last_time = [NSString stringWithFormat:@"%ld",(long)[senddate timeIntervalSince1970]];
    return last_time;
}

+ (NSMutableAttributedString*)setHomeVehicleNum:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSInteger priceLength = [mStr length] ;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    if (priceLength==0) {
        return str;
    }else{
        //设置字号
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0,priceLength- 7)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(priceLength- 7, 7)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xff2626) range:NSMakeRange(0, priceLength- 7)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x929292)  range:NSMakeRange(priceLength- 7,7)];
        
        
        return str;
    }
}
+ (NSMutableAttributedString*)setHomePrice:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSInteger priceLength = [mStr length] ;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    if (priceLength==0) {
        return str;
    }else{
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0,priceLength- 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(priceLength- 1, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xff2626) range:NSMakeRange(0, priceLength- 1)];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x9f9f9f)  range:NSMakeRange(priceLength- 1,1)];
   
    
        return str;
    }
}
+ (NSMutableAttributedString*)setselectVehicleNum:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSRange range = [mStr rangeOfString:@"为您找到"];
    NSRange range2 = [mStr rangeOfString:@"辆车"];
    NSInteger priceLength = [mStr length] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    if (priceLength==0) {
        return str;
    }else{
        //设置字号
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, priceLength)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xff2626) range:NSMakeRange(0, priceLength)];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x424242) range:range];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0x424242) range:range2];
        return str;
    }

}
//无忧质保问题车辆数字
+ (NSMutableAttributedString*)setCheckedVehicle:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSRange range = [mStr rangeOfString:@"万"];
    NSRange range2 = [mStr rangeOfString:@"辆"];
    NSInteger priceLength = [mStr length] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    if (priceLength==0) {
        return str;
    }else{
        //设置字号
         [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, priceLength)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range2];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xff2626) range:NSMakeRange(0, priceLength)];
        return str;
    }
}
//无忧质基金池数字
+ (NSMutableAttributedString*)setFund:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSRange range = [mStr rangeOfString:@"万"];
    NSInteger priceLength = [mStr length] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    if (priceLength==0) {
        return str;
    }else{
        //设置字号
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, priceLength)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBValue(0xff2626) range:NSMakeRange(0, priceLength)];
        return str;
    }
}

//设置车辆cell价格
+ (NSMutableAttributedString*)setPriceText:(NSString*)mStr{
    if (mStr==nil) {
        mStr=@"";
    }
    NSInteger priceLength = [mStr length] ;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, priceLength)];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(0, priceLength)];
    return str;
}
+ (NSMutableAttributedString*)setPriceFormat:(NSString*)mStr{
    // NSString *priceText = [NSString stringWithFormat:@"¥ %.1f万", vehicle.vehiclePrice];
    //self.vehiclePriceLabel.text = priceText;
    //修改字体以及颜色
    if (mStr==nil) {
        mStr=@"";
    }
    NSInteger priceLength = [mStr length] - 1;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    //设置字号
  //  [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    //[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(1, 1)];
    
    if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 weight:1.0f] range:NSMakeRange(0, priceLength )];
    } else {
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:24] range:NSMakeRange(0, priceLength )];
    }
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(priceLength, 1)];
    //设置文字颜色
    //[str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR  range:NSMakeRange(0, priceLength)];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(priceLength, 1)];
    
    return str;
}



//给电话号码添加下划线
+ (NSMutableAttributedString*)addBottomLine:(NSString*)str{
    if (str) {
        NSMutableAttributedString *linestr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange strRange = {0,[linestr length]};
        [linestr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        return linestr;
    }else{
        return nil;
    }
    
   
}

//时间戳转化时间matter为时间格式
+ (NSString*)changeTimeTodate:(NSInteger)time formatter:(NSString*)matter{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//北京上海时间一样
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:matter];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//- (NSInteger)numberOfLinesWithFont:(UIFont*)font
//                     withLineWidth:(NSInteger)lineWidth
//{
//    CGSize size = [self sizeWithFont:font
//                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
//                       lineBreakMode:NSLineBreakByTruncatingTail];
//	NSInteger lines = size.height / [font ittLineHeight];
//	return lines;
//}

//- (CGFloat)heightWithFont:(UIFont*)font
//            withLineWidth:(NSInteger)lineWidth
//{
//    CGSize size = [self sizeWithFont:font
//                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
//                       lineBreakMode:NSLineBreakByTruncatingTail];
//	return size.height;
//	
//}

- (NSString *)md5
{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, (int)strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}

- (NSString *)urlEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString*)urlDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}


- (BOOL)isStartWithString:(NSString*)start
{
    BOOL result = FALSE;
    NSRange found = [self rangeOfString:start options:NSCaseInsensitiveSearch];
    if (found.location == 0)
    {
        result = TRUE;
    }
    return result;
}

- (BOOL)isEndWithString:(NSString*)end
{
    NSInteger endLen = [end length];
    NSInteger len = [self length];
    BOOL result = TRUE;
    if (endLen <= len) {
        NSInteger index = len - 1;
        for (NSInteger i = endLen - 1; i >= 0; i--) {
            if ([end characterAtIndex:i] != [self characterAtIndex:index]) {
                result = FALSE;
                break;
            }
            index--;
        }
    }
    else {
        result = FALSE;
    }
    return result;
}

+ (NSString *)isEqualTo:(NSDictionary *)data key:(NSString *)key
{
    if ([data objectForKey:key]==nil){
        return @"";
    }else if([[data objectForKey:key] isEqual:[NSNull null]]){
        return @"";
    }else if([data objectForKey:key]){
        return [data objectForKey:key];
    }else {
        return @"";
    }
    return @"";
}


@end

