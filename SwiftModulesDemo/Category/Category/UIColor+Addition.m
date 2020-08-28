//
//  UIColor+Addition.m
//  Category
//
//  Created by ash on 2018/12/25.
//  Copyright © 2018 ash. All rights reserved.
//

#import "UIColor+Addition.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation UIImage (Addition)

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat index = [UIScreen mainScreen].bounds.size.width > 375 ? 3: 2;
    
    CGSize new_size =  CGSizeMake(size.width*index, size.height*index);
    
    
    UIGraphicsBeginImageContext(new_size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == nil) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGFloat *startColorComponents = CGColorGetComponents(startColor.CGColor);
    
    const CGFloat *endColorComponents = CGColorGetComponents(endColor.CGColor);
    
    if (startColorComponents == nil || endColorComponents == nil) {
        return nil;
    }
    
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGFloat locations[] = { 0.0, 1.0 };
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint new_startPoint = CGPointMake(startPoint.x*index, startPoint.y*index);
    CGPoint new_endPoint = CGPointMake(endPoint.x*index, endPoint.y*index);
    
    CGContextDrawLinearGradient(context, gradient, new_startPoint, new_endPoint, kCGGradientDrawsBeforeStartLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    return image;
}

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size {
    
    //    CGFloat index = [UIScreen mainScreen].bounds.size.width > 375 ? 3: 2;
    //
    //    CGSize new_size =  CGSizeMake(size.width*index, size.height*index);
    
    return [UIImage cc_gradedImage:startColor endColor:endColor size:size startPoint:CGPointMake(0, size.height) endPoint:CGPointMake(size.width, size.height)];
}

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor rect:(CGRect)rect {
    return [UIImage cc_gradedImage:startColor endColor:endColor size:rect.size];
}

+ (UIImage *)cc_animatedGIFWithData:(NSData *)data {
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    
    NSDictionary *options = @{(__bridge NSString *)kCGImageSourceShouldCache: @(YES), (__bridge NSString *)kCGImageSourceTypeIdentifierHint: (__bridge NSString *)kUTTypeGIF};
    
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }else {
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, (__bridge CFDictionaryRef)options);
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
            
            NSDictionary *gifinfo = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
            
            duration += [UIImage frameDuration:gifinfo];
            
            [images addObject:[[UIImage alloc] initWithCGImage:imageRef scale:2 orientation:UIImageOrientationUp]];
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    return animatedImage;
}

+ (double)frameDuration:(NSDictionary *)gifInfo {
    double gifDefaultFrameDuration = 0.1;
    
    NSNumber *unclampedDelayTime = [gifInfo objectForKey:(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    NSNumber *delayTime = [gifInfo objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
    NSNumber *duration;
    if (unclampedDelayTime) {
        duration = unclampedDelayTime;
    }else {
        duration = delayTime;
    }
    
    if (duration != nil) {
        return duration.doubleValue > 0.011 ?duration.doubleValue : gifDefaultFrameDuration;
    }else {
        return gifDefaultFrameDuration;
    }
}

- (UIImage *)cc_imageWithTintColor:(UIColor *)tintColor
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0)
        return nil;
    //    CGFloat index = [UIScreen mainScreen].bounds.size.width > 375 ? 3: 2;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)circularImageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0)
        return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 0.0);//线宽
    CGContextAddArc(context, size.width/2, size.width/2, size.width/2, 0, M_PI *2.0, 0);
    //    CGContextClip(context);
    CGContextDrawPath(context, kCGPathFill);//仅填充
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIColor (Addition)

+ (UIColor*)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            blue=0;
            green=0;
            red=0;
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark - class func

/**
 button 通用状态的背景颜色
 */
+ (UIColor *)cc_buttonBackgroundColor {
    return [UIColor colorWithHexString:@"f86e50"];
}

+ (UIColor *)cc_itemGrayBackgroundColor {
    return [UIColor colorWithHexString:@"e3e3e3"];
}

+ (UIColor *)cc_tableViewBackgroundColor {
    return [UIColor colorWithHexString:@"#F8F8F8"];
}

+ (UIColor *)cc_buttonNormalBackgroundColor {
    return [UIColor colorWithHexString:@"#0095FF"];
}

/// 价格 的常用颜色
+ (UIColor *)cc_priceTextColor {
    return [UIColor colorWithHexString:@"#FF2E00"];
}

+ (UIColor *)cc_vipNormalColor {
    return [UIColor colorWithHexString:@"#CC8A00"];
}

/**
 button 禁用状态的背景颜色
 */
+ (UIColor *)cc_buttonInvalidBackgroundColor {
    return [UIColor colorWithHexString:@"#0095FF"];
}

+ (UIColor *)cc_buttonHighlightBackgroundColor {
    return [UIColor colorWithHexString:@"#337AB7"];
}

//+ (UIColor *)cc_buttonInvalidBackgroundColor {
//    return [UIColor colorWithHexString:@"f78971"];
//}

+ (UIColor *)cc_blackTextColor {
    return [UIColor colorWithHexString:@"#333333"];
}

+ (UIColor *)cc_darkTextColor {
    return [UIColor colorWithHexString:@"#666666"];
}

+ (UIColor *)cc_grayTextColor {
    return [UIColor colorWithHexString:@"#999999"];
}

+ (UIColor *)cc_backgroundColor {
    return [UIColor colorWithHexString:@"#476CFB"];
}

+ (UIColor *)cc_grayBackgroundColor {
    return [UIColor colorWithHexString:@"#F8F8F8"];
}

+ (UIColor *)cc_grayBorderColor {
    return [UIColor colorWithHexString:@"#D2D2D2"];
}

@end
