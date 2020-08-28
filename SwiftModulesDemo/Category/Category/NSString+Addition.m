//
//  NSString+Addition.m
//  Category
//
//  Created by ash on 2018/12/26.
//  Copyright © 2018 ash. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommonMethods.h"

@implementation NSString (Addition)

- (NSString *)URLDecode {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)URLEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]% "].invertedSet];
}

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (BOOL)isPhoneNumber {
    //    NSString *phoneExp = @"^((13[0-9])|(15[^4])|(18[0-9])|(17[0-8])|(147,145))\\d{8}$";
    NSString *phoneExp = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneExp];
    return [phoneTest evaluateWithObject:self];
}

+ (NSString *)reviseString:(NSString *)str {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

//返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(CGFloat)fontSize maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return size;
}

- (CGSize)sizeWithMaxSize:(CGSize)maxSize attribute:(NSDictionary<NSString *, id> *)attribute {
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return size;
}


@end

