//
//  YQGuideView.m
//  YaoTiA
//
//  Created by Midas on 2019/4/24.
//  Copyright © 2019 麦都. All rights reserved.
//

#import "YQGuideView.h"

@interface YQGuideView()

@property (nonatomic, assign) CGFloat winRadius;

@end

@implementation YQGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSet];
    }
    return self;
}

- (void)initSet {
    UIView *windown = [[self class] keyWindow];
    CGRect frame = windown.bounds;
    self.frame = frame;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [windown addSubview:self];
}

- (instancetype)initWithView:( UIView *)view {
    
    self = [[[self class] alloc] init];
    if (self) {
     self.view = view;
    }
    return self;
}

- (instancetype)initWithNavigationBar:(UINavigationBar *)bar buttonItem:(UIBarButtonItem *)buttonItem {
    UIView *view = [self viewWithNavigationBar:bar buttonItem:buttonItem];
    if (view) {
        return [self initWithView:view];
    }
    return nil;
}

- (instancetype)initWithTabBar:(UITabBar *)bar index:(NSInteger)index {
    UIView *view = [self viewWithTabBar:bar index:index];
    if (view) {
        return [self initWithView:view];
    }
    return nil;
}


+ (UIView *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (void)setView:(UIView *)view {
    _view = view;
    if (_view) {
        _winRadius = view.layer.cornerRadius;
        _winFrame = [view.superview convertRect:view.frame toView:[[self class] keyWindow]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_maskLayer) {
        self.layer.mask = _maskLayer;
        if (_dottedLineEdge) {
            // 添加边缘虚线
            [self aroundForLayerWithFrame:frame radius:corner];
        }
    }
}

- (void)setOffset:(UIEdgeInsets)offset {
    _offset = offset;
    
    if (CGRectIsNull(_winFrame)) {
        return;
    }
    CGFloat x = _winFrame.origin.x + _offset.left;
    CGFloat y = _winFrame.origin.y + _offset.top;
    CGFloat width = _winFrame.size.width + _offset.right - _offset.left;
    CGFloat height = _winFrame.size.height + _offset.bottom - _offset.top;
    _winFrame = CGRectMake(x, y, width, height);
}

#pragma mark - 触摸视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_selectBlock) {
        _selectBlock();
        _selectBlock  = nil;
    }
    [self removeFromSuperview];
}

#pragma mark - 蒙版layer
- (CAShapeLayer *)layerWithFrame:(CGRect)frame cornerRadius:(YQWinCornerType)corner {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    UIBezierPath *radius = [self bezierPathWithFrame:frame radius:corner clockwise:NO];
    [path appendPath:radius];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.99].CGColor;
    return maskLayer;
}

#pragma mark - 路径path
- (UIBezierPath *)bezierPathWithFrame:(CGRect)frame radius:(YQWinCornerType)corner clockwise:(BOOL)clockwise {
    UIBezierPath *radius;
    if (corner == YQWinCornerTypeNone) {
        radius = [self roundRect:frame clockwise:clockwise];
    } else if (corner == YQWinCornerTypeRadius) {
        radius = [self arcPathWithFrame:frame clockwise:clockwise];
    } else {
        radius = [self cornersRoundWithFrame:frame cornerRadiu:corner dottedLine:_dottedLineEdge clockwise:clockwise];
    }
    return radius;
}

#pragma mark - 添加边缘虚线
- (void)aroundForLayerWithFrame:(CGRect)frame radius:(YQWinCornerType)corner {
    // 添加虚线环绕
    CAShapeLayer *aroundLayer = [CAShapeLayer layer];
    aroundLayer.strokeColor = [UIColor whiteColor].CGColor;
    aroundLayer.fillColor = [UIColor clearColor].CGColor;
    aroundLayer.lineWidth = 2.0;
    aroundLayer.lineDashPattern = @[@3, @1.5];
    UIBezierPath *path = [self bezierPathWithFrame:frame radius:corner clockwise:YES];
    aroundLayer.path = path.CGPath;
    [self.layer addSublayer:aroundLayer];
    
}

- (UIBezierPath *)arcPathWithFrame:(CGRect)frame clockwise:(BOOL)clockwise {
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGPoint center = CGPointMake(frame.origin.x + width/2, frame.origin.y + height/2);
    CGFloat radius = width > height?height/2: width/2;
    //clockwise 要为NO 是反绘制
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:clockwise];
    
    return path;
}

- (UIBezierPath *)roundRect:(CGRect)frame clockwise:(BOOL)clockwise {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 需要反方向绘制
    if (!clockwise) {
        path = [path bezierPathByReversingPath];
    }
    return path;
}

- (UIBezierPath *)cornersRoundWithFrame:(CGRect)frame cornerRadiu:(YQWinCornerType)cornerRadius dottedLine:(BOOL)add clockwise:(BOOL)clockwise {
    if (_winRadius == 0.0) {
        _winRadius = 5;
    }
    CGFloat ra = frame.size.width > frame.size.height ? frame.size.height: frame.size.width;
    CGFloat radius = cornerRadius == YQWinCornerTypeEllipse ? ra/2: _winRadius;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius];
    // 需要反方向绘制
    if (!clockwise) {
        path = [path bezierPathByReversingPath];
    }

    return path;
}

#pragma mark - tabBar获取view


#pragma mark - navigationBar获取view
- (UINavigationController *)navigationController {
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)next;
            return vc.navigationController;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

- (UIView *)viewWithNavigationBar:(UINavigationBar *)bar buttonItem:(UIBarButtonItem *)buttonItem {
    if (!bar) {
        return nil;
    }
    // customView 创建的view
    if (buttonItem.customView) {
        return buttonItem.customView;
    }
    NSMutableArray *all_itemViews = [self itemViewsWithNavBar:bar];
    
    UINavigationItem *item = bar.items.firstObject;
    NSMutableArray *itemViews;
    NSInteger idex = 0;
    if ([item.leftBarButtonItem isEqual:buttonItem]) {
        itemViews = all_itemViews[0];
    } else if ([item.rightBarButtonItem isEqual:buttonItem]) {
        itemViews = all_itemViews[1];
    } else if ([item.leftBarButtonItems containsObject:buttonItem]) {
        idex = [item.leftBarButtonItems indexOfObject:buttonItem];
        itemViews = all_itemViews[0];
    } else if ([item.rightBarButtonItems containsObject:buttonItem]) {
        idex = [item.rightBarButtonItems indexOfObject:buttonItem];
        itemViews = all_itemViews[1];
    }
    if (itemViews.count == 0) {
        return nil;
    }
    return itemViews[idex];
}


- (NSMutableArray<NSMutableArray *> *)itemViewsWithNavBar:(UINavigationBar *)bar {
    
    // 不考虑多层的items
    UINavigationItem *item = bar.items.firstObject;
    NSMutableArray *itemViews = @[].mutableCopy;
    __block NSMutableArray *leftViews = @[].mutableCopy;
    __block NSMutableArray *rightViews = @[].mutableCopy;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) { // iOS11 以上
        
        __block NSMutableArray *stackViews = @[].mutableCopy;
        
        [bar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull OBJ, NSUInteger IDX, BOOL * _Nonnull STOP) {
            
            [OBJ.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([NSStringFromClass(obj.class) isEqualToString:@"_UIButtonBarStackView"]) {
                    [stackViews addObject:obj];
                }
            }];
        }];
        
        if (stackViews.count == 1) { // 只有一边有item
            UIView *stackView = stackViews.firstObject;
            if (item.leftBarButtonItems.count > 0 || item.leftBarButtonItem) {
                [leftViews addObjectsFromArray:[self subButtonItemWithStackView:stackView]];
            } else if (item.rightBarButtonItems.count > 0 || item.rightBarButtonItem) {
                [rightViews addObjectsFromArray:[self subButtonItemWithStackView:stackView]];
            }
            
        } else { // 左右都有
            for (int i = 0; i < stackViews.count; i ++) {
                UIView *stackView = stackViews[i];
                if (i == 0) {
                    [leftViews addObjectsFromArray:[self subButtonItemWithStackView:stackView]];
                } else if (i == 1) {
                    [rightViews addObjectsFromArray:[self subButtonItemWithStackView:stackView]];
                }
            }
        }
        
    } else { // iOS 11 以下
        
        for (int i = 0; i < bar.subviews.count; i ++) {
            UIView *t_view = bar.subviews[i];
            NSString *class = NSStringFromClass(t_view.class);
            //_UINavigationBarBackIndicatorView 通过层级结构可以看出有这个view。
            if (![class isEqualToString:@"_UINavigationBarBackIndicatorView"]) {
                
                // 一个情况下
                if (item.leftBarButtonItems.count == 0 && item.leftBarButtonItem) {
                    if (i == 0) {
                        [leftViews addObject:t_view];
                    } else {
                        [rightViews addObject:t_view];
                    }
                    
                } else if (item.rightBarButtonItems.count == 0 && item.rightBarButtonItem) {
                    if (i == bar.subviews.count - 1) {
                        [rightViews addObject:t_view];
                    } else {
                        [leftViews addObject:t_view];
                    }
                    
                } else {
                    if (i < item.leftBarButtonItems.count) {
                        [leftViews addObject:t_view];
                    } else {
                        [rightViews addObject:t_view];
                    }
                }
            }
        }
    }
    
    // rightItem 需要反向
    rightViews = [rightViews.reverseObjectEnumerator allObjects].mutableCopy;
    [itemViews addObject:leftViews];
    [itemViews addObject:rightViews];
    return itemViews;
}

- (NSMutableArray<UIView *> *)subButtonItemWithStackView:(UIView *)stackView {
    if (![NSStringFromClass(stackView.class) isEqualToString:@"_UIButtonBarStackView"]) {
        return nil;
    }
    __block NSMutableArray *subViews = @[].mutableCopy;
    [stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *classStr = NSStringFromClass(obj.class);
        NSLog(@"classStr %@", classStr);
        if ([classStr isEqualToString:@"_UIButtonBarButton"] || [classStr isEqualToString:@"_UITAMICAdaptorView"]) {
            [subViews addObject:obj];
        }
    }];
    return subViews;
}

#pragma mark - tabBar 获取view
- (UIView *)viewWithTabBar:(UITabBar *)bar index:(NSInteger)index {
    if (!bar) {
        return nil;
    }
    NSMutableArray * tabbarBtns = @[].mutableCopy;
    for (UIView *subView in bar.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITabBarButton"]) {
            [tabbarBtns addObject:subView];
        }
    }
    if (index >= tabbarBtns.count) {
        return nil;
    }
    UIView * indexView = tabbarBtns[index];
    return indexView;
}



@end


