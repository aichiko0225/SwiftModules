//
//  UILabel+FontScaleLabel.m
//  DFVehicleSteward
//
//  Created by 王立 on 2018/4/21.
//  Copyright © 2018年 ssi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NibLayoutTool.h"

/// UILabel字体大小根据屏幕比例变化
@implementation UILabel (FontScale)
- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([NibLayoutTool sharedTool].shouldChangeLayout){
        UIFontDescriptor *des = self.font.fontDescriptor;
        float scale = (([UIScreen mainScreen].bounds.size.width/375) + ([UIScreen mainScreen].bounds.size.height/667))*0.5;
        UIFont *font = [UIFont fontWithDescriptor:des size:[[des objectForKey:UIFontDescriptorSizeAttribute] floatValue] * scale];
        [self setFont:font];
    }
}
@end

@implementation UIButton (FontScale)
- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([NibLayoutTool sharedTool].shouldChangeLayout){
        UIFontDescriptor *des = self.titleLabel.font.fontDescriptor;
        float scale = (([UIScreen mainScreen].bounds.size.width/375) + ([UIScreen mainScreen].bounds.size.height/667))*0.5;
        UIFont *font = [UIFont fontWithDescriptor:des size:[[des objectForKey:UIFontDescriptorSizeAttribute] floatValue] * scale];
        self.titleLabel.font = font;
    }
}
@end

@implementation UITextField (FontScale)
- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([NibLayoutTool sharedTool].shouldChangeLayout){
        UIFontDescriptor *des = self.font.fontDescriptor;
        float scale = (([UIScreen mainScreen].bounds.size.width/375) + ([UIScreen mainScreen].bounds.size.height/667))*0.5;
        UIFont *font = [UIFont fontWithDescriptor:des size:[[des objectForKey:UIFontDescriptorSizeAttribute] floatValue] * scale];
        self.font = font;
    }
}
@end

@implementation UITextView (FontScale)
- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([NibLayoutTool sharedTool].shouldChangeLayout){
        UIFontDescriptor *des = self.font.fontDescriptor;
        float scale = (([UIScreen mainScreen].bounds.size.width/375) + ([UIScreen mainScreen].bounds.size.height/667))*0.5;
        UIFont *font = [UIFont fontWithDescriptor:des size:[[des objectForKey:UIFontDescriptorSizeAttribute] floatValue] * scale];
        self.font = font;
    }
}
@end
