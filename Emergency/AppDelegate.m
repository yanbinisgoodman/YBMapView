//
//  AppDelegate.m
//  Emergency
//
//  Created by gzx on 2019/8/6.
//  Copyright © 2019 古智性. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //获取地址
    [[QLMediator sharedInstance] location_currentLocation:^(BOOL success) {
    }];
    
    [AMapServices sharedServices].apiKey = @"0ec8d108cf26461a9a5d38bf2eb748cb";
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [self configPlist];
    [self switchToRootView];
    
    
    
    
    return YES;
}

- (void)switchToRootView
{
    self.rootController = nil;
    [self _switchToViewController:self.rootController];
}

#pragma mark - Switch To
- (void)_switchToViewController:(UIViewController *)viewController
{
    [self.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

#pragma mark - SideMenu
- (DZBaseNavigationController *)rootController{
    if (!_rootController){
        MapController *mapVC = [[MapController alloc] init];
        _rootController = [[DZBaseNavigationController alloc] initWithRootViewController:mapVC];
    }
    return _rootController;
}

#pragma mark - Global Access Helper
+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)configPlist
{
    NSArray *targets = [AroundStoreModel searchWithWhere:nil];
    if (targets.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AroundStore" ofType:@"plist"];
        NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSArray *list = [AroundStoreModel mj_objectArrayWithKeyValuesArray:data];
        [AroundStoreModel insertArrayByAsyncToDB:list];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {}


- (void)applicationDidEnterBackground:(UIApplication *)application {}


- (void)applicationWillEnterForeground:(UIApplication *)application {}


- (void)applicationDidBecomeActive:(UIApplication *)application {}


- (void)applicationWillTerminate:(UIApplication *)application {}


@end
