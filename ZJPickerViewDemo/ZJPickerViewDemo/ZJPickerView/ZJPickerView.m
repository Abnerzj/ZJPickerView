//
//  ZJPickerView.m
//  ZJPickerView <https://github.com/Abnerzj/ZJPickerView>
//
//  Created by Abnerzj on 2018/1/12.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "ZJPickerView.h"

// content: NSString type
NSString * const ZJPickerViewPropertyCanceBtnTitleKey = @"ZJPickerViewPropertyCanceBtnTitleKey";
NSString * const ZJPickerViewPropertySureBtnTitleKey = @"ZJPickerViewPropertySureBtnTitleKey";
NSString * const ZJPickerViewPropertyTipLabelTextKey = @"ZJPickerViewPropertyTipLabelTextKey";

// color: UIColor type
NSString * const ZJPickerViewPropertyCanceBtnTitleColorKey = @"ZJPickerViewPropertyCanceBtnTitleColorKey";
NSString * const ZJPickerViewPropertySureBtnTitleColorKey = @"ZJPickerViewPropertySureBtnTitleColorKey";
NSString * const ZJPickerViewPropertyTipLabelTextColorKey = @"ZJPickerViewPropertyTipLabelTextColorKey";
NSString * const ZJPickerViewPropertyLineViewBackgroundColorKey = @"ZJPickerViewPropertyLineViewBackgroundColorKey";

// font: UIFont type
NSString * const ZJPickerViewPropertyCanceBtnTitleFontKey = @"ZJPickerViewPropertyCanceBtnTitleFontKey";
NSString * const ZJPickerViewPropertySureBtnTitleFontKey = @"ZJPickerViewPropertySureBtnTitleFontKey";
NSString * const ZJPickerViewPropertyTipLabelTextFontKey = @"ZJPickerViewPropertyTipLabelTextFontKey";

// pickerView:
// CGFloat type
NSString * const ZJPickerViewPropertyPickerViewHeightKey = @"ZJPickerViewPropertyPickerViewHeightKey";
NSString * const ZJPickerViewPropertyOneComponentRowHeightKey = @"ZJPickerViewPropertyOneComponentRowHeightKey";
// NSDictionary type
NSString * const ZJPickerViewPropertySelectRowTitleAttrKey = @"ZJPickerViewPropertySelectRowTitleAttrKey";
NSString * const ZJPickerViewPropertyUnSelectRowTitleAttrKey = @"ZJPickerViewPropertyUnSelectRowTitleAttrKey";
// UIColor type
NSString * const ZJPickerViewPropertySelectRowLineBackgroundColorKey = @"ZJPickerViewPropertySelectRowLineBackgroundColorKey";

// other:
// BOOL type
NSString * const ZJPickerViewPropertyIsTouchBackgroundHideKey = @"ZJPickerViewPropertyIsTouchBackgroundHideKey";
NSString * const ZJPickerViewPropertyIsShowSelectContentKey = @"ZJPickerViewPropertyIsShowSelectContentKey";
NSString * const ZJPickerViewPropertyIsScrollToSelectedRowKey = @"ZJPickerViewPropertyIsScrollToSelectedRowKey";
NSString * const ZJPickerViewPropertyIsAnimationShowKey = @"ZJPickerViewPropertyIsAnimationShowKey";
// CGFloat type
NSString * const ZJPickerViewPropertyBackgroundAlphaKey = @"ZJPickerViewPropertyBackgroundAlphaKey";

static const CGFloat toolViewHeight = 44.0f; // tool view height
static const CGFloat canceBtnWidth = 68.0f; // cance button or sure button height

@interface ZJPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

// property
@property (nonatomic, strong) NSMutableArray *dataList; // data list
@property (nonatomic, strong) NSMutableDictionary *propertyDict; // property dictionary

// pickerView
@property (nonatomic, assign) NSUInteger component; // component numbers, default 0
@property (nonatomic, assign) CGFloat pickerViewHeight; // pickerView height, default 224 pt
@property (nonatomic, assign) CGFloat oneComponentRowHeight; // one component row height, default 32 pt
@property (nonatomic, strong) NSDictionary *selectRowTitleAttribute; // select row titlt attribute
@property (nonatomic, strong) NSDictionary *unSelectRowTitleAttribute; // unSelect row titlt attribute
@property (nonatomic, strong) UIColor *selectRowLineBackgroundColor; // select row top and bottom line backgroundColor

@property (nonatomic, assign) BOOL isTouchBackgroundHide; // touch background is hide, default NO
@property (nonatomic, assign) BOOL isShowSelectContent; // scroll component is update and show select content in tipLabel, default NO
@property (nonatomic, assign) BOOL isScrollToSelectedRow; // pickerView will show scroll to selected row, default NO
@property (nonatomic, assign) BOOL isAnimationShow; // show pickerView is need Animation, default YES
@property (nonatomic, assign) BOOL isSettedSelectRowLineBackgroundColor; // is setted select row top and bottom line backgroundColor, default NO
@property (nonatomic, assign) CGFloat backgroundAlpha; // background alpha, default 0.5(0.0~1.0)
@property (nonatomic, copy) void(^completion)(NSString * _Nullable  selectContent); // select content

// subviews
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *canceBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZJPickerView

+ (ZJPickerView *)sharedView {
    static dispatch_once_t once;
    static ZJPickerView *sharedView;
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

#pragma mark - Instance Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self initDefaultConfig];
        self.dataList = [NSMutableArray array];
        self.propertyDict = [NSMutableDictionary dictionary];
        [self initSubViews];
    }
    return self;
}

- (void)initDefaultConfig
{
    self.component = 0;
    self.pickerViewHeight = 224.0f;
    self.oneComponentRowHeight = 32.0f;
    self.selectRowTitleAttribute = @{NSForegroundColorAttributeName : [UIColor orangeColor], NSFontAttributeName : [UIFont systemFontOfSize:20.0f]};
    self.unSelectRowTitleAttribute = @{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:20.0f]};
    self.selectRowLineBackgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    
    self.isTouchBackgroundHide = NO;
    self.isShowSelectContent = NO;
    self.isScrollToSelectedRow = NO;
    self.isAnimationShow = YES;
    self.isSettedSelectRowLineBackgroundColor = NO;
    self.backgroundAlpha = 0.5f;
}

- (void)initSubViews
{
    // background view
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = self.backgroundAlpha;
    [self addSubview:backgroundView];
    
    // add tap Gesture
    UITapGestureRecognizer *tapbgGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBackgroundView)];
    [backgroundView addGestureRecognizer:tapbgGesture];
    
    // content view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - toolViewHeight - self.pickerViewHeight, self.frame.size.width, toolViewHeight + self.pickerViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    // tool view
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolViewHeight)];
    toolView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:toolView];
    
    // cance button
    UIButton *canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canceBtn.frame = CGRectMake(0, 0, canceBtnWidth, toolView.frame.size.height);
    [canceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [canceBtn setTitle:@"Cance" forState:UIControlStateNormal];
    [canceBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [canceBtn setTag:0];
    [canceBtn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:canceBtn];
    
    // sure button
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(toolView.frame.size.width - canceBtnWidth, 0, canceBtnWidth, toolView.frame.size.height);
    [sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"Sure" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [sureBtn setTag:1];
    [sureBtn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sureBtn];
    
    // center title
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(canceBtn.frame.size.width, 0, toolView.frame.size.width - canceBtn.frame.size.width*2, toolView.frame.size.height)];
    tipLabel.text = @"";
    tipLabel.textColor = [UIColor darkTextColor];
    tipLabel.font = [UIFont systemFontOfSize:17.0];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.hidden = !self.isShowSelectContent;
    [toolView addSubview:tipLabel];
    
    // line view
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, toolView.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    [toolView addSubview:lineView];
    
    // pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolView.frame.size.height, self.frame.size.width, self.pickerViewHeight)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [contentView addSubview:pickerView];
    
    // global variable
    self.backgroundView = backgroundView;
    self.contentView = contentView;
    self.canceBtn = canceBtn;
    self.sureBtn = sureBtn;
    self.lineView = lineView;
    self.tipLabel = tipLabel;
    self.pickerView = pickerView;
}

#pragma mark - UIPickerView DataSource & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self getDataWithComponent:component].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *componentArray = [self getDataWithComponent:component];
    if (componentArray.count) {
        if (row < componentArray.count) {
            id titleData = componentArray[row];
            if ([titleData isKindOfClass:[NSString class]]) {
                return titleData;
            } else if ([titleData isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", titleData];
            }
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // show select content
    NSMutableString *selectString = [[NSMutableString alloc] init];
    
    // reload all component and scroll to top for sub component
    [pickerView reloadAllComponents];
    for (NSUInteger i = 0; i < self.component; i++) {
        if (i > component) {
            [pickerView selectRow:0 inComponent:i animated:YES];
        }
        
        if (self.isShowSelectContent) {
            [selectString appendString:[self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:i] forComponent:i]];
            if (i == self.component - 1) {
                self.tipLabel.text = selectString;
            }
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.oneComponentRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // set separateline color
    if (NO == self.isSettedSelectRowLineBackgroundColor) {
        UIView *topSeparateLine = [pickerView.subviews objectAtIndex:1];
        UIView *bottomSeparateLine = [pickerView.subviews objectAtIndex:2];
        if (topSeparateLine.frame.size.height < 1.0f &&
            bottomSeparateLine.frame.size.height < 1.0f) {
            topSeparateLine.backgroundColor = self.selectRowLineBackgroundColor;
            bottomSeparateLine.backgroundColor = self.selectRowLineBackgroundColor;
            self.isSettedSelectRowLineBackgroundColor = YES;
        } else {
            for (UIView *singleLine in pickerView.subviews) {
                if (singleLine.frame.size.height < 1.0f) {
                    singleLine.backgroundColor = self.selectRowLineBackgroundColor;
                    self.isSettedSelectRowLineBackgroundColor = YES;
                }
            }
        }
    }
    
    // custom pickerView content label
    UILabel *pickerLabel = (UILabel *)view;
    
    // discussion: this is always nil, not Reusing, it's an iOS System bug.
    // reference: https://stackoverflow.com/questions/20635949/reusing-view-in-uipickerview-with-ios-7/21039321#21039321
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.backgroundColor = [UIColor clearColor];
    }
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *normalRowString = [self pickerView:pickerView titleForRow:row forComponent:component];
    NSString *selectRowString = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:component] forComponent:component];
    if (row == [pickerView selectedRowInComponent:component]) {
        return [[NSAttributedString alloc] initWithString:selectRowString attributes:self.selectRowTitleAttribute];
    } else {
        return [[NSAttributedString alloc] initWithString:normalRowString attributes:self.unSelectRowTitleAttribute];
    }
}

#pragma mark click cance/sure button
- (void)userAction:(UIButton *)sender
{
    // hide
    [self zj_hide];
    
    // click sure
    if (sender.tag == 1) {
        NSMutableString *selectString = [[NSMutableString alloc] init];
        for (NSUInteger i = 0; i < self.component; i++) {
            [selectString appendString:[self pickerView:self.pickerView titleForRow:[self.pickerView selectedRowInComponent:i] forComponent:i]];
            if (i != self.component - 1) { // 多行用 "," 分割
                [selectString appendString:@","];
            }
        }
        
        // completion callback
        if (self.completion) {
           self.completion(selectString);
        }
    }
}

#pragma mark touch backgroundView
- (void)touchBackgroundView
{
    if (self.isTouchBackgroundHide) {
        [self zj_hide];
    }
}

#pragma mark - show & hide method
+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
               propertyDict:(nullable NSDictionary *)propertyDict
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion
{
    // no data
    if (!dataList || dataList.count == 0) {
        return;
    }
    
    // handle data
    [[self sharedView] initDefaultConfig];
    [self sharedView].tipLabel.text = @"";
    [[self sharedView].dataList removeAllObjects];
    [[self sharedView].dataList addObjectsFromArray:dataList];
    [[self sharedView].propertyDict removeAllObjects];
    [[self sharedView].propertyDict addEntriesFromDictionary:propertyDict];
    [[self sharedView] updateCustomProperiesSetter];
     
    // calculate component num
    id data = dataList.firstObject;
    if ([data isKindOfClass:[NSString class]] ||
        [data isKindOfClass:[NSNumber class]] ) {
        [self sharedView].component = 1;
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        [self sharedView].component++;
        [self handleDictDataList:dataList];
    } else {
        NSLog(@"ZJPickerView error tip：\"Unsupported data type\"");
        return;
    }
    
    // scorll all component to selectedRow/top
    [[self sharedView].pickerView reloadAllComponents];
    if ([[self sharedView] isShowSelectContent] && [self sharedView].isScrollToSelectedRow) {
        [[self sharedView] scrollToSelectedRow];
    } else {
        for (NSUInteger i = 0; i < [self sharedView].component; i++) {
            [[self sharedView].pickerView selectRow:0 inComponent:i animated:NO];
        }
    }
    
    // complete block
    if (completion) {
        [self sharedView].completion = completion;
    }
    
    // show
    if ([self sharedView].isAnimationShow) {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:[self sharedView]];
        
        [self sharedView].backgroundView.alpha = 0.0f;
        
        CGRect frame = [self sharedView].contentView.frame;
        frame.origin.y = [self sharedView].frame.size.height;
        [self sharedView].contentView.frame = frame;
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = [weakself sharedView].contentView.frame;
            frame.origin.y = [weakself sharedView].frame.size.height - [weakself sharedView].contentView.frame.size.height;
            [weakself sharedView].contentView.frame = frame;
            [weakself sharedView].backgroundView.alpha = [weakself sharedView].backgroundAlpha;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [[[[UIApplication sharedApplication] delegate] window] addSubview:[self sharedView]];
        }];
    }
}

- (void)zj_hide
{
    __weak typeof(self) weakself = self;
    if (self.isAnimationShow) {
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.frame.size.height;
        [UIView animateWithDuration:0.3f animations:^{
            weakself.contentView.frame = frame;
            weakself.backgroundView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [weakself removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [weakself removeFromSuperview];
        }];
    }
}

#pragma mark - private method
+ (void)handleDictDataList:(NSArray *)list
{
    id data = list.firstObject;
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = data;
        id value = dict.allValues.firstObject;
        if ([value isKindOfClass:[NSArray class]]) {
            [self sharedView].component++;
            [self handleDictDataList:value];
        }
    }
}

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
            if (selectRow < tempArray.count) {
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
    }
    return arrayM;
}

#pragma mark update property
- (void)updateCustomProperiesSetter
{
    [self.propertyDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleKey]) {
                [self.canceBtn setTitle:obj forState:UIControlStateNormal];
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleKey]) {
                [self.sureBtn setTitle:obj forState:UIControlStateNormal];
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextKey]) {
                self.tipLabel.text = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleColorKey]) {
                [self.canceBtn setTitleColor:obj forState:UIControlStateNormal];
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleColorKey]) {
                [self.sureBtn setTitleColor:obj forState:UIControlStateNormal];
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextColorKey]) {
                self.tipLabel.textColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyLineViewBackgroundColorKey]) {
                self.lineView.backgroundColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyCanceBtnTitleFontKey]) {
                [self.canceBtn.titleLabel setFont:obj];
            } else if ([key isEqualToString:ZJPickerViewPropertySureBtnTitleFontKey]) {
                [self.sureBtn.titleLabel setFont:obj];
            } else if ([key isEqualToString:ZJPickerViewPropertyTipLabelTextFontKey]) {
                [self.tipLabel setFont:obj];
            } else if ([key isEqualToString:ZJPickerViewPropertyPickerViewHeightKey]) {
                self.pickerViewHeight = [obj floatValue];
                CGRect frame = self.pickerView.frame;
                frame.size.height = self.pickerViewHeight;
                self.pickerView.frame = frame;
                
                frame = self.contentView.frame;
                frame.size.height = toolViewHeight + self.pickerViewHeight;
                frame.origin.y = self.frame.size.height - frame.size.height;
                self.contentView.frame = frame;
            } else if ([key isEqualToString:ZJPickerViewPropertyOneComponentRowHeightKey]) {
                self.oneComponentRowHeight = [obj floatValue];
            } else if ([key isEqualToString:ZJPickerViewPropertySelectRowTitleAttrKey]) {
                self.selectRowTitleAttribute = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyUnSelectRowTitleAttrKey]) {
                self.unSelectRowTitleAttribute = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertySelectRowLineBackgroundColorKey]) {
                self.selectRowLineBackgroundColor = obj;
            } else if ([key isEqualToString:ZJPickerViewPropertyIsTouchBackgroundHideKey]) {
                self.isTouchBackgroundHide = [obj boolValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyIsShowSelectContentKey]) {
                self.isShowSelectContent = [obj boolValue];
                self.tipLabel.hidden = !self.isShowSelectContent;
            } else if ([key isEqualToString:ZJPickerViewPropertyIsScrollToSelectedRowKey]) {
                self.isScrollToSelectedRow = [obj boolValue];
            } else if ([key isEqualToString:ZJPickerViewPropertyBackgroundAlphaKey]) {
                self.backgroundAlpha = [obj floatValue];
                self.backgroundView.alpha = self.backgroundAlpha;
            } else if ([key isEqualToString:ZJPickerViewPropertyIsAnimationShowKey]) {
                self.isAnimationShow = [obj boolValue];
            }
        }
    }];
}

- (void)scrollToSelectedRow
{
    NSString *selectedContent = self.propertyDict[ZJPickerViewPropertyTipLabelTextKey];
    if (selectedContent.length && ![selectedContent isEqualToString:@""]) {
        __weak typeof(self) weakself = self;
        NSMutableArray *tempSelectedRowArray = [NSMutableArray arrayWithCapacity:self.component];
        for (NSUInteger i = 0; i < self.component; i++) {
            NSArray *componentArray = [self getDataWithComponent:i];
            if (componentArray.count) {
                [componentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *title = @"";
                    if ([obj isKindOfClass:[NSString class]]) {
                        title = obj;
                    } else if ([obj isKindOfClass:[NSNumber class]]) {
                        title = [NSString stringWithFormat:@"%@", obj];
                    }
                    if (![title isEqualToString:@""]) {
                        NSRange range = [selectedContent rangeOfString:title];
                        if (range.location != NSNotFound) {
                            [tempSelectedRowArray addObject:@(idx)];
                            [weakself.pickerView reloadComponent:i];
                            [weakself.pickerView selectRow:idx inComponent:i animated:NO];
                            [weakself.pickerView reloadComponent:i];
                            *stop = YES;
                        }
                    }
                }];
            }
        }
        
        if (tempSelectedRowArray.count != self.component) {
            for (NSUInteger i = 0; i < self.component; i++) {
                [self.pickerView selectRow:0 inComponent:i animated:NO];
            }
        }
    }
}

@end
