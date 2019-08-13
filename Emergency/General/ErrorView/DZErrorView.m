//
//  DZErrorView.m
//  creditcheck_ios
//
//  Created by srj on 17/3/16.
//  Copyright © 2017年 daze. All rights reserved.
//

#import "DZErrorView.h"
@interface DZErrorView()
@property (strong, nonatomic) IBOutlet UIView *nlv;
@property (strong, nonatomic) IBOutlet UIView *nrv;
@property (strong, nonatomic) IBOutlet UIView *nldv;
@property (strong, nonatomic) IBOutlet UIView * nlnv;
@property (strong, nonatomic) IBOutlet UIView *ncv;//优惠券
@property (strong, nonatomic) IBOutlet UIView *nnwv;//无网络

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;

@property (strong, nonatomic) IBOutlet UILabel * noOrder;
@property (weak, nonatomic) IBOutlet UIButton *tryBtn;

@end

@implementation DZErrorView

+(instancetype)initNibView
{
    DZErrorView * v=[[[NSBundle mainBundle] loadNibNamed:@"DZErrorView" owner:nil options:nil] lastObject];
    [v.loginBtn addTarget:v action:@selector(actionBtnTask:) forControlEvents:UIControlEventTouchUpInside];
    [v.checkBtn addTarget:v action:@selector(actionBtnTask:) forControlEvents:UIControlEventTouchUpInside];
    [v.tryBtn addTarget:v action:@selector(actionBtnTask:) forControlEvents:UIControlEventTouchUpInside];

    return v;
}
+ (instancetype)initNoOrdersView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateNoOrders;
    view.nrv.backgroundColor = [UIColor clearColor];
    view.nrv.hidden = NO;
    view.checkBtn.layer.borderColor = [UIColor colorWithHex:@"#000000" alpha:0.87].CGColor;
    return view;
}
+ (instancetype)initNotLoginView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateNotLogin;
    view.nlv.backgroundColor = [UIColor clearColor];
    view.nlv.hidden = NO;
    view.loginBtn.layer.borderColor = [UIColor colorWithHex:@"#000000" alpha:0.87].CGColor;
    return view;
}
+ (instancetype)initLoadingView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateLoading;
    view.nldv.backgroundColor = [UIColor clearColor];
    view.nldv.hidden = NO;
    return view;
}
+ (instancetype)initNoLoanLoadingView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateNoLoan;
    view.nlnv.backgroundColor = [UIColor clearColor];
    view.nlnv.hidden = NO;
    return view;
}
+ (instancetype)initNoCouponView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateNoCoupons;
    view.ncv.backgroundColor = [UIColor clearColor];
    view.ncv.hidden = NO;
    return view;
}
+ (instancetype)initNoNetWorkView
{
    DZErrorView * view = [self initNibView];
    view.state = ControllerStateNoNetWork;
    view.nnwv.backgroundColor = [UIColor clearColor];
    view.nnwv.hidden = NO;
    return view;
}
-(void)actionBtnTask:(UIButton*)sender
{
    if(self.delegate)
        [self.delegate actionBtnDidClick:self state:self.state btn:sender];
}

@end
