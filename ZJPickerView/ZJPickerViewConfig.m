//
//  ZJPickerViewConfig.m
//  ZJPickerViewConfig <https://github.com/Abnerzj/ZJPickerView>
//
//  Created by Abnerzj on 2020/10/17.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "ZJPickerViewConfig.h"
#import "ZJPickerViewProperty.h"

static NSString * const kDividedSymbol = @","; // divided symbol


@implementation ZJPickerViewConfig

- (instancetype)init {
    if (self == [super init]) {
        [self resetConfig];
    }
    return self;
}

+ (instancetype)defaultConfig
{
    ZJPickerViewConfig *config = [[ZJPickerViewConfig alloc] init];
    return config;
}

+ (instancetype)configWithPropertyDict:(nullable NSDictionary *)propertyDict
{
    ZJPickerViewConfig *config = [self defaultConfig];
    
    [propertyDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleKey]) {
                config.cancelBtnTitle = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleKey]) {
                config.sureBtnTitle = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextKey]) {
                config.titleLabelText = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyDividedSymbolKey]) {
                config.dividedSymbol = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleColorKey]) {
                config.cancelTextColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleColorKey]) {
                config.sureTextColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextColorKey]) {
                config.titleTextColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyLineViewBackgroundColorKey]) {
                config.titleLineColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleFontKey]) {
                config.cancelTextFont = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleFontKey]) {
                config.sureTextFont = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextFontKey]) {
                config.titleTextFont = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyPickerViewHeightKey]) {
                config.pickerViewHeight = [obj floatValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyOneComponentRowHeightKey]) {
                config.rowHeight = [obj floatValue];
            } else if ([key isEqualToString:ZJPickerViewPropertySelectRowTitleAttrKey]) {
                config.selectRowTitleAttribute = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyUnSelectRowTitleAttrKey]) {
                config.unSelectRowTitleAttribute = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertySelectRowLineBackgroundColorKey]) {
                config.separatorColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyIsTouchBackgroundHideKey]) {
                config.isTouchMaskHide = [obj boolValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyIsShowTipLabelKey]) {
                config.hiddenTitleLabel = ![obj boolValue];
                if (config.isShowSelectContent) {
                    config.hiddenTitleLabel = NO;
                }
            } else if ([key isEqualToString:ZJPickerViewPropertyIsShowSelectContentKey]) {
                config.isShowSelectContent = [obj boolValue];
                if (config.isShowSelectContent) {
                    config.hiddenTitleLabel = NO;
                }
            } else if ([key isEqualToString:ZJPickerViewPropertyIsScrollToSelectedRowKey]) {
                config.isScrollToSelectedRow = [obj boolValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyIsDividedSelectContentKey]) {
                config.isDividedSelectContent = [obj boolValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyBackgroundAlphaKey]) {
                config.maskAlpha = [obj floatValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyIsAnimationShowKey]) {
                config.isAnimationShow = [obj boolValue];
            }
        }
    }];
    
    return config;
}

- (void)resetConfig
{
    NSArray *diffLanguageTitles = [self getDiffLanguageCanceAndSureBtnTitles];
    
    self.maskAlpha = 0.5f;
    self.isTouchMaskHide = NO;
    
    self.pickerViewHeight = 216.0f;
    self.rowHeight = 32.0f;
    self.selectRowTitleAttribute = @{NSForegroundColorAttributeName : kZJPickerViewDefaultThemeColor, NSFontAttributeName : [UIFont systemFontOfSize:20.0f]};
    self.unSelectRowTitleAttribute = @{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:20.0f]};
    if (@available(iOS 14.0, *)) {
        self.separatorColor = [UIColor tertiarySystemFillColor];
    } else {
        self.separatorColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    }
    self.isScrollToSelectedRow = NO;
    self.sureBtnTitle = diffLanguageTitles.lastObject;
    self.sureTextColor = kZJPickerViewDefaultThemeColor;
    self.sureTextFont = [UIFont systemFontOfSize:17.0];
    
    self.cancelBtnTitle = diffLanguageTitles.firstObject;
    self.cancelTextColor = [UIColor grayColor];
    self.cancelTextFont = [UIFont systemFontOfSize:17.0];
    
    self.titleLabelText = @"";
    self.titleTextColor = [UIColor darkTextColor];
    self.titleTextFont = [UIFont systemFontOfSize:17.0];
    self.titleLineColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.dividedSymbol = kDividedSymbol;
    self.isDividedSelectContent = NO;
    self.isShowSelectContent = NO;
    self.hiddenTitleLabel = YES;
    
    self.isAnimationShow = YES;
}

- (NSArray *)getDiffLanguageCanceAndSureBtnTitles
{
    NSString *languageName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    // 简体中文
    if ([languageName rangeOfString:@"zh-Hans"].location != NSNotFound) {
        return @[@"取消", @"确定"];
    }
    
    // 繁体中文
    if ([languageName rangeOfString:@"zh-Hant"].location != NSNotFound) {
        return @[@"取消", @"確定"];
    }
    
    // Other language
    return @[@"Cance", @"Sure"];
}


@end
