//
//  UIViewController+DZErrorView.m
//  creditcheck_ios
//
//  Created by srj on 17/3/16.
//  Copyright © 2017年 daze. All rights reserved.
//

#import "UIViewController+DZErrorView.h"

@implementation UIViewController (DZErrorView)
- (DZErrorView *)noOrdersView{
    return [DZErrorView initNoOrdersView];
}
- (DZErrorView *)notLoginView{
    return [DZErrorView initNotLoginView];
}
- (DZErrorView *)loadingView{
    return [DZErrorView initLoadingView];
}
-(DZErrorView *)noLoanView{
    return [DZErrorView initNoLoanLoadingView];
}
- (DZErrorView *)noCouponView{
    return [DZErrorView initNoCouponView];
}
- (DZErrorView *)noNetWorkView{
    return [DZErrorView initNoNetWorkView];
}
-(void)showErrorViewWithState:(DZControllerState)state
{
    DZErrorView *v = nil;
    switch (state) {
        case ControllerStateNoOrders:
            v = self.noOrdersView;
            break;
        case ControllerStateNotLogin:
            v = self.notLoginView;
            break;
        case ControllerStateLoading:
            v = self.loadingView;
            break;
        case ControllerStateNoLoan:
            v = self.noLoanView;
            break;
        case ControllerStateNoCoupons:
            v = self.noCouponView;
            break;
        case ControllerStateNoNetWork:
            v = self.noNetWorkView;
            break;
        default:
            break;
    }
    if (v){
        v.delegate = self;
        if (state == ControllerStateNoCoupons) {
            v.frame = CGRectMake(self.view.frame.origin.x, 60, self.view.frame.size.width, self.view.frame.size.height-ScreenWidth/(375/80.0));
        }else if (state == ControllerStateNoOrders) {
            v.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height-ScreenWidth/(375/80.0));
        }else{
            v.frame = self.view.bounds;
        }
        [self hideErrorView];
        [self.view addSubview:v];
    }
}
-(void)hideErrorView
{
    for (UIView * v in self.view.subviews) {
        if([v class]==[DZErrorView class])
        {
            [v removeFromSuperview];
        }
    }
}
- (void)actionBtnDidClick:(DZErrorView *)thisView state:(DZControllerState)state btn:(UIButton *)sender
{
    
}
@end
