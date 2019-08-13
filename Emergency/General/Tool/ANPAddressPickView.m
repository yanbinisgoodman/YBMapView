//
//  PopupView.m
//  买布易
//
//  Created by 张建 on 15/6/26.
//  Copyright (c) 2015年 张建. All rights reserved.
//

#import "ANPAddressPickView.h"
#import "QLDefine.h"
#import "ANPUIViewExt.h"

#define navigationViewHeight 44.0f
#define pickViewViewHeight 200.0f
#define buttonWidth 60.0f

@interface ANPAddressPickView ()

@property(nonatomic,strong)NSDictionary *pickerDic;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,strong)NSArray *selectedArray;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,strong)NSArray *townArray;
@property(nonatomic,strong)UIView *bottomView;//包括导航视图和地址选择视图
@property(nonatomic,strong)UIPickerView *pickView;//地址选择视图
@property(nonatomic,strong)UIView *navigationView;//上面的导航视图

@end

@implementation ANPAddressPickView
+ (instancetype)shareInstance
{
    static ANPAddressPickView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ANPAddressPickView alloc] init];
    });
    
    [shareInstance showBottomView];
    return shareInstance;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self _addTapGestureRecognizerToSelf];
        [self _getPickerData];
        [self _createView];
    }
    return self;
  
}
#pragma mark - get data
- (void)_getPickerData
{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"ANPAddress" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
-(void)_addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}
-(void)_createView
{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, navigationViewHeight+pickViewViewHeight)];
    [self addSubview:_bottomView];
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:_navigationView];
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
    NSArray *buttonTitleArray = @[@"取消",@"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i*(ScreenWidth-buttonWidth), 0, buttonWidth, navigationViewHeight);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:QL_RGBAlpha(0, 0, 0, 0.60) forState:UIControlStateNormal];
        [_navigationView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    [_bottomView addSubview:_pickView];
    
    
}
-(void)tapButton:(UIButton*)button
{
    //点击确定回调block
    if (button.tag == 1) {
        
        NSString *province = [self.provinceArray objectAtIndex:[_pickView selectedRowInComponent:0]];
        NSString *city = [self.cityArray objectAtIndex:[_pickView selectedRowInComponent:1]];
        NSString *town = [self.townArray objectAtIndex:[_pickView selectedRowInComponent:2]];
        
        _block(province,city,town);
    }
    
    [self hiddenBottomView];

    
}
-(void)showBottomView
{
    self.backgroundColor = [UIColor clearColor];
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bottomView.top = ScreenHeight- (navigationViewHeight + pickViewViewHeight) - 50;
        weakSelf.backgroundColor = QL_RGBAlpha(0, 0, 0, 0.2);
    } completion:^(BOOL finished) {

    }];
}
-(void)hiddenBottomView
{
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bottomView.top = ScreenHeight;
        weakSelf.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
    } else if (component == 1) {
        return _cityArray.count;
    } else {
        return _townArray.count;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:16.0f];
    if (component == 0) {
        lable.text=[self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        lable.text=[self.cityArray objectAtIndex:row];
    } else {
        lable.text=[self.townArray objectAtIndex:row];
    }
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat pickViewWidth = ScreenWidth/3;

    return pickViewWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}


@end
