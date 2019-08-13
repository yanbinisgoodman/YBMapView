//
//  DZConst.h
//  loan_ios
//
//  Created by srj on 16/10/18.
//  Copyright © 2016年 daze. All rights reserved.
//

#ifndef DZConst_h
#define DZConst_h

#define ScreenWidth             CGRectGetWidth([[UIScreen mainScreen] bounds])
#define ScreenHeight            CGRectGetHeight([[UIScreen mainScreen] bounds])


#define MatchColor              [UIColor colorWithHex:@"#FFFFFF" alpha:1]
#define BaseColor2              [UIColor colorWithHex:@"#757575" alpha:1.0]
#define ButtonColor             [UIColor colorWithHex:@"#677BBE" alpha:1.0]
#define MainBGCololr            [UIColor colorWithHex:@"#F6871F" alpha:1.0]
#define ButtonColor_02          [UIColor colorWithHex:@"#677BBE" alpha:0.2]
#define ButtonDisableColor      [UIColor colorWithHex:@"#e0e0e0" alpha:1.0]
#define BarColor                [UIColor colorWithHex:@"#F9A01B" alpha:1.0]
#define LineColor               [UIColor colorWithHex:@"#000000" alpha:0.08]

#define BackgroundColor         [UIColor colorWithHex:@"#F5F5F5" alpha:1.0]

#define MainBlueColor           [UIColor colorWithHex:@"#536DFE" alpha:1.0]
#define MainBlackColor          [UIColor colorWithHex:@"#212121" alpha:1.0]
#define SubBlackColor           [UIColor colorWithHex:@"#9e9e9e" alpha:1.0]
#define RedColor                    [UIColor colorWithHex:@"#ff5252" alpha:1.0]
#define PurpleColor                 [UIColor colorWithHex:@"#7f8dd6" alpha:1.0]

#ifndef __OPTIMIZE__
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

#define XBString(FORMAT,...)        [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]
#define NotNil(x)                   (x) == nil ? @"" : (x)
#define NotNilChar(x)               ((x) == nil || [x length] == 0)? @"--" : (x)
#define NotNilZero(x)               (x) == nil ? @"0" : (x)

#define gMyUser                     [DZUser currentUser]
#define UID                         [[DZUser currentUser] sessionId]
#define TOKEN                       [[DZUser currentUser] token]
#define USERDEFAULTS                [NSUserDefaults standardUserDefaults]

#define XBSetUserDefaults(id,key)       [[NSUserDefaults standardUserDefaults] setObject:id forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize];
#define XBGetUserDefaults(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define NOTIFI_ALIPAY_PAY_RESULT        @"NOTIFI_ALIPAY_PAY_RESULT"
#define NOTIFI_WEIXIN_PAY_RESULT        @"NOTIFI_WEIXIN_PAY_RESULT"
#define NOTIFI_PAY_SUCCESS              @"NOTIFI_PAY_SUCCESS"

#define NOTIFI_SELECTED_CONTACT         @"NOTIFI_SELECTED_CONTACT"
#define NOTIFI_REFRESH_CHILDCONTROLLER  @"NOTIFI_REFRESH_CHILDCONTROLLER"

#define NOTIFI_YOUDUN_AUTH              @"YouDunAuthNotif"


//登录成功和失败
#define KANLOGINSUCCESS        @"KAN_LOGIN_SUCCESS"
#define KANLOGINOUTERROR        @"KAN_LOGINOUT_ERROR"
#define KANMINESELFSUCCESS        @"KAN_MINE_SELF_SUCCESS"
#endif /* DZConst_h */
