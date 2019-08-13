//
//  DZBaseNavigationController.m
//  loan_ios
//
//  Created by srj on 16/10/18.
//  Copyright © 2016年 daze. All rights reserved.
//

#import "DZBaseNavigationController.h"

@interface DZBaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation DZBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor colorWithWhite:0.000 alpha:0.500]];
    [shadow setShadowOffset:CGSizeZero];
    if (self) {
        [self.navigationBar setBackgroundImage:[UIImage new]
                                 forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:QL_RGBAlpha(0, 0, 0, 0.87),
                                                     NSFontAttributeName:QL_Default_Medium_Font(16)}];
        [self.navigationBar setTranslucent:NO];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak DZBaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    
    [super pushViewController:viewController animated:animated];
          
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem = [DZUtility createBarButtonItemWithIcon:[UIImage imageNamed:@"return"] highlightImage:[UIImage imageNamed:@"return"] andTarget:self andSelector:@selector(popself)];
    }
  
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

-(void)popself
{
    [DZRequestHUD dismiss];
    [self popViewControllerAnimated:YES];
}

@end
