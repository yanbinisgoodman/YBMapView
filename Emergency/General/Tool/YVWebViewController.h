//
//  YVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
typedef NS_ENUM(NSUInteger, RouterFromVCType) {
  RouterFromVCTypeUrl = 0,    //从单纯的url过来
  RouterFromVCTypeHtml,       //从Html
  RouterFromVCTypeLoan,       //从贷款平台
  RouterFromVCTypeAdvert,     //从广告点击
  RouterFromVCTypeQBD,        //从钱包到
};
typedef NS_ENUM(NSUInteger, RouterWebType) {
  RouterWebTypeLoan = 0,    //贷款
  RouterWebTypeService,     //服务
  RouterWebTypeActivity,    //活动
  RouterWebTypeQBD,         //钱包到
  RouterWebTypeOther,       //其他
};
///底部导航栏
@interface YVWebViewController : UIViewController

@property (nonatomic, assign) BOOL showToolBarItem;
@property (nonatomic, assign) BOOL shouldBackOneStep;
@property (nonatomic, assign) BOOL isSplash;
@property (nonatomic, assign) BOOL ishiddenBox;
@property (nonatomic, strong) NSDictionary *platformData;

@property (nonatomic, assign) RouterFromVCType routerType;
@property (nonatomic, assign) RouterWebType webType;
@property (nonatomic) id routerData; //对应的router
@property (nonatomic,strong) NSDictionary *extra;

//- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

- (instancetype)initWithRouterType:(RouterFromVCType)routerType withData:(id)routerData;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end
