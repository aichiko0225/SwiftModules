//
//  UIImage+waterImage.h
//  CamaraTest
//
//  Created by aksskas on 2016/12/20.
//  Copyright © 2016年 aksskas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (waterImage)

/*绘制文字*/
+ (UIImage *)waterMarkImage: (UIImage *)image withName: (NSString *)name ;

/*合成图片*/
+ (UIImage *)addImage:(UIImage *)useImage addMaskImage:(UIImage *)maskImage;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

@end
