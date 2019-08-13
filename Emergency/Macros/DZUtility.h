//
//  DZUtility.h
//  loan_ios
//
//  Created by srj on 16/10/19.
//  Copyright © 2016年 daze. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 边框类型(位移枚举)
typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

#define  kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define  kNavBarHeight    44.0
#define  kTabBarHeight      ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define  kBottomHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define  kTopHeight       (kStatusBarHeight+kNavBarHeight)
#define  iPhoneXSeries   (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))

@interface DZUtility : NSObject
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)tColor andTarget:(id)target andSelector:(SEL)selector;
+ (UIBarButtonItem *)createBarButtonItemWithIcon:(UIImage *)iconImage highlightImage:(UIImage *)hImage andTarget:(id)target andSelector:(SEL)selector;
+ (UIBarButtonItem *)createBarButtonItemWithTitleAndIcon:(NSString *)title andTarge:(id)target andSelector:(SEL)selector shouldSetTitleEdge:(BOOL)should;
+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;
//旋转360图片
+ (void)rotate360DegreeWithImageView:(UIImageView *)imageView;
+ (void)rotateWithImageView:(UIImageView *)imageView angle:(int)angle;
//大于320的宽度
+ (BOOL)isHigher320w;

//判断字符串
+ (BOOL)isValidPhoneNum:(NSString *)phoneNum;
+ (BOOL)isValidVerifyCode:(NSString *)verifyCode;
+ (BOOL)isNotSpecialString:(NSString *)s;
+ (BOOL)isValidPassword:(NSString *)password;
+ (BOOL)isValidMoney:(NSString *)money;
+ (BOOL)isValidName:(NSString *)name;
+ (BOOL)isValidIDCard:(NSString *)identityCard;
+ (BOOL)isValidDate:(NSString *)dateStr;

//事件相关
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (int)dayDistanceFromDate:(NSDate *)date;
+ (NSString *)stringFromTimeStamp:(NSNumber *)timeStamp format:(NSString *)format;
+ (BOOL)dateIsToday:(NSDate *)aDate;

//类型转化
+ (NSString *)stringTrans:(id)obj;
+ (NSDictionary *)dictionaryTrans:(id)obj;
+ (NSArray *)arrayTrans:(id)obj;
+ (NSNumber *)numberTrans:(id)obj;
//+ (NSString *)getUniqueIdentify;
+ (NSString *)getIdfaUniqueIdentify;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)getVersionCodeStr;
+ (NSString *)getVersionStr;
+ (NSString *)getDisplayName;
+ (void)callPhone:(NSString *)phone;

+ (NSString *)totalDiskSizeString;
+ (NSString *)totalMemorySizeString;


//获取当天
+ (NSString *)getCurrentTimes;
//获取两个时间之间的date
+ (NSArray *)getDateArrBetweenDate:(NSDate *)date AndOtherDate:(NSDate *)otherDate;
+ (NSMutableArray *)getCurrentWeek;
+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

+ (BOOL)isShowLoanModule;
+ (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;
+(NSString *)getNowTimeTimestamp;

//判断是否打开通知
+ (BOOL)isUserNotificationEnable;
+ (void)goToAppSystemSetting;
+ (NSString *)fullCharactor:(NSString *)aString;
@end
