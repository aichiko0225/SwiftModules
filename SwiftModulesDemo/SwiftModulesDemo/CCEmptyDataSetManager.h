//
//  CCEmptyDataSetManager.h
//  CCEmptyDataSet
//
//  Created by 赵光飞 on 2020/8/27.
//  Copyright © 2020 赵光飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CCEmptyDataSet/CCEmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCEmptyDataSetManager : NSObject<UIAppearance, CCEmptyDataSetSource, CCEmptyDataSetDelegate>

typedef void(^EmptyDataSetTapView)(__kindof UIScrollView *scrollView, UIView *tapView, CCEmptyDataSetManager *manager);
typedef void(^EmptyDataSetTapButton)(__kindof UIScrollView *scrollView, UIButton *button, CCEmptyDataSetManager *manager);

// CCEmptyDataSetSource
/// 图片
@property(nonatomic, strong) UIImage *image UI_APPEARANCE_SELECTOR;
/// 图片tintColor
@property(nonatomic, strong) UIColor *imageTintColor UI_APPEARANCE_SELECTOR;
/// 图片动画。需要配合shouldAnimateImage一起使用
@property(nonatomic, strong) CAAnimation *imageAnimation UI_APPEARANCE_SELECTOR;

/// 标题
@property(nonatomic, strong) NSString *title UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *titleAttibutes UI_APPEARANCE_SELECTOR;

/// 详细信息
@property(nonatomic, strong) NSString *message UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *messageAttributes UI_APPEARANCE_SELECTOR;

/// 按钮图片
@property(nonatomic, strong) UIImage *buttonImage UI_APPEARANCE_SELECTOR;
/// 按钮背景图片
@property(nonatomic, strong) UIImage *buttonBackgroudImage UI_APPEARANCE_SELECTOR;
/// 按钮文字
@property(nonatomic, strong) NSString *buttonTitle UI_APPEARANCE_SELECTOR;

@property(nonatomic, strong) NSDictionary<NSAttributedStringKey,id> *buttonTitleAttributes UI_APPEARANCE_SELECTOR;


/// 竖直方向偏移。默认0
@property(nonatomic, assign) CGFloat verticalOffset UI_APPEARANCE_SELECTOR;
/// 每个控件间的间距。默认11
@property(nonatomic, assign) CGFloat spaceHeight UI_APPEARANCE_SELECTOR;

/// 背景颜色。默认whiteColor
@property(nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/// 自定义view。如果有值，那么上面的属性将会失效。默认nil
@property(nonatomic, strong) UIView *customView UI_APPEARANCE_SELECTOR;
/// 是否显示自定义view。默认YES
@property(nonatomic, assign, getter=isShowingCustomView) BOOL showCustomView UI_APPEARANCE_SELECTOR;

// CCEmptyDataSetDelegate
/// 是否显示。默认YES。
@property(nonatomic, assign) BOOL shouldDisplay UI_APPEARANCE_SELECTOR;

/// 是否以渐变的形式显示。默认YES
@property(nonatomic, assign) BOOL shouldFadeIn UI_APPEARANCE_SELECTOR;

/// 是否允许点击。默认YES
@property(nonatomic, assign) BOOL shouldAllowTouch UI_APPEARANCE_SELECTOR;

/// 是否能够滚动。默认NO
@property(nonatomic, assign) BOOL shouldAllowScroll UI_APPEARANCE_SELECTOR;

/// 是否旋转image。默认NO。如果想要旋转，imageAnimation 必须有值，同时shouldAnimateImage = YES。
@property(nonatomic, assign) BOOL shouldAnimateImage UI_APPEARANCE_SELECTOR;

/**
 是否强制显示。默认NO
 DZNEmptyDataSet作者的思路是：
 1、只有当-emptyDataSetShouldDisplay返回YES（对应EmptyDataSetManager的属性是shouldDisplay），并且scrolleView的item == 0的时候才会显示。
 2、当-emptyDataSetShouldBeForcedToDisplay对应EmptyDataSetManager的属性是shouldBeForcedToDisplay） 返回YES的时候，也会显示。
 详细代码如下 if (([self dzn_shouldDisplay] && [self dzn_itemsCount] == 0) || [self dzn_shouldBeForcedToDisplay]) { }。
 */
@property(nonatomic, assign) BOOL shouldBeForcedToDisplay UI_APPEARANCE_SELECTOR;

/// 点击view。shouldAllowTouch = YES 才有效
@property(nonatomic, copy) EmptyDataSetTapView emptyDataSetTapView;

/// 点击button。 有设置button才有效
@property(nonatomic, copy) EmptyDataSetTapButton emptyDataSetTapButton;

/**
 初始化
 @param image image
 @param title title
 @param message message
 @param buttonTitle buttonTitle
 @return instancetype
 */
+ (instancetype)emptyDataSetWithImage:(nullable UIImage *)image
                               title:(nullable NSString *)title
                             message:(nullable NSString *)message
                         buttonTitle:(nullable NSString *)buttonTitle;


/**
 更新内容。配合[scrollView reloadEmptyDataSet]；使用。
 @param image image
 @param title title
 @param message message
 @param buttonTitle buttonTitle
 */
- (void)updateEmptyDataSetImage:(nullable UIImage *)image
                         title:(nullable NSString *)title
                       message:(nullable NSString *)message
                   buttonTitle:(nullable NSString *)buttonTitle;

@property (class, nonatomic, strong, readonly) CCEmptyDataSetManager *sharedManager;

@end

NS_ASSUME_NONNULL_END
