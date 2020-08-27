//
//  NSLayoutConstraint+HHH.m
//  DFVehicleSteward
//
//  Created by 王立 on 2018/4/21.
//  Copyright © 2018年 ssi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NibLayoutTool.h"

/// 约束根据屏幕比例变化
@implementation NSLayoutConstraint (HHH)

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([NibLayoutTool sharedTool].shouldChangeLayout){
        float scale = (([UIScreen mainScreen].bounds.size.width/375) + ([UIScreen mainScreen].bounds.size.height/667))*0.5;
        self.constant = self.constant * scale;
    }
}

@end


