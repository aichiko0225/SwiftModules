//
//  UIImage+SubImage.h
//  UIImage+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SubImage)

/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
/// 把secondImage覆盖到firstImage上面
/// 覆盖到哪个角
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage inCorner:(UIRectCorner)corner;



/** UIImage等比例缩放 */
-(UIImage *)scaleImageToScale:(CGFloat)scaleSize;


/** 将图片压缩到某个范围内 */
-(NSData*)getCompressImageWithMaxFileSize:(CGFloat)maxFileSize;
/**
 * 获取圆形图片
 */
-(UIImage *)circleImage ;


@end
