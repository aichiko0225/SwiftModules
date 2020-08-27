//
//  UIImage+SubImage.m
//  UIImage+Categories
//
//  Created by lisong on 16/9/4.
//  Copyright © 2016年 lisong. All rights reserved.
//

#import "UIImage+SubImage.h"

#import <CoreImage/CoreImage.h>

@implementation UIImage (SubImage)

#pragma mark - 截取当前image对象rect区域内的图像
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
   
    return newImage;
}

//截取部分图像
//-(UIImage*)subImageWithRect:(CGRect)rect
//{
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    
//    return smallImage;
//}

#pragma mark - 压缩图片至指定尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    CGSize size = self.size;
    
    if(size.width <= toPX && size.height <= toPX)
    {
        return self;
    }
    
    CGFloat scale = size.width / size.height;
    
    if(size.width > size.height)
    {
        size.width = toPX;
        size.height = size.width / scale;
    }
    else
    {
        size.height = toPX;
        size.width = size.height * scale;
    }
    
    return [self rescaleImageToSize:size];
}

#pragma mark - 指定大小生成一个平铺的图片
- (UIImage *)getTiledImageWithSize:(CGSize)size
{
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

#pragma mark - UIView转化为UIImage
+ (UIImage *)imageFromView:(UIView *)view
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 将两个图片生成一张图片
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage inCorner:(UIRectCorner)corner
{
    
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    switch (corner) {
        case UIRectCornerTopLeft:
            [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
            break;
        case UIRectCornerTopRight:
            [secondImage drawInRect:CGRectMake(firstWidth-secondWidth, 0, secondWidth, secondHeight)];
            break;
        case UIRectCornerBottomLeft:
            [secondImage drawInRect:CGRectMake(0, firstHeight-secondHeight, secondWidth, secondHeight)];
            break;
        case UIRectCornerBottomRight:
            [secondImage drawInRect:CGRectMake(firstWidth-secondWidth, firstHeight-secondHeight, secondWidth, secondHeight)];
            break;
        default:
            break;
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//UIImage等比例缩放
-(UIImage *)scaleImageToScale:(CGFloat)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

//压缩图片，任意大小的图片压缩到100K以内
//压缩图像
+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
//将图片压缩到某个范围内
-(NSData*)getCompressImageWithMaxFileSize:(CGFloat)maxFileSize{

    NSData *imageData = UIImageJPEGRepresentation(self, 1.0) ;

    CGFloat compression = 0.9;
    CGFloat maxCompression = 0.1;
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        imageData = UIImageJPEGRepresentation(self, compression);
        compression -= 0.1;
    }
    
    
    return imageData;
}
/**
 * 获取圆形图片
 */
-(UIImage *)circleImage{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0) ;
     //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext() ;
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height) ;
    
    CGContextAddEllipseInRect(ctx, rect) ;
    //裁剪
    CGContextClip(ctx) ;
    //将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;


    return image ;
}


@end
