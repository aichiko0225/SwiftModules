//
//  NSString+Addition.h
//  Category
//
//  Created by ash on 2018/12/26.
//  Copyright © 2018 ash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Addition)

- (NSString *)URLDecode;
- (NSString *)URLEncode;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString *)appVersionString;

- (BOOL)isPhoneNumber;

+(NSString *)reviseString:(NSString *)str;

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(CGFloat)fontSize maxSize:(CGSize)maxSize;

- (CGSize)sizeWithMaxSize:(CGSize)maxSize attribute:(NSDictionary<NSString *, id> *)attribute;

@end

NS_ASSUME_NONNULL_END
