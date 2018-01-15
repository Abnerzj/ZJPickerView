//
//  ZJPickerViewModel.h
//  ZJPickerViewDemo
//
//  Created by abner on 2018/1/12.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJPickerViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *subModels;

+ (instancetype)initWithDict:(NSDictionary *)dict;

@end
