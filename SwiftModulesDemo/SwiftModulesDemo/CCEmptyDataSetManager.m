//
//  CCEmptyDataSetManager.m
//  CCEmptyDataSet
//
//  Created by 赵光飞 on 2020/8/27.
//  Copyright © 2020 赵光飞. All rights reserved.
//

#import "CCEmptyDataSetManager.h"

@implementation CCEmptyDataSetManager
static CCEmptyDataSetManager *_manager = nil;

+ (instancetype)sharedManager {
    if (!_manager) {
        _manager = [[CCEmptyDataSetManager alloc] init];
        
        _manager.titleAttibutes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        _manager.messageAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        _manager.buttonTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        
        _manager.spaceHeight = 11;
        _manager.verticalOffset = 0;
        _manager.backgroundColor = [UIColor whiteColor];
        
        _manager.shouldDisplay = YES;
        _manager.shouldAllowScroll = NO;
        _manager.shouldAllowTouch = YES;
        _manager.shouldFadeIn = YES;
        _manager.shouldAnimateImage = NO;
        _manager.shouldBeForcedToDisplay = NO;
        
        _manager.showCustomView = NO;
    }
    return _manager;
}

+ (instancetype)emptyDataSetWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    CCEmptyDataSetManager *manager = [[CCEmptyDataSetManager alloc] init];
    [manager initializes];
    [manager updateEmptyDataSetImage:image title:title message:message buttonTitle:buttonTitle];
    return manager;
}

- (void)updateEmptyDataSetImage:(UIImage *)image title:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    self.image = image;
    self.title = title;
    self.message = message;
    self.buttonTitle = buttonTitle;
}

- (void)initializes {
    
    self.image = [CCEmptyDataSetManager appearance].image;
    self.imageTintColor = [CCEmptyDataSetManager appearance].imageTintColor;
    self.imageAnimation = [CCEmptyDataSetManager appearance].imageAnimation;
    
    self.title = [CCEmptyDataSetManager appearance].title;
    self.message = [CCEmptyDataSetManager appearance].message;
    self.buttonTitle = [CCEmptyDataSetManager appearance].buttonTitle;
    self.titleAttibutes = [CCEmptyDataSetManager appearance].titleAttibutes;
    self.messageAttributes = [CCEmptyDataSetManager appearance].messageAttributes;
    self.buttonTitleAttributes = [CCEmptyDataSetManager appearance].buttonTitleAttributes;
    
    self.buttonImage = [CCEmptyDataSetManager appearance].buttonImage;
    self.buttonBackgroudImage = [CCEmptyDataSetManager appearance].buttonBackgroudImage;
    
    self.spaceHeight = [CCEmptyDataSetManager appearance].spaceHeight;
    self.verticalOffset = [CCEmptyDataSetManager appearance].verticalOffset;
    self.backgroundColor = [CCEmptyDataSetManager appearance].backgroundColor;
    
    
    self.shouldDisplay = [CCEmptyDataSetManager appearance].shouldDisplay;
    self.shouldAllowScroll = [CCEmptyDataSetManager appearance].shouldAllowScroll;
    self.shouldAllowTouch = [CCEmptyDataSetManager appearance].shouldAllowTouch;
    self.shouldFadeIn = [CCEmptyDataSetManager appearance].shouldFadeIn;
    self.shouldAnimateImage = [CCEmptyDataSetManager appearance].shouldAnimateImage;
    self.shouldBeForcedToDisplay = [CCEmptyDataSetManager appearance].shouldBeForcedToDisplay;
    
    self.customView = [CCEmptyDataSetManager appearance].customView;
    self.showCustomView = [CCEmptyDataSetManager appearance].showCustomView;
}

#pragma mark --- DZNEmptyDataSetDelegate & DZNEmptyDataSetSource
// image
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.image;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageTintColor;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageAnimation;
}

// title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.title.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.title attributes:self.titleAttibutes];
    }
    return nil;
}

// description
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.message.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.message attributes:self.messageAttributes];
    }
    return nil;
}

// button
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return self.buttonImage;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return self.buttonBackgroudImage;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.buttonTitle.length > 0) {
        return [[NSAttributedString alloc] initWithString:self.buttonTitle attributes:self.buttonTitleAttributes];
    }
    return nil;}

// contents
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.spaceHeight;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return self.backgroundColor;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.showCustomView) {
        return self.customView;
    }
    return nil;
}

/// delegate
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return self.shouldFadeIn;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.shouldDisplay;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return self.shouldAllowTouch;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return self.shouldAllowScroll;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.shouldAnimateImage;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return self.shouldBeForcedToDisplay;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    !self.emptyDataSetTapView?:self.emptyDataSetTapView(scrollView, view, self);
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    !self.emptyDataSetTapButton?:self.emptyDataSetTapButton(scrollView, button, self);
}

#pragma mark - UIAppearance

+ (nonnull instancetype)appearance {
    return [CCEmptyDataSetManager sharedManager];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
    return [CCEmptyDataSetManager sharedManager];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    return [CCEmptyDataSetManager sharedManager];
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return [CCEmptyDataSetManager sharedManager];
}

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    return [CCEmptyDataSetManager sharedManager];
}

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    return [CCEmptyDataSetManager sharedManager];
}

@end
