//
//  TCQRCodeGenerator.h
//  SudiyiClient
//
//  Created by dake on 15/7/10.
//  Copyright (c) 2015年 Dake. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_CLASS_AVAILABLE_IOS(7_0) @interface TCQRCodeGenerator : NSObject

/**
 @brief	<#Description#>
 
 @param str [IN] <#str description#>
 @param size [IN] point measurement
 @param color [IN] <#color description#>
 
 @return <#return value description#>
 */
+ (UIImage *)QRCodeWithString:(NSString *)str size:(CGFloat)size color:(UIColor *)color;

@end
