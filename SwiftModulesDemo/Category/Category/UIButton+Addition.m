//
//  UIButton+Addition.m
//  Category
//
//  Created by ash on 2018/12/27.
//  Copyright © 2018 ash. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)

- (void)layoutButtonSpace:(CGFloat)space {
    [self layoutButton:EdgeInsetsStyleLeft space:space];
}
- (void)layoutButton:(EdgeInsetsStyle)style space:(CGFloat)space {
    if (self.imageView == nil) {
        return;
    }
    
    UIImageView *imageView = self.imageView;
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWidth = imageView.frame.size.width;
    CGFloat imageHeight = imageView.frame.size.height;
    
    CGFloat imageWidth_new = imageView.intrinsicContentSize.width;
    CGFloat imageHeight_new = imageView.intrinsicContentSize.height;
    
    NSLog(@"%@", [self imageForState:UIControlStateNormal]);
    
    if (imageWidth == 0 && imageWidth_new > 0) {
        imageWidth = imageWidth_new;
        imageHeight = imageHeight_new;
    }
    
    NSLog(@"%f, %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    NSLog(@"%f, %f", self.imageView.intrinsicContentSize.width, self.imageView.intrinsicContentSize.height);
    CGFloat labelWidth;
    CGFloat labelHeight;
    
    labelWidth = self.titleLabel.intrinsicContentSize.width;
    labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    switch (style) {
        case EdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-space/2.0, 0);
            break;
        case EdgeInsetsStyleLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            break;
        case EdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWidth, 0, 0);
            break;
        case EdgeInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-space/2.0, 0, imageWidth+space/2.0);
            break;
            
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    
}

@end
