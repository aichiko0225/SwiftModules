//
//  UIFont+Addition.h
//  Category
//
//  Created by ash on 2018/12/26.
//  Copyright © 2018 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition)

+ (UIFont *)cc_setBoldFont:(CGFloat)size;

+ (UIFont *)setNormalFont:(CGFloat)size;

+ (UIFont *)setNormalBoldFont:(CGFloat)size;

+ (UIFont *)cc_setfont:(CGFloat)size;

+ (UIFont *)cc_setfont:(CGFloat)size fontFamily:(NSString *)fontFamily;

@end

NS_ASSUME_NONNULL_END
