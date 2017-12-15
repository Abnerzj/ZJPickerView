//
//  ZJPickerView.h
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPickerView : UIView

@property (nonatomic, strong) NSArray *dataList; // 数据

+ (instancetype)zj_PickerView;

- (void)show:(void(^)(NSString *selectContent))complete;
- (void)hide;

@end
