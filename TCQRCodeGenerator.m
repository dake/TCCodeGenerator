//
//  TCQRCodeGenerator.m
//  SudiyiClient
//
//  Created by cdk on 15/7/10.
//  Copyright (c) 2015年 Sudiyi. All rights reserved.
//

#import "TCQRCodeGenerator.h"

@implementation TCQRCodeGenerator

+ (UIImage *)QRCodeWithString:(NSString *)str size:(CGFloat)size color:(UIColor *)color
{
    if (str.length < 1) {
        return nil;
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    CIImage *image = filter.outputImage;

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
