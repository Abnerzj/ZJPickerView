//
//  ViewController.m
//  ZJPickerViewDemo
//
//  Created by Abnerzj on 2018/1/12.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import "ViewController.h"
#import "ZJPickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *normalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    normalBtn.frame = CGRectMake(100, 100, 100, 100);
    [normalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [normalBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [normalBtn setTitle:@"显示" forState:UIControlStateNormal];
    [normalBtn setBackgroundColor:[UIColor orangeColor]];
    [normalBtn addTarget:self action:@selector(showPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:normalBtn];
}

#pragma mark 显示选择控制器
- (void)showPickerView
{
    // 1.获取数据(get data)
    // 1.1 单列数据(one component Data)
    // 1.1.1 NSString
//    NSArray *stringDataList = @[@"北京", @"上海", @"深圳", @"广州", @"成都"];
    // 1.1.2 NSNumber
//    NSArray *numberDataList = @[@22, @88, @188, @288, @388];
    
    // 1.2 多列数据，只支持字典数据(multi component Data)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    NSDictionary *cityNamesDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *dictDataList = [NSMutableArray arrayWithCapacity:cityNamesDict.allKeys.count];
    [cityNamesDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dictDataList addObject:@{key : obj}];
    }];
    
    // 2.属性(Property)
    
    
    // 3.显示
    [[ZJPickerView zj_PickerView] zj_showWithDataList:dictDataList complete:^(NSString *selectContent) {
        NSLog(@"%@", selectContent);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
