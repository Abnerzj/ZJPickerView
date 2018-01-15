//
//  ViewController.m
//  ZJPickerViewDemo
//
//  Created by Abnerzj on 2018/1/12.
//  Copyright © 2018年 Abnerzj. All rights reserved.
//

#import "ViewController.h"
#import "ZJPickerView.h"
#import "UIColor+ZJ.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_selectContentLabel;
    UITableView *_tableView;
    NSArray *_dataList;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataAndSubViews];
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ZJPickerViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row >= 0 && indexPath.row < _dataList.count) {
        NSDictionary *dict = _dataList[indexPath.row];
        cell.textLabel.text = dict[@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 0 && indexPath.row < _dataList.count) {
        NSDictionary *dict = _dataList[indexPath.row];
        NSArray *dataList = dict[@"dataList"];
        [self showPickerViewWithDataList:dataList];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark 显示选择控制器
- (void)showPickerViewWithDataList:(NSArray *)dataList
{
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : @"提示内容",
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : [UIColor zj_colorWithHexString:@"#A9A9A9"],
                                   ZJPickerViewPropertySureBtnTitleColorKey : [UIColor zj_colorWithHexString:@"#FF6347"],
                                   ZJPickerViewPropertyTipLabelTextColorKey : [UIColor zj_colorWithHexString:@"#231F20"],
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : [UIColor zj_colorWithHexString:@"#dedede"],
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:17.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:17.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:17.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @300.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : [UIColor zj_colorWithHexString:@"#FF6347"], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : [UIColor zj_colorWithHexString:@"#A9A9A9"], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]},
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    __weak typeof(_selectContentLabel) weak_selectContentLabel = _selectContentLabel;
    [ZJPickerView zj_showWithDataList:dataList propertyDict:propertyDict completion:^(NSString *selectContent) {
        NSLog(@"ZJPickerView log tip：---> selectContent:%@", selectContent);

        NSArray *selectStrings = [selectContent componentsSeparatedByString:@","];
        NSMutableString *selectStringCollection = [[NSMutableString alloc] initWithString:@"选择内容："];
        [selectStrings enumerateObjectsUsingBlock:^(NSString *selectString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (selectString.length && ![selectString isEqualToString:@""]) {
                [selectStringCollection appendString:selectString];
            }
        }];
        weak_selectContentLabel.text = selectStringCollection;
    }];
}

- (void)initDataAndSubViews
{
    _selectContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.frame.size.width, 44.0f)];
    _selectContentLabel.text = @"选择内容：";
    _selectContentLabel.textColor = [UIColor brownColor];
    _selectContentLabel.font = [UIFont systemFontOfSize:17.0f];
    _selectContentLabel.textAlignment = NSTextAlignmentCenter;
    _selectContentLabel.numberOfLines = 0;
    [self.view addSubview:_selectContentLabel];
    
    // 1.获取数据(get data)
    // 1.1 单列数据(one component Data)
    // 1.1.1 NSString
    NSArray *stringDataList = @[@"北京", @"上海", @"深圳", @"广州", @"成都"];
    // 1.1.2 NSNumber
    NSArray *numberDataList = @[@22, @88, @188, @288, @388];
    
    // 1.2 多列数据(multi component Data)
    // 1.2.1 NSDictionary
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"];
    NSDictionary *cityNamesDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *dictDataList = [NSMutableArray arrayWithCapacity:cityNamesDict.allKeys.count];
    [cityNamesDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dictDataList addObject:@{key : obj}];
    }];
    
    // 1.2.2 NSArray
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"CityData2" ofType:@"plist"];
    NSArray *arrayDataList = [NSArray arrayWithContentsOfFile:path2];
    
    _dataList = @[@{@"title" : @"One component-->NSString(单列数据)", @"dataList" : stringDataList},
                  @{@"title" : @"One component-->NSNumber(单列数据)", @"dataList" : numberDataList},
                  @{@"title" : @"Multi component-->NSDictionary(多列数据)", @"dataList" : dictDataList},
                  @{@"title" : @"Multi component-->NSArray(多列数据)", @"dataList" : arrayDataList},
                  @{@"title" : @"Multi component-->NSArray(三列数据)", @"dataList" : [self getCityData]}];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectContentLabel.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_selectContentLabel.frame)) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)getCityData
{
    NSMutableArray *areaDataArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData3" ofType:@"txt"];
    NSString *areaString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (areaString && ![areaString isEqualToString:@""]) {
        NSError *error = nil;
        NSArray *areaStringArray = [NSJSONSerialization JSONObjectWithData:[areaString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (areaStringArray && areaStringArray.count) {
            [areaStringArray enumerateObjectsUsingBlock:^(NSDictionary *currentProviceDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *proviceDict = [NSMutableDictionary dictionary];
                NSString *proviceName = currentProviceDict[@"name"];
                NSArray *cityArray = currentProviceDict[@"childs"];
                
                NSMutableArray *tempCityArray = [NSMutableArray arrayWithCapacity:cityArray.count];
                [cityArray enumerateObjectsUsingBlock:^(NSDictionary *currentCityDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                    NSString *cityName = currentCityDict[@"name"];
                    NSArray *countryArray = currentCityDict[@"childs"];
                    
                    NSMutableArray *tempCountryArray = [NSMutableArray arrayWithCapacity:countryArray.count];
                    if (countryArray) {
                        [countryArray enumerateObjectsUsingBlock:^(NSDictionary *currentCountryDict, NSUInteger idx, BOOL * _Nonnull stop) {
                            [tempCountryArray addObject:currentCountryDict[@"name"]];
                        }];
                        
                        if (cityName) {
                            [cityDict setObject:tempCountryArray forKey:cityName];
                            [tempCityArray addObject:cityDict];
                        }
                    } else {
                        [tempCityArray addObject:cityName];
                    }
                }];
                
                if (proviceName && cityArray) {
                    [proviceDict setObject:tempCityArray forKey:proviceName];
                    [areaDataArray addObject:proviceDict];
                }
            }];
        } else {
            NSLog(@"解析错误");
        }
    }
    return areaDataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
