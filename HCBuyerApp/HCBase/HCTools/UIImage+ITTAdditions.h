//
//  UIImage(ITTAdditions).h
//  
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(ITTAdditions)

- (UIImage *)imageRotatedToCorrectOrientation;
- (UIImage *)imageCroppedWithRect:(CGRect)rect;
- (UIImage *)imageFitInSize:(CGSize)viewsize;
- (UIImage *)imageScaleToFillInSize:(CGSize)viewsize;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)navigationBarImageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage*)getImageFromLocalNamed:(NSString *)imageName Type:(NSString *)type;
@end
