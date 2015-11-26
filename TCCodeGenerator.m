//
//  TCCodeGenerator.m
//  Dake
//
//  Created by dake on 15/7/10.
//  Copyright (c) 2015年 Dake. All rights reserved.
//

#import "TCCodeGenerator.h"
#import <CoreImage/CoreImage.h>


@implementation TCCodeGenerator

+ (UIImage *)Code128BarcodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputQuietSpace:(TCCode128BarcodeInputQuietSpace)inputQuietSpace
{
    if (str.length < 1) {
        return nil;
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    if ([filter respondsToSelector:NSSelectorFromString(@"setInputQuietSpace:")]) {
        [filter setValue:@(inputQuietSpace) forKey:@"inputQuietSpace"];
    }
    
    return [self nonInterpolatedImageFrom:filter.outputImage width:size color:color];
}

+ (UIImage *)AztecCodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputCorrectionLevel:(TCAztecCodeInputCorrectionLevel)inputCorrectionLevel
{
    if (str.length < 1) {
        return nil;
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIAztecCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    if ([filter respondsToSelector:NSSelectorFromString(@"setInputCorrectionLevel:")]) {
        [filter setValue:@(inputCorrectionLevel) forKey:@"inputCorrectionLevel"];
    }
    
    return [self nonInterpolatedImageFrom:filter.outputImage width:size color:color];
}

+ (UIImage *)QRCodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputCorrectionLevel:(TCQCCodeInputCorrectionLevel)inputCorrectionLevel
{
    if (str.length < 1) {
        return nil;
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    if ([filter respondsToSelector:NSSelectorFromString(@"setInputCorrectionLevel:")]) {
        NSString *level = [NSString stringWithFormat:@"%c", inputCorrectionLevel];
        [filter setValue:level forKey:@"inputCorrectionLevel"];
    }
    return [self nonInterpolatedImageFrom:filter.outputImage width:size color:color];
}


#pragma mark - private

+ (UIImage *)nonInterpolatedImageFrom:(CIImage *)image width:(CGFloat)size color:(UIColor *)color
{
    // create NonInterpolated UIImage Form CIImage
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat ratio = MIN(size * scale / CGRectGetWidth(extent), size * scale / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * ratio;
    size_t height = CGRectGetHeight(extent) * ratio;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(bitmapImage),
                                              CGImageGetHeight(bitmapImage),
                                              CGImageGetBitsPerComponent(bitmapImage),
                                              CGImageGetBitsPerPixel(bitmapImage),
                                              CGImageGetBytesPerRow(bitmapImage),
                                              CGImageGetDataProvider(bitmapImage),
                                              NULL, false);
    CGImageRef imgRef = CGImageCreateWithMask(bitmapImage, actualMask);
    CGImageRelease(actualMask);
    CGImageRelease(bitmapImage);
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             width,
                                             height,
                                             8,
                                             0,
                                             cs,
                                             kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(cs);
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(ctx, rect, imgRef);
    
    if (nil != color) {
        CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillRect(ctx, rect);
    }
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(ctx);
    CGImageRelease(imgRef);
    CGContextRelease(ctx);
    UIImage *img = [UIImage imageWithCGImage:scaledImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(scaledImage);
    
    return img;
}

@end
