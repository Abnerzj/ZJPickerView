//
//  ZJPickerViewModel.m
//  ZJPickerViewDemo
//
//  Created by abner on 2018/1/12.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import "ZJPickerViewModel.h"

@implementation ZJPickerViewModel

+ (instancetype)initWithDict:(NSDictionary *)dict
{
    ZJPickerViewModel *model = [[ZJPickerViewModel alloc] init];
    
    if (dict) {
        model.name = dict.allKeys.firstObject;
        
        id modelValue = dict[model.name];
        if (modelValue) {
            if ([modelValue isKindOfClass:[NSArray class]]) {
                NSMutableArray *subModels = [NSMutableArray array];
                [modelValue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [subModels addObject:[self initWithDict:obj]];
                    } else if ([obj isKindOfClass:[NSString class]] ||
                               [obj isKindOfClass:[NSNumber class]]) {
                        [subModels addObject:obj];
                    }
                }];
                model.subModels = subModels;
            }
        }
    }
    
    return model;
}

@end
