//
//  YQGuideView.h
//  YaoTiA
//
//  Created by Midas on 2019/4/24.
//  Copyright © 2019 麦都. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 曝光显示类型

 - YQWinCornerTypeNone: 默认正方形
 - YQWinCornerTypeRadius: 圆形
 - YQWinCornerTypeRound: 圆角
 - YQWinCornerTypeEllipse: 椭圆
 */
typedef NS_ENUM(NSInteger, YQWinCornerType){
    YQWinCornerTypeNone = 0,
    YQWinCornerTypeRadius = 1,
    YQWinCornerTypeRound = 2,
    YQWinCornerTypeEllipse = 3
};

@interface YQGuideView : UIView

/**
 蒙版
 */
@property (nonatomic, strong) CAShapeLayer *maskLayer;

/**
 聚焦的视图， 如果为nil，就是没有聚焦的视图
 */
@property (nonatomic, weak) UIView *view;

/**
 聚焦视图窗口的偏移量
 */
@property (nonatomic, assign) UIEdgeInsets offset;

/**
 聚焦窗口的frame
 注意:
    1. 如果 offset == zero && view ！= nil， winFrame = view.frame
    2. 如果引导上有其它 子视图，需要计算与聚焦窗口的相对位置，应该使用winFrame
 */
@property (nonatomic, assign) CGRect winFrame;

/**
 聚焦边缘是否虚线显示
 */
@property (nonatomic, assign) BOOL dottedLineEdge;

/**
 聚焦窗口类型
 */
@property (nonatomic, assign) YQWinCornerType cornerType;

/**
 点击回调
 */
@property (nonatomic, copy) void(^selectBlock)(void);


/**
 普通view视图引导

 @param view 被引导的视图
 @return self
 */
- (instancetype)initWithView:(UIView *)view;

/**
 UIBarButtonItem 的视图引导

 @param buttonItem 被引导的item
 @return self
 */
- (instancetype)initWithNavigationBar:(UINavigationBar *)bar buttonItem:(UIBarButtonItem *)buttonItem;

/**
 
UITabBarItem 的视图引导
 @param index 第几个
 @return self
 */
- (instancetype)initWithTabBar:(UITabBar *)bar index:(NSInteger)index;

/**
 获取蒙版

 @param frame 萌版区域
 @param corner 窗口展示样式
 @return layer
 */
- (CAShapeLayer *)layerWithFrame:(CGRect)frame cornerRadius:(YQWinCornerType)corner;


/**
 获取一个绘制聚焦窗口的路径

 @param frame 区域
 @param corner 展示样式
 @param clockwise 是否反转
 @return 贝塞尔曲线
 */
- (UIBezierPath *)bezierPathWithFrame:(CGRect)frame radius:(YQWinCornerType)corner clockwise:(BOOL)clockwise;

/**
 添加聚焦窗口边缘虚线

 @param frame 区域
 @param corner 展示方式
 */
- (void)aroundForLayerWithFrame:(CGRect)frame radius:(YQWinCornerType)corner;


@end

NS_ASSUME_NONNULL_END
