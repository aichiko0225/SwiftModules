//
//  UIImage+waterImage.m
//  CamaraTest
//
//  Created by aksskas on 2016/12/20.
//  Copyright © 2016年 aksskas. All rights reserved.
//

#import "UIImage+waterImage.h"

@implementation UIImage (waterImage)

/**
 绘制文字，文字是平行加在图片上的

 @param image 原始图片
 @param name 添加的文字
 @return 添加水印后的图片
 */
+ (UIImage *)waterMarkImage: (UIImage *)image withName: (NSString *)name {
    
    NSString * mark = name ;
    
    float w = image.size.width;
    float h = image.size.height;
    
    UIGraphicsBeginImageContext(image.size) ;
    
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    NSDictionary *attr = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:28],
                           NSForegroundColorAttributeName : [UIColor redColor]
                           } ;
    [mark drawInRect:CGRectMake(w/20, h/30, 9*w/10, w/2) withAttributes:attr];
//    [mark drawInRect:CGRectMake(w - 10  , 0, 10, 10) withAttributes:attr];
//    [mark drawInRect:CGRectMake(0, h-10, 10, 10) withAttributes:attr];
//    [mark drawInRect:CGRectMake(w - 10, h - 10, 10, 10) withAttributes:attr];
    
    UIImage * aimge = UIGraphicsGetImageFromCurrentImageContext() ;
    
    UIGraphicsEndImageContext() ;
    
    return  aimge ;
    
}


/**
 需要美工图片

 @param useImage 原始图片
 @param maskImage 水印图片
 @return 编辑后的图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addMaskImage:(UIImage *)maskImage {
    
    UIGraphicsBeginImageContextWithOptions(useImage.size, NO, 0.0);
    
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    //水印图片的位置
    [maskImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height/2)];
    
    [maskImage drawInRect:CGRectMake(0, useImage.size.height/2,useImage.size.width,useImage.size.height/2)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

/** 纠正图片的方向 */
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}
    

@end
