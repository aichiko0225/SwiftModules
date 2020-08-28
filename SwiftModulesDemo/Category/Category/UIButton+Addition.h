//
//  UIButton+Addition.h
//  Category
//
//  Created by ash on 2018/12/27.
//  Copyright © 2018 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// button的样式布局
///
/// - top: // image在上，label在下
/// - left: image在左，label在右
/// - bottom: image在下，label在上
/// - right: image在右，label在左

typedef NS_ENUM(NSInteger, EdgeInsetsStyle) {
    EdgeInsetsStyleTop,
    EdgeInsetsStyleLeft,
    EdgeInsetsStyleBottom,
    EdgeInsetsStyleRight
};

@interface UIButton (Addition)

- (void)layoutButtonSpace:(CGFloat)space;
- (void)layoutButton:(EdgeInsetsStyle)style space:(CGFloat)space;

@end


NS_ASSUME_NONNULL_END
