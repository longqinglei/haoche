//
//  NSObject+JSON.m
//  BuyerApp
//
//  Created by sjchao on 14-9-20.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

-(NSString *)JSONString {
    NSError* error = nil;
    NSString* string = [self JSONString:kNilOptions error:&error];
    return string;
}

-(NSString *)JSONPrettyPrintedString
{
    NSError* error = nil;
    NSString* string = [self JSONString:NSJSONWritingPrettyPrinted error:&error];
    return string;
}

-(NSString*)JSONString:(NSJSONWritingOptions)options error:(NSError**)error {
    NSData* datas;
    if (options) {
         datas = [NSJSONSerialization dataWithJSONObject:self options:options error:error];
    }else{
        return nil;
    }
  
    if (*error != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
}

@end
