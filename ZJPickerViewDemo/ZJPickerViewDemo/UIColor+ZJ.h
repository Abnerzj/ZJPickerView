//
//  UIColor+ZJ.h
//  ZJPickerViewDemo
//
//  Created by Abnerzj on 2018/1/12.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZJ)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)zj_colorWithHexString: (NSString *)color;

@end
