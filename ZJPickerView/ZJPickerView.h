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
#import "ZJPickerViewProperty.h"
#import "ZJPickerViewConfig.h"


@interface ZJPickerView : UIView

/**
 Show pickerView（显示pickerView）
 The first way, customization pickerView style（方式一：通过设置样式，推荐）

 @param dataList Must pass by value， if not show. The object type of list is support NSString、NSNumber（basic data type）、NSDictionary（传入的数据，必传，否则不显示）
 @param config Custom config, user default config if value is nil（自定义样式，如果传空则用默认配置）
 @param completion Click sure button callback（点击确定按钮时回调）
 */
+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
                     config:(nullable ZJPickerViewConfig *)config
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion;

/**
 Show pickerView（显示pickerView）
 The second way, customization property dictionary（方式二：通过属性字典）

 @param dataList Must pass by value， if not show. The object type of list is support NSString、NSNumber（basic data type）、NSDictionary（传入的数据，必传，否则不显示）
 @param propertyDict Custom property, user default config if value is nil（自定义属性参数，如果传空则用默认属性配置）
 @param completion Click sure button callback（点击确定按钮时回调）
 */
+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
               propertyDict:(nullable NSDictionary *)propertyDict
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion;
@end
