//
//  DZErrorView.h
//  creditcheck_ios
//
//  Created by srj on 17/3/16.
//  Copyright © 2017年 daze. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,DZControllerState){
    ControllerStateNoOrders=0,
    ControllerStateNotLogin,
    ControllerStateLoading,
    ControllerStateNoLoan,
    ControllerStateNoCoupons,
    ControllerStateNoNetWork,
};
@protocol DZErrorViewBtnActionDelegate;

@interface DZErrorView : UIView
+ (instancetype)initNoOrdersView;
+ (instancetype)initNotLoginView;
+ (instancetype)initLoadingView;
+ (instancetype)initNoLoanLoadingView;
+ (instancetype)initNoCouponView;
+ (instancetype)initNoNetWorkView;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (assign,nonatomic) DZControllerState  state;
@property (assign,nonatomic) id<DZErrorViewBtnActionDelegate>  delegate;
@end

@protocol DZErrorViewBtnActionDelegate <NSObject>
@optional
-(void)actionBtnDidClick:(DZErrorView*)thisView state:(DZControllerState)state btn:(UIButton *)sender;
@end
