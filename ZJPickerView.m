//
//  ZJPickerView.m
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//

#import "ZJPickerView.h"

@interface ZJPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSUInteger _component; // 多少列
    void(^_complete)(NSString *selectContent); // 选择的文字
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ZJPickerView

+ (instancetype)zj_PickerView
{
    ZJPickerView *pickerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    pickerView.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
    return pickerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _component = 0;
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    
    if (dataList.count) {
        id data = dataList.firstObject;
        if ([data isKindOfClass:[NSString class]] ||
            [data isKindOfClass:[NSNumber class]] ) {
            _component = 1;
        } else if ([data isKindOfClass:[NSDictionary class]]) {
            _component++;
            [self handleDictDataList:dataList];
        } else {
            NSLog(@"数据格式不正确");
        }
    }
}

- (void)handleDictDataList:(NSArray *)list
{
    id data = list.firstObject;
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = data;
        id value = dict.allValues.firstObject;
        if ([value isKindOfClass:[NSArray class]]) {
            _component++;
            [self handleDictDataList:value];
        }
    }
}

#pragma mark 获取第几列的数据
- (NSArray *)getDataWithComponent:(NSInteger)component
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataList];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSUInteger i = 0; i <= component; i++) {
        if (i == component) {
            id data = tempArray.firstObject;
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *tempTitleArray = [NSMutableArray arrayWithArray:tempArray];
                [tempArray removeAllObjects];
                [tempTitleArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tempArray addObjectsFromArray:dict.allKeys];
                }];
                [arrayM addObjectsFromArray:tempArray];
            } else if ([data isKindOfClass:[NSString class]] ||
                       [data isKindOfClass:[NSNumber class]]){
                [arrayM addObjectsFromArray:tempArray];
            }
        } else {
            NSInteger selectRow = [self.pickerView selectedRowInComponent:i];
            id data = tempArray[selectRow];
            if ([data isKindOfClass:[NSDictionary class]]) {
                [tempArray removeAllObjects];
                NSDictionary *dict = data;
                [dict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSArray class]]) {
                        [tempArray addObjectsFromArray:obj];
                    } else {
                        [tempArray addObject:obj];
                    }
                }];
            }
        }
    }
    return arrayM;
}

// 有几个表盘（component）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _component;
}

// 没个表盘有几行数据（rows）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self getDataWithComponent:component].count;
}

//每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getDataWithComponent:component][row];
}

// 选中时回调的委托方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.0f;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *normalRowString = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSString *selectRowString = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:component] forComponent:component];
    if (row == [pickerView selectedRowInComponent:component]) {
        return [[NSAttributedString alloc] initWithString:selectRowString attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#434343"], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
    } else {
        return [[NSAttributedString alloc] initWithString:normalRowString attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#919191"], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
    }
}

#pragma mark 取消、确定
- (IBAction)userAction:(UIButton *)sender
{
    [self hide];
    
    // 确定
    if (sender.tag == 1) {
        NSMutableString *selectString = [[NSMutableString alloc] init];
        for (NSUInteger i = 0; i < _component; i++) {
            [selectString appendString:[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:i] forComponent:i]];
            if (i != _component - 1) {
                [selectString appendString:@"/"];
            }
        }
        
        if (_complete) {
           _complete(selectString);
        }
    }
}

- (void)show:(void(^)(NSString *selectContent))complete
{
    if (complete) {
        _complete = complete;
    }
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

@end
