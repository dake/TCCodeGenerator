//
//  TCCodeGenerator.h
//  Dake
//
//  Created by dake on 15/7/10.
//  Copyright (c) 2015年 Dake. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(char, TCQCCodeInputCorrectionLevel) {
    
    kTCQCCodeInputCorrectionLevelLow = 'L',
    kTCQCCodeInputCorrectionLevelMedium = 'M',
    kTCQCCodeInputCorrectionLevelHight = 'H',
    
    kTCQCCodeInputCorrectionLevelDefault = kTCQCCodeInputCorrectionLevelMedium,
};

typedef NS_ENUM(NSInteger, TCAztecCodeInputCorrectionLevel) {
    kTCAztecCodeInputCorrectionLevelDefault = 23,
    kTCAztecCodeInputCorrectionLevelMax = 95,
    kTCAztecCodeInputCorrectionLevelMin = 5,
    kTCAztecCodeInputCorrectionLevelSliderMax = 95,
    kTCAztecCodeInputCorrectionLevelSliderMin = 5,
};


typedef NS_ENUM(NSInteger, TCCode128BarcodeInputQuietSpace) {
    
    kTCCode128BarcodeInputQuietSpaceDefault = 7,
    kTCCode128BarcodeInputQuietSpaceMax = 20,
    kTCCode128BarcodeInputQuietSpaceMin = 0,
    kTCCode128BarcodeInputQuietSpaceSliderMax = 20,
    kTCCode128BarcodeInputQuietSpaceSliderMin = 0,
};


NS_CLASS_AVAILABLE_IOS(7_0) @interface TCCodeGenerator : NSObject

/**
 @brief	<#Description#>
 
 @param str [IN] text to generate image
 @param width [IN] point measurement
 @param color [IN] foreground color
 @param inputCorrectionLevel [IN]
 
 @return <#return value description#>
 */
+ (UIImage *)QRCodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputCorrectionLevel:(TCQCCodeInputCorrectionLevel)inputCorrectionLevel;

+ (UIImage *)AztecCodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputCorrectionLevel:(TCAztecCodeInputCorrectionLevel)inputCorrectionLevel;

+ (UIImage *)Code128BarcodeWithString:(NSString *)str width:(CGFloat)size color:(UIColor *)color inputQuietSpace:(TCCode128BarcodeInputQuietSpace)inputQuietSpace;

@end
