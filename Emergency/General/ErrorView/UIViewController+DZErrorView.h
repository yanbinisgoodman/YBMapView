//
//  UIViewController+DZErrorView.h
//  creditcheck_ios
//
//  Created by srj on 17/3/16.
//  Copyright © 2017年 daze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZErrorView.h"

@interface UIViewController (DZErrorView)<DZErrorViewBtnActionDelegate>
@property(nonatomic,strong,readonly) DZErrorView * noOrdersView;
@property(nonatomic,strong,readonly) DZErrorView * notLoginView;
@property(nonatomic,strong,readonly) DZErrorView * loadingView;
@property(nonatomic,strong,readonly) DZErrorView * noloanView;
@property(nonatomic,strong,readonly) DZErrorView * noCouponView;
@property(nonatomic,strong,readonly) DZErrorView * noNetWorkView;

-(void)showErrorViewWithState:(DZControllerState)state;
-(void)hideErrorView;

@end
