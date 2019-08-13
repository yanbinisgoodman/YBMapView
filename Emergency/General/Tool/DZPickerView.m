//
//  DZPickerView.m
//  YouJie_iOS
//
//  Created by wangyf on 2017/6/6.
//  Copyright © 2017年 wangyf. All rights reserved.
//

#import "DZPickerView.h"
#import "Masonry.h"

@interface DZPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *pickViewSuperV;
}
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation DZPickerView
- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr
{
    self = [super initWithFrame:frame];
    self.dataArr = dataArr;
    if (self) {
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        backgroundBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [backgroundBtn addTarget:self action:@selector(backgroundBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundBtn];
        
        UIView *pickerSuperV = [UIView new];
        pickerSuperV.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerSuperV];
        [pickerSuperV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(220);
        }];

        self.selectPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
        // 显示选中框
        self.selectPickerView.showsSelectionIndicator = NO;
        self.selectPickerView.backgroundColor = [UIColor whiteColor];
        self.selectPickerView.delegate = self;
        self.selectPickerView.dataSource = self;
        self.selectPickerView.autoresizingMask = UIViewAutoresizingNone;
        [pickerSuperV addSubview:self.selectPickerView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:@"#000000" alpha:0.54] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelBtn addTarget:self action:@selector(cancelBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [pickerSuperV addSubview:cancelBtn];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor colorWithHex:@"#000000" alpha:0.54]  forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [okBtn addTarget:self action:@selector(okBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [pickerSuperV addSubview:okBtn];
        
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-19);
            make.bottom.mas_equalTo(-19);
            make.height.mas_equalTo(20);
        }];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(okBtn.mas_left).offset(-30);
            make.bottom.mas_equalTo(-19);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

#pragma mark - private methods 

- (void)backgroundBtnPress:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(backgroundBtnPress)]) {
        [self.delegate backgroundBtnPress];
    }
}

- (void)cancelBtnPress:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(cancelBtnPress)]) {
        [self.delegate cancelBtnPress];
    }
}

- (void)okBtnPress:(UIButton *)btn {
    NSString *str = @"";
    if (self.componentNum == 1) {
        NSInteger row=[self.selectPickerView selectedRowInComponent:0];
        str=[self.dataArr objectAtIndex:row];
    }
    else {
        NSInteger firstRow=[self.selectPickerView selectedRowInComponent:0];
        NSInteger secondRow=[self.selectPickerView selectedRowInComponent:1];
        
        NSString *firstStr = [self.dataArr objectAtIndex:firstRow];
        NSString *secondStr = [self.dataArr objectAtIndex:secondRow];
        str = [NSString stringWithFormat:@"%@ - %@",firstStr, secondStr];
    }
    
    NSInteger rows=[self.selectPickerView selectedRowInComponent:0];
    if (self.delegate) {
        [self.delegate okBtnPressWithSelectStr:str row:rows+1];
    }
}

#pragma mark - UIPickerView代理方法
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.componentNum;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ScreenWidth / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArr objectAtIndex:row];
}

//重写方法,改变字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
        pickerLabel.textColor = [UIColor blackColor];
        pickerLabel.textAlignment = 1;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    //在该代理方法里添加以下两行代码删掉上下的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:YES];
    [[pickerView.subviews objectAtIndex:2] setHidden:YES];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 65, ScreenWidth, 1.5)];
    lineView1.backgroundColor = [UIColor colorWithHex:@"#fafafa" alpha:1];
    [pickerView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth, 1.5)];
    lineView2.backgroundColor = [UIColor colorWithHex:@"#fafafa" alpha:1];
    [pickerView addSubview:lineView2];
    
    return pickerLabel;
}


@end
