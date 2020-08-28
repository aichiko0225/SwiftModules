//
//  UIColor+Addition.h
//  Category
//
//  Created by ash on 2018/12/25.
//  Copyright © 2018 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Addition)

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size;

+ (UIImage *)cc_gradedImage:(UIColor *)startColor endColor:(UIColor *)endColor rect:(CGRect)rect;

+ (UIImage *)cc_animatedGIFWithData:(NSData *)data;

/**
 *  生成指定图片尺寸的纯色图片
 *  @param color 颜色变为图片 size  图片尺寸
 *  @return 新的Image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 生成圆形图片
 
 @param color 颜色变为图片
 @param size  图片尺寸
 @return 新的Image
 */
+ (UIImage *)circularImageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)cc_imageWithTintColor:(UIColor *)tintColor;

@end

@interface UIColor (Addition)

+ (UIColor*)colorWithHexString:(NSString *)hexString;

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

#pragma mark - 通用属性

+ (UIColor *)cc_buttonBackgroundColor;
/**
 button 通用状态的背景颜色
 */
+ (UIColor *)cc_buttonNormalBackgroundColor;
/**
 button 禁用状态的背景颜色
 */
+ (UIColor *)cc_buttonInvalidBackgroundColor;

/**
 button 点击状态的背景颜色
 */
+ (UIColor *)cc_buttonHighlightBackgroundColor;

+ (UIColor *)cc_itemGrayBackgroundColor;

+ (UIColor *)cc_tableViewBackgroundColor;

/// 价格 的常用颜色
+ (UIColor *)cc_priceTextColor;

+ (UIColor *)cc_vipNormalColor;

+ (UIColor *)cc_backgroundColor;

+ (UIColor *)cc_grayBackgroundColor;

+ (UIColor *)cc_blackTextColor;

+ (UIColor *)cc_darkTextColor;

+ (UIColor *)cc_grayTextColor;

+ (UIColor *)cc_grayBorderColor;

@end

NS_ASSUME_NONNULL_END
