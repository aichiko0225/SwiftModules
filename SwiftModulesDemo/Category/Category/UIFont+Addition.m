//
//  UIFont+Addition.m
//  Category
//
//  Created by ash on 2018/12/26.
//  Copyright © 2018 ash. All rights reserved.
//

#import "UIFont+Addition.h"
#import "CommonMethods.h"

typedef NS_ENUM(NSInteger, FontWeightStyle) {
    FontWeightStyleMedium, // 中黑体
    FontWeightStyleSemibold, // 中粗体
    FontWeightStyleLight, // 细体
    FontWeightStyleUltralight, // 极细体
    FontWeightStyleRegular, // 常规体
    FontWeightStyleThin, // 纤细体
};

NSString *fontFamilyName(FontWeightStyle style) {
    NSString *fontName = @"PingFangSC-Regular";
    switch (style) {
        case FontWeightStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case FontWeightStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case FontWeightStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case FontWeightStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case FontWeightStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case FontWeightStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }
    return fontName;
}

UIFont * fontWith(NSString *fontFamilyName, CGFloat size, BOOL isNormal) {
    if (isNormal) {
        
    } else {
        
        
        
    }
    
    return nil;
}

#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)
#define kWindowScale (kWindowWidth/375.0)

CGFloat realSize(CGFloat size) {
    CGFloat realSize;
    NSString *name = deviceName();
    if ([name isEqualToString:@"iPod"]) {
        realSize = size;
    }else if ([name isEqualToString:@"iPad"]) {
        realSize = size;
    }else if ([name isEqualToString:@"iPhone"]) {
        realSize = ([UIScreen mainScreen].bounds.size.width>375) ? (size*kWindowScale): size*kWindowScale;
    }else if ([name isEqualToString:@"Unknown"]) {
        realSize = size*kWindowScale;
    }else if ([name isEqualToString:@"Simulator"]) {
        realSize = size*kWindowScale;
    }else {
        realSize = size*kWindowScale;
    }
    return realSize;
}

@implementation UIFont (Addition)

+ (UIFont *)setNormalFont:(CGFloat)size {
    NSString *fontFamily = fontFamilyName(FontWeightStyleRegular);
    UIFont *font = [UIFont fontWithName:fontFamily size:realSize(size)];
    return font ?: [UIFont systemFontOfSize:realSize(size)];
}

+ (UIFont *)setNormalBoldFont:(CGFloat)size {
    NSString *fontFamily = fontFamilyName(FontWeightStyleMedium);
    UIFont *font = [UIFont fontWithName:fontFamily size:realSize(size)];
    return font ?: [UIFont systemFontOfSize:realSize(size)];
}

+ (UIFont *)cc_setBoldFont:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:realSize(size)];
}

+ (UIFont *)cc_setfont:(CGFloat)size {
    return [UIFont systemFontOfSize:realSize(size)];
}

+ (UIFont *)cc_setfont:(CGFloat)size fontFamily:(NSString *)fontFamily {

    if (fontFamily == nil) {
        fontFamily = @"PingFang-SC-Regular";
    }
    UIFont *font = [UIFont fontWithName:fontFamily size:realSize(size)];
    if (font) {
        return font;
    }
    return [UIFont cc_setfont:size];
}

@end

