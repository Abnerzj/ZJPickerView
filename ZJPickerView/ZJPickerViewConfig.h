//
//  ZJPickerViewConfig.h
//  ZJPickerViewConfig <https://github.com/Abnerzj/ZJPickerView>
//
//  Created by Abnerzj on 2020/10/17.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kZJPickerViewDefaultThemeColor [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] // 默认主题颜色

@interface ZJPickerViewConfig : NSObject


/////////////////////////////////// 蒙层视图（maskView）/////////////////////////////////

/** 蒙版视图透明度, default 0.5(0.0~1.0) */
@property (nonatomic, assign) CGFloat maskAlpha;

/** 是否点击蒙版隐藏, default NO */
@property (nonatomic, assign) BOOL isTouchMaskHide;


/////////////////////////////////// 选择器（pickerView）/////////////////////////////////

/** 设置 pickerView 的高度，系统默认高度为 216 */
@property (nonatomic, assign) CGFloat pickerViewHeight;

/** 设置 pickerView 的行高, default 32 pt */
@property (nonatomic, assign) CGFloat rowHeight;

/** 设置 pickerView 的选中行属性 */
@property (nonatomic, copy) NSDictionary *selectRowTitleAttribute;

/** 设置 pickerView 的未选中行属性 */
@property (nonatomic, copy) NSDictionary *unSelectRowTitleAttribute;

/** 设置 pickerView 中间两条分割线的背景颜色 */
@property (nonatomic, strong) UIColor *separatorColor;

/** 设置 pickerView 将要显示时是否滚动到已选择内容那一行, default NO */
@property (nonatomic, assign) BOOL isScrollToSelectedRow;


/////////////////////////////////// 确定按钮（sureBtn）//////////////////////////////////

/** 设置 sureBtn 的 title */
@property (nullable, nonatomic, copy) NSString *sureBtnTitle;

/** 设置 sureBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *sureTextColor;

/** 设置 sureBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *sureTextFont;


/////////////////////////////////// 取消按钮（cancelBtn）//////////////////////////////

/** 设置 cancelBtn 的 title */
@property (nullable, nonatomic, copy) NSString *cancelBtnTitle;

/** 设置 cancelBtn 标题的颜色 */
@property (nullable, nonatomic, strong) UIColor *cancelTextColor;

/** 设置 cancelBtn 标题的字体 */
@property (nullable, nonatomic, strong) UIFont *cancelTextFont;


/////////////////////////////////// 标题栏中间label（titleLabel）///////////////////////////

/** 设置 titleLabel 的 text（重要提示：多列时建议已选择的内容用英文逗号隔开，参考`ZJPickerViewPropertyIsDividedSelectContentKey`这个key） */
@property (nullable, nonatomic, copy) NSString *titleLabelText;

/** 设置 titleLabel 文本颜色 */
@property (nullable, nonatomic, strong) UIColor *titleTextColor;

/** 设置 titleLabel 字体大小 */
@property (nullable, nonatomic, strong) UIFont *titleTextFont;

/** 设置 titleBarView 标题栏底部分割线颜色 */
@property (nullable, nonatomic, strong) UIColor *titleLineColor;

/** 多列时，选中内容的分隔符，默认英文逗号 */
@property (nullable, nonatomic, copy) NSString *dividedSymbol;

/** 是否分隔已选择的内容, default NO */
@property (nonatomic, assign) BOOL isDividedSelectContent;

/** 设置 titleLabel，选择内容后是否更新标题, default NO */
@property (nonatomic, assign) BOOL isShowSelectContent;

/** 隐藏 titleLabel，默认为 NO */
@property (nonatomic, assign) BOOL hiddenTitleLabel;


/////////////////////////////////// 其他（Other） ///////////////////////////

/** 显示pickerView时是否带动画效果, default YES */
@property (nonatomic, assign) BOOL isAnimationShow;


#pragma mark - Methods

/** 默认的配置 */
+ (instancetype)defaultConfig;

/**
 * 将属性字典转为配置
 * @param propertyDict 自定义的属性字典
 */
+ (instancetype)configWithPropertyDict:(nullable NSDictionary *)propertyDict;

/** 初始化配置 */
- (void)resetConfig;

@end

NS_ASSUME_NONNULL_END
