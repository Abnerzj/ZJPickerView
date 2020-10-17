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

static const CGFloat toolViewHeight = 44.0f; // tool view height
static const CGFloat canceBtnWidth = 68.0f; // cance button or sure button height

@interface ZJPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

// property
@property (nonatomic, strong) NSMutableArray *dataList; // data list
@property (nonatomic, strong) ZJPickerViewConfig *config; // custom style
@property (nonatomic, copy) void(^completion)(NSString * _Nullable  selectContent); // select content
@property (nonatomic, assign) NSUInteger component; // component numbers, default 0
@property (nonatomic, assign) BOOL isSettedSelectRowLineBackgroundColor; // is setted select row top and bottom line backgroundColor, default NO

// subviews
@property (nonatomic, strong) UIView *maskView;
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
        self.dataList = [NSMutableArray array];
        self.config = [ZJPickerViewConfig defaultConfig];
        [self initSubViews];
    }
    return self;
}

- (void)initDefaultConfig
{
    self.component = 0;
    self.isSettedSelectRowLineBackgroundColor = NO;
    [self.config resetConfig];
}

- (void)resetData
{
    self.tipLabel.text = @"";
    [self.dataList removeAllObjects];
    self.config = nil;
}

- (void)initSubViews
{
    // background view
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = self.config.maskAlpha;
    [self addSubview:maskView];
    
    // add tap Gesture
    UITapGestureRecognizer *tapbgGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMaskView)];
    [maskView addGestureRecognizer:tapbgGesture];
    
    // content view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - toolViewHeight - self.config.pickerViewHeight, self.frame.size.width, toolViewHeight + self.config.pickerViewHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    // tool view
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolViewHeight)];
    toolView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:toolView];
    
    // cance button
    UIButton *canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    canceBtn.frame = CGRectMake(0, 0, canceBtnWidth, toolView.frame.size.height);
    [canceBtn setTitleColor:self.config.cancelTextColor forState:UIControlStateNormal];
    [canceBtn setTitle:self.config.cancelBtnTitle forState:UIControlStateNormal];
    [canceBtn.titleLabel setFont:self.config.cancelTextFont];
    [canceBtn setTag:0];
    [canceBtn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:canceBtn];
    
    // sure button
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(toolView.frame.size.width - canceBtnWidth, 0, canceBtnWidth, toolView.frame.size.height);
    [sureBtn setTitleColor:kZJPickerViewDefaultThemeColor forState:UIControlStateNormal];
    [sureBtn setTitle:self.config.sureBtnTitle forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:self.config.sureTextFont];
    [sureBtn setTag:1];
    [sureBtn addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sureBtn];
    
    // center title
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(canceBtn.frame.size.width, 0, toolView.frame.size.width - canceBtn.frame.size.width*2, toolView.frame.size.height)];
    tipLabel.text = self.config.titleLabelText;
    tipLabel.textColor = self.config.titleTextColor;
    tipLabel.font = self.config.titleTextFont;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.hidden = self.config.hiddenTitleLabel;
    [toolView addSubview:tipLabel];
    
    // line view
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, toolView.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
    lineView.backgroundColor = self.config.titleLineColor;
    [toolView addSubview:lineView];
    
    // pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolView.frame.size.height, self.frame.size.width, self.config.pickerViewHeight)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [contentView addSubview:pickerView];
    
    // global variable
    self.maskView = maskView;
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
        
        if (self.config.isShowSelectContent) {
            [selectString appendString:[self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:i] forComponent:i]];
            if (i == self.component - 1) {
                self.tipLabel.text = selectString;
            }
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.config.rowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // set separateline color
    // discussion: Fix iOS 14+ setting the color of the selected line dividing line crashes
    // reference: https://github.com/Abnerzj/ZJPickerView/issues/9
    if (NO == self.isSettedSelectRowLineBackgroundColor) {
        for (UIView *singleLine in pickerView.subviews) {
            if (singleLine.frame.size.height < 1.0f) { // under iOS 13, height = 0.5f;
                singleLine.backgroundColor = self.config.separatorColor;
                self.isSettedSelectRowLineBackgroundColor = YES;
            }
            else if (singleLine.frame.size.height == 42.0f) { // iOS 14+, select
                singleLine.backgroundColor = self.config.separatorColor;
                self.isSettedSelectRowLineBackgroundColor = YES;
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
        return [[NSAttributedString alloc] initWithString:selectRowString attributes:self.config.selectRowTitleAttribute];
    } else {
        return [[NSAttributedString alloc] initWithString:normalRowString attributes:self.config.unSelectRowTitleAttribute];
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
                [selectString appendString:self.config.dividedSymbol];
            }
        }
        
        // completion callback
        if (self.completion) {
           self.completion(selectString);
        }
    }
}

#pragma mark touch maskView
- (void)touchMaskView
{
    if (self.config.isTouchMaskHide) {
        [self zj_hide];
    }
}

#pragma mark - show & hide method
+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
                     config:(nullable ZJPickerViewConfig *)config
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion
{
    // no data
    if (!dataList || dataList.count == 0) {
        return;
    }
    
    // handle data
    [[self sharedView] initDefaultConfig];
    [[self sharedView].dataList addObjectsFromArray:dataList];
    [[self sharedView] setConfig:config ?: [ZJPickerViewConfig defaultConfig]];
    [[self sharedView] updateCustomProperiesConfig];
     
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
    
    // discussion: reload component in main queue, fix the first scroll to select line error bug.
    // scorll all component to selectedRow/top
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self sharedView].pickerView reloadAllComponents];
        if ([self sharedView].config.isScrollToSelectedRow) {
            [[self sharedView] scrollToSelectedRow];
        } else {
            for (NSUInteger i = 0; i < [self sharedView].component; i++) {
                [[self sharedView].pickerView selectRow:0 inComponent:i animated:NO];
            }
        }
    });
    
    // complete block
    if (completion) {
        [self sharedView].completion = completion;
    }
    
    // show
    if ([self sharedView].config.isAnimationShow) {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:[self sharedView]];
        
        [self sharedView].maskView.alpha = 0.0f;
        
        CGRect frame = [self sharedView].contentView.frame;
        frame.origin.y = [self sharedView].frame.size.height;
        [self sharedView].contentView.frame = frame;
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = [self sharedView].contentView.frame;
            frame.origin.y = [self sharedView].frame.size.height - [self sharedView].contentView.frame.size.height;
            [self sharedView].contentView.frame = frame;
            [self sharedView].maskView.alpha = [self sharedView].config.maskAlpha;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [[[[UIApplication sharedApplication] delegate] window] addSubview:[self sharedView]];
        }];
    }
}

+ (void)zj_showWithDataList:(nonnull NSArray *)dataList
               propertyDict:(nullable NSDictionary *)propertyDict
                 completion:(nullable void(^)(NSString * _Nullable selectContent))completion
{
    [self zj_showWithDataList:dataList config:[ZJPickerViewConfig configWithPropertyDict:propertyDict] completion:completion];
}

- (void)zj_hide
{
    if (self.config.isAnimationShow) {
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.frame.size.height;
        [UIView animateWithDuration:0.3f animations:^{
            self.contentView.frame = frame;
            self.maskView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self resetData];
            [self removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            [self resetData];
            [self removeFromSuperview];
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
    for (NSInteger i = 0; i <= component; i++) {
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
- (void)updateCustomProperiesConfig
{
    self.maskView.alpha = self.config.maskAlpha;
    
    CGRect frame = self.pickerView.frame;
    frame.size.height = self.config.pickerViewHeight;
    self.pickerView.frame = frame;
    frame = self.contentView.frame;
    frame.size.height = toolViewHeight + self.config.pickerViewHeight;
    frame.origin.y = self.frame.size.height - frame.size.height;
    self.contentView.frame = frame;
    
    
    [self.canceBtn setTitle:self.config.cancelBtnTitle forState:UIControlStateNormal];
    [self.canceBtn setTitleColor:self.config.cancelTextColor forState:UIControlStateNormal];
    [self.canceBtn.titleLabel setFont:self.config.cancelTextFont];
    
    [self.sureBtn setTitle:self.config.sureBtnTitle forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:self.config.sureTextColor forState:UIControlStateNormal];
    [self.sureBtn.titleLabel setFont:self.config.sureTextFont];
    
    self.tipLabel.text = self.config.titleLabelText;
    self.tipLabel.textColor = self.config.titleTextColor;
    self.tipLabel.font = self.config.titleTextFont;
    self.tipLabel.hidden = self.config.hiddenTitleLabel;
}

- (void)scrollToSelectedRow
{
    NSString *selectedContent = self.config.titleLabelText;
    NSMutableArray *selectContentList = [NSMutableArray arrayWithCapacity:self.component];
    if (self.config.isDividedSelectContent) {
        // reference: https://github.com/Abnerzj/ZJPickerView/issues/8
        NSArray *tempSelectContentList = [selectedContent componentsSeparatedByString:self.config.dividedSymbol];
        if (tempSelectContentList && tempSelectContentList.count == self.component) {
            [selectContentList addObjectsFromArray:tempSelectContentList];
        }
    }
    NSMutableArray *tempSelectedRowArray = [NSMutableArray arrayWithCapacity:self.component];
    if (selectedContent.length && ![selectedContent isEqualToString:@""]) {
        __weak typeof(self) weakself = self;
        for (NSUInteger i = 0; i < self.component; i++) {
            NSArray *componentArray = [self getDataWithComponent:i];
            if (componentArray.count) {
                [componentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *title = @"";
                    if ([obj isKindOfClass:[NSString class]]) {
                        title = obj;
                    } else if ([obj isKindOfClass:[NSNumber class]]) {
                        title = [obj stringValue];
                    }
                    if (![title isEqualToString:@""]) {
                        BOOL isCanScrollToSelectePosition = NO;
                        if (selectContentList.count > 0) {
                            isCanScrollToSelectePosition = [selectContentList[i] isEqualToString:title];
                        } else {
                            // discussion: scroll to select row error when solving content similar, only appear when there is only one component.
                            // reference: https://github.com/Abnerzj/ZJPickerView/issues/4
                            //            https://github.com/Abnerzj/ZJPickerView/issues/5
                            NSRange range = [selectedContent rangeOfString:title];
                            isCanScrollToSelectePosition = (self.component == 1) ? ([selectedContent isEqualToString:title]) : (range.location != NSNotFound);
                        }
                        
                        if (isCanScrollToSelectePosition) {
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
    }
    if (tempSelectedRowArray.count != self.component) {
        for (NSUInteger i = 0; i < self.component; i++) {
            [self.pickerView selectRow:0 inComponent:i animated:NO];
        }
        self.tipLabel.text = @"";
    }
}

@end
