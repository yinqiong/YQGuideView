# YQGuideView

[![CI Status](https://img.shields.io/travis/yinqiong/YQGuideView.svg?style=flat)](https://travis-ci.org/yinqiong/YQGuideView)
[![Version](https://img.shields.io/cocoapods/v/YQGuideView.svg?style=flat)](https://cocoapods.org/pods/YQGuideView)
[![License](https://img.shields.io/cocoapods/l/YQGuideView.svg?style=flat)](https://cocoapods.org/pods/YQGuideView)
[![Platform](https://img.shields.io/cocoapods/p/YQGuideView.svg?style=flat)](https://cocoapods.org/pods/YQGuideView)

## Example
考虑到UI设计层面每个App 都有自己的风格，该view，只提供最简单的显示，如果要更多功能，可以pod下来继承
比如：
    // 给某个cell中一个view做引导 YQPageGuideWindow，继承自YQGuideView
    
    YQPageGuideWindow *guide = [[YQPageGuideWindow alloc] initWithView:taskCell.taskView];
    // 边缘间距
    guide.offset = UIEdgeInsetsMake(-5, -5, -taskCell.taskView.avgTimeInfoView.top, 5);
    // 缕空显示的类型，这里是圆角
    guide.cornerType = YQWinCornerTypeRound;
    // 引导做介绍的图
    UIImage *image = [UIImage imageNamed:@"pic_mock_report_new_function_default"];
    CGFloat x = 29;
    // winFrame记录了当前缕空的实际frame，这里用于iamgeView的计算
    CGFloat y = guide.winFrame.origin.y + guide.winFrame.size.height + 10;
    CGRect frame = CGRectMake(x, y, image.size.width, image.size.height);
    // 添加iamgeView
    [guide appendAnnotatedImage:image frame:frame];



## Requirements

## Installation

YQGuideView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YQGuideView'
```

## Author

yinqiong, yinqiong04@163.com

## License

YQGuideView is available under the MIT license. See the LICENSE file for more info.
