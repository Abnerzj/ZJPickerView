//
//  ZJPickerView.h
//  ZJPickerView <https://github.com/Abnerzj/ZJPickerView>
//
//  Created by Abnerzj on 2018/1/12.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@interface ZJPickerView : UIView

#pragma mark - Customization

// content: NSString type
extern NSString * _Nonnull const ZJPickerViewPropertyCanceBtnTitleKey; // cance button Title（取消按钮）
extern NSString * _Nonnull const ZJPickerViewPropertySureBtnTitleKey;  // sure button Title（确定按钮）
extern NSString * _Nonnull const ZJPickerViewPropertyTipLabelTextKey;  // tipLabel text（选择提示标签）

// color: UIColor type
extern NSString * _Nonnull const ZJPickerViewPropertyCanceBtnTitleColorKey; // cance button Title color（取消按钮文字颜色）
extern NSString * _Nonnull const ZJPickerViewPropertySureBtnTitleColorKey;  // sure button Title color（确定按钮文字颜色）
extern NSString * _Nonnull const ZJPickerViewPropertyTipLabelTextColorKey;  // tipLabel text color（选择提示标签文字颜色）
extern NSString * _Nonnull const ZJPickerViewPropertyLineViewBackgroundColorKey;  // lineView backgroundColor（分割线背景颜色）

// font: UIFont type
extern NSString * _Nonnull const ZJPickerViewPropertyCanceBtnTitleFontKey; // cance button label font, default 17.0f（取消按钮字体大小）
extern NSString * _Nonnull const ZJPickerViewPropertySureBtnTitleFontKey;  // sure button label font, default 17.0f（确定按钮字体大小）
extern NSString * _Nonnull const ZJPickerViewPropertyTipLabelTextFontKey;  // tipLabel font, default 17.0f（选择提示标题字体大小）

// pickerView:
// CGFloat type
extern NSString * _Nonnull const ZJPickerViewPropertyPickerViewHeightKey;  // pickerView height, default 224 pt（pickerView高度）
extern NSString * _Nonnull const ZJPickerViewPropertyOneComponentRowHeightKey;  // one component row height, default 32 pt（pickerView一行的高度）
// NSDictionary
extern NSString * _Nonnull const ZJPickerViewPropertySelectRowTitleAttrKey;  // select row titlt attribute（pickerView当前选中的文字颜色）
extern NSString * _Nonnull const ZJPickerViewPropertyUnSelectRowTitleAttrKey;  // unSelect row titlt attribute（pickerView当前没有选中的文字颜色）

// other: BOOL type
extern NSString * _Nonnull const ZJPickerViewPropertyIsTouchBackgroundHideKey;  // touch background is hide, default NO（是否点击背景隐藏）
extern NSString * _Nonnull const ZJPickerViewPropertyIsShowSelectContentKey;  // scroll component is update and show select content in tipLabel, default NO（选择内容后是否更新选择提示标签）
extern NSString * _Nonnull const ZJPickerViewPropertyIsScrollToSelectedRowKey;  // when pickerView will show scroll to selected row, default NO. note:`ZJPickerViewPropertyTipLabelTextKey` Must pass by value（将要显示时是否滚动到已选择内容那一行，注意，选择提示标签tipLabel必须传内容，比如之前选择了`北京`，此时就需要传入`北京`）
extern NSString * _Nonnull const ZJPickerViewPropertyIsAnimationShowKey;  // show pickerView is need Animation, default YES（显示pickerView时是否带动画效果）
// CGFloat type
extern NSString * _Nonnull const ZJPickerViewPropertyBackgroundAlphaKey;  // background alpha, default 0.5(0.0~1.0)（背景视图透明度）


/**
 Show pickerView（显示pickerView）

 @param dataList Must pass by value， if not show. The object type of list is support NSString、NSNumber（basic data type）、NSDictionary（传入的数据，必传，否则不显示）
 @param propertyDict Custom property, user default config if value is nil（自定义属性参数，如果传空则用默认配置）
 @param completion Click sure button callback（点击确定按钮时回调）
 */
+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
               propertyDict:(nullable NSDictionary *)propertyDict
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion;
@end
