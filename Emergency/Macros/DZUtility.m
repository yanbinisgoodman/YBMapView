//
//  DZUtility.m
//  loan_ios
//
//  Created by srj on 16/10/19.
//  Copyright © 2016年 daze. All rights reserved.
//

#import "DZUtility.h"
#import "SFHFKeychainUtils.h"
#import <AdSupport/AdSupport.h>
#import <Security/Security.h>
#import <sys/mount.h>

#define kServiceName       @"com.kongapi.creditchecker"
#define kUniqueIdentify    @"UniqueIdentify.com.kongapi.creditchecker"


@implementation DZUtility
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title textColor:(UIColor *)tColor andTarget:(id)target andSelector:(SEL)selector
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title sizeWithFont:QL_Default_Font(16)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame=CGRectMake(0, 0, size.width, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    if (tColor == nil){
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    }else {
        [btn setTitleColor:tColor forState:UIControlStateNormal];
        [btn setTitleColor:[tColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    }
    btn.titleLabel.font = QL_Default_Font(16);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)createBarButtonItemWithIcon:(UIImage *)iconImage highlightImage:(UIImage *)hImage andTarget:(id)target andSelector:(SEL)selector
{
    UIImage *image=iconImage;
    
    UIImage *itemBgImage = nil;
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame=CGRectMake(0, 0, 30, 30);
    
    [btn setBackgroundImage:itemBgImage forState:UIControlStateNormal];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hImage forState:UIControlStateHighlighted];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return backItem;
}
+ (UIBarButtonItem *)createBarButtonItemWithTitleAndIcon:(NSString *)title andTarge:(id)target andSelector:(SEL)selector shouldSetTitleEdge:(BOOL)should
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (should)
        btn.frame=CGRectMake(0, 0, 140, 44);
    else
        btn.frame=CGRectMake(0, 0, 60, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"back_j"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back_j"] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (should)
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = QL_Default_Font(18);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (void)rotate360DegreeWithImageView:(UIImageView *)imageView{
    if([imageView.layer animationForKey:@"rotationAnimation"] != nil){
        return;
    }
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    
    animation.duration = 2;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    //旋转次数
    animation.repeatCount = HUGE_VALF;
    
    [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

+ (void)rotateWithImageView:(UIImageView *)imageView angle:(int)angle{
    if([imageView.layer animationForKey:@"rotationAnimation"] != nil){
        return;
    }
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSNumber numberWithFloat:(angle/180.0) * -M_PI ];
    
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    //旋转次数
    animation.repeatCount = 0;
    animation.cumulative = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;

    [imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

+ (BOOL)isValidPhoneNum:(NSString *)phoneNum
{
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:phoneNum];
}
+ (BOOL)isValidVerifyCode:(NSString *)verifyCode
{
    return ([verifyCode trim] && ([verifyCode length] <= 8));
}
+ (BOOL)isValidPassword:(NSString *)password
{
    return ([password trim] && ([password length] >= 6) && ([password length] <= 20));
}
+ (BOOL)isNotSpecialString:(NSString *)s
{
    NSString *regex = @"[0-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:s];
}

+ (BOOL)isValidMoney:(NSString *)money
{
    NSString *regex = @"^([1-9]\\d{0,9}|0)([.]?|(\\.\\d{1,2})?)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:money];
}

+ (BOOL)isValidName:(NSString *)name
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{1,11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    return [predicate evaluateWithObject:name];
}

+ (BOOL)isValidDate:(NSString *)dateStr
{
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:8 * 60 * 60];
    NSString *today = [date description];
    int currentDay = [[[today substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue];
    int selectDay = [[dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue];
    if (currentDay < selectDay) {
        return NO;
    }
    return YES;
}

+ (BOOL)isHigher320w
{
    return (CGRectGetWidth([UIScreen mainScreen].bounds) > 320.f);
}
+ (BOOL)isValidIDCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

//时间相关
// format @"yyyy-MM-dd HH:mm:ss"
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.locale = locale;
    NSDate *destDate = [dateFormatter dateFromString:string];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    if (date == nil) {return nil;}
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.locale = locale;
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+ (int)dayDistanceFromDate:(NSDate *)date
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    int day = round(timeInterval / 86400);
    return day;
}

+ (NSString *)stringFromTimeStamp:(NSNumber *)timeStamp format:(NSString *)format
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000];
    return [self stringFromDate:confromTimesp format:format];
}
+ (BOOL)dateIsToday:(NSDate *)aDate{
  if (aDate == nil){return NO;}
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
  NSDate *today = [cal dateFromComponents:components];
  components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:aDate];
  NSDate *otherDate = [cal dateFromComponents:components];
  if([today isEqualToDate:otherDate]) {
    return YES;
  }else{
    return NO;
  }
}

/** * 获取当前时间所在一周的第一天和最后一天 */
+ (NSMutableArray *)getCurrentWeek
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                         fromDate:now];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday] - 1;
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    
//    NSArray *currentWeeks = [self getCurrentWeeksWithFirstDiff:firstDiff lastDiff:lastDiff];
    
    NSLog(@"firstDiff:%ld lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"一周开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"一周结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
//    NSLog(@"%@",currentWeeks);
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = firstDiff; i < lastDiff + 1; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        // NSString *dateStr = @"5月31日";
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
//        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}

// 类型转化
+ (NSString *)stringTrans:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]){
        return [obj JSONString];
    }else if ([obj isKindOfClass:[NSNumber class]]){
        return [obj stringValue];
    }else if ([obj isKindOfClass:[NSString class]]){
        return obj;
    }
    return nil;
}

+ (NSDictionary *)dictionaryTrans:(id)obj
{
    if([obj isKindOfClass:[NSDictionary class]]){
        return obj;
    }else if ([obj isKindOfClass:[NSString class]]){
        return [obj JSONObject];
    }
    return nil;
}

+ (NSNumber *)numberTrans:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]){
        return @([obj intValue]);
    }else if ([obj isKindOfClass:[NSNumber class]]){
        return obj;
    }else {
        return @(0);
    }
}
+ (NSArray *)arrayTrans:(id)obj
{
    if([obj isKindOfClass:[NSDictionary class]]){
        return @[obj];
    }else if ([obj isKindOfClass:[NSArray class]]){
        return obj;
    }
    return nil;
}

+ (NSString *)getIdfaUniqueIdentify
{
    NSError *error = nil;
    NSString *uniqueIdentify = [SFHFKeychainUtils getPasswordForUsername:kUniqueIdentify andServiceName:kServiceName error:&error];
    if (!uniqueIdentify)
    {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
        {
            NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            if (idfa) {
                
                [SFHFKeychainUtils storeUsername:kUniqueIdentify andPassword:idfa forServiceName:kServiceName updateExisting:YES error:&error];
                uniqueIdentify = idfa;
                
            } else {
                [SFHFKeychainUtils storeUsername:kUniqueIdentify andPassword:idfv forServiceName:kServiceName updateExisting:YES error:&error];
                uniqueIdentify = idfv;
            }
            
            if (!idfv && !idfa)
            {
                NSString *uuid = [[NSUUID UUID] UUIDString];
                [SFHFKeychainUtils storeUsername:kUniqueIdentify andPassword:uuid forServiceName:kServiceName updateExisting:YES error:&error];
                uniqueIdentify = uuid;
            }
        } else {
            
            NSString *uuid = [[NSUUID UUID] UUIDString];
            [SFHFKeychainUtils storeUsername:kUniqueIdentify andPassword:uuid forServiceName:kServiceName updateExisting:YES error:&error];
            uniqueIdentify = uuid;
        }
    }
    return uniqueIdentify;
}

+ (NSString *)getCurrentTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

+(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSInteger)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    int days=((int)time)/(3600*24);
    return days;
}

+ (NSArray *)getDateArrBetweenDate:(NSDate *)date AndOtherDate:(NSDate *)otherDate
{
    NSMutableArray *dateArr = [NSMutableArray array];
    //大的时间
    NSInteger bigTime = 0;
    //小的时间
    NSInteger smallTime = 0;
    //一天的秒数
    NSInteger dayTime = 60 * 60 * 24;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSComparisonResult result = [date compare:otherDate];
    if (result == NSOrderedDescending) {
        //当date比otherDate大时 转换成时间戳计算
        bigTime = [date timeIntervalSince1970];
        smallTime = [otherDate timeIntervalSince1970];
        NSLog(@"date比otherDate时间晚");
    }
    else if (result == NSOrderedAscending){
        //当date比otherDate小时时
        bigTime = [otherDate timeIntervalSince1970];
        smallTime = [date timeIntervalSince1970];
        NSLog(@"date比otherDate时间早");
    } else {
        NSLog(@"两者时间是同一个时间");
    }
    NSInteger day = (bigTime - smallTime) / dayTime;
    while (smallTime <= bigTime) {
        NSString *dateStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:smallTime]];
        [dateArr addObject:dateStr];
        smallTime += dayTime;
    }
    return dateArr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    NSLog(@"sss%@sss", jsonString);
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *messageInfo = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\r\n" withString:@"" ];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\n" withString : @"" ];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\t" withString : @"" ];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"/" withString : @"" ];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"&" withString : @"" ];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@" " withString : @"" ];

    


    NSLog(@"%@", messageInfo);
    NSData *jsonDataa = [messageInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonDataa
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)getVersionCodeStr
{
    NSString *buildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]?[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]:nil;
    buildStr = [NSString stringWithFormat:@"%ld", (long)([buildStr integerValue])];
    return buildStr;
}
+ (NSString *)getVersionStr
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}
+ (NSString *)getDisplayName
{
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    return appName?:@"";
}
+ (void)callPhone:(NSString *)phone
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *mobile = [NSString stringWithFormat:@"tel://%@",phone];
    NSURL *telURL =[NSURL URLWithString:mobile];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:callWebview];
}
+ (long long)totalDiskSize{
  struct statfs buf;
  unsigned long long freeSpace = -1;
  if (statfs("/var", &buf) >= 0){
    freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
  }
  return freeSpace;
}

+(NSString *)totalDiskSizeString{
  return [self fileSizeToString:[self totalDiskSize]];
}
+ (long long)totalMemorySize{
  return [[NSProcessInfo processInfo] physicalMemory];
}
+(NSString *)totalMemorySizeString{
  return [self fileSizeToString:[self totalMemorySize]];
}
+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
  NSInteger KB = 1024;
  NSInteger MB = KB*KB;
  NSInteger GB = MB*KB;
  
  if (fileSize < 10){
    return @"0 B";
  }else if (fileSize < KB){
    return @"< 1 KB";
  }else if (fileSize < MB){
    return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
  }else if (fileSize < GB){
    return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
  }else{
    return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
  }
}

+ (BOOL)isShowLoanModule
{
    NSNumber *show = XBGetUserDefaults(@"showLoanModule");
    return [show boolValue];
}

/**
 设置view指定位置的边框
 
 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
+ (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    
    if (borderType == UIBorderSideTypeAll) {
        originalView.layer.borderWidth = borderWidth;
        originalView.layer.borderColor = color.CGColor;
        return originalView;
    }
    
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.0f, 0.0f)];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [bezierPath moveToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    
    [originalView.layer addSublayer:shapeLayer];
    
    return originalView;
}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

+ (NSString *)fullCharactor:(NSString *)aString{
    //低效率
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    return pinYin;
}
@end
