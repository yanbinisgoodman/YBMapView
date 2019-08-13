//
//  YJPickerView.h
//  YouJie_iOS
//
//  Created by wangyf on 2017/6/6.
//  Copyright © 2017年 wangyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZPickerViewDelegate <NSObject>

- (void)backgroundBtnPress;
- (void)cancelBtnPress;
- (void)okBtnPressWithSelectStr:(NSString *)str row:(NSInteger)row;

@end

@interface DZPickerView : UIView

@property (nonatomic,strong) UIPickerView *selectPickerView;
///列数
@property (nonatomic, assign) NSInteger componentNum;
@property (nonatomic, weak) id<DZPickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr;
@end
