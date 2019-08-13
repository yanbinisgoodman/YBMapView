//
//  QLDefines.h
//  CreditSearch
//
//  Created by srj on 2018/3/20.
//  Copyright © 2018年 daze. All rights reserved.
//

#ifndef QLDefines_h
#define QLDefines_h

#define YQ_SafetyStringByAppendingString(A, B) (B) ? [(A) stringByAppendingString:(B)] : (A)

static NSString *QLAppCode                          = @"appcode";
static NSString *QLAppClient                        = @"iphone";
static NSString *QLAppClientId                      = @"clientId";
static NSString *QLAppGuestId                       = @"guestId";

static NSString *ZXCustomerServiceNoFetch           = @"CustomerServiceNotFetch";     

static NSString *CarouseUserContent                 = @"CarouseUserContent";
static NSString *CarouseUserContentAdd              = @"CarouseUserContentAdd";
static NSString *ButtonsText                        = @"buttonsText";
static NSString *CheckOrder                         = @"checkOrder";
static NSString *AllRiskDetectionChecked            = @"AllRiskDetectionChecked";
static NSString *transferSampleSubmit               = @"transferSampleSubmit";
static NSString *transferSamplePay                  = @"transferSamplePay";
static NSString *transferSampleAlipay               = @"transferSampleAlipay";
static NSString *transferSampleWXPay                = @"transferSampleWXPay";
static NSString *transferSampleCPIC                 = @"transferSampleCPIC";
static NSString *transferSampleEmergency            = @"transferSampleEmergency"; //紧急联系人个数配置
static NSString *transferBindRisks                  = @"transferBankCombination";       //搭售开关
static NSString *tabbarHotDot                       = @"tabbarHotDot";
static NSString *MoneyArrivalStatus                 = @"MoneyArrivalStatus";
static NSString *PushRecordCurrentDate              = @"PushRecordCurrentDate";
static NSString *NoWarnLoanCurrentDate              = @"NoWarnLoanCurrentDate";
static NSString *MemberVipCurrentDate               = @"MemberVipCurrentDate";
static NSString *MemberVipReopenCurrentDate         = @"MemberVipReopenCurrentDate";

static NSString *AgreementUrl                       = @"https://activity.kongapi.com/ddm_agreement/";
static NSString *AuthorationUrl                     = @"https://activity.kongapi.com/ddm_authorization/";
static NSString *HelpUrl                            = @"https://activity.kongapi.com/zxcx_help/";
static NSString *PolicyUrl                          = @"https://activity.kongapi.com/ddm_yszc/";

#endif /* QLDefines_h */
