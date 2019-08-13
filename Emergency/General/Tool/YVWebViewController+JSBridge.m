//
//  YVWebViewController+JSBridge.m
//  CreditCheck
//
//  Created by relax on 2018/5/18.
//  Copyright © 2018年 daze. All rights reserved.
//

#import "YVWebViewController+JSBridge.h"
#import "AppDelegate.h"

@implementation YVWebViewController (JSBridge)

- (void)configJSBridgeActions:(WebViewJavascriptBridge *)bridge webView:(UIWebView *)webView {
  //开启调试信息
  [WebViewJavascriptBridge enableLogging];
  [bridge setWebViewDelegate:self];

}

@end
