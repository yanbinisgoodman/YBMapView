//
//  AppDelegate.h
//  Emergency
//
//  Created by gzx on 2019/8/6.
//  Copyright © 2019 古智性. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) DZBaseNavigationController *rootController;
@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)globalDelegate;

- (void)switchToRootView;

@end

