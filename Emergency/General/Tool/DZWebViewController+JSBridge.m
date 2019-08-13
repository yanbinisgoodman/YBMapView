//
//  YVWebViewController+JSBridge.m
//  CreditCheck
//
//  Created by relax on 2018/5/18.
//  Copyright © 2018年 daze. All rights reserved.
//

#import "DZWebViewController+JSBridge.h"
#import "AppDelegate.h"

@implementation DZWebViewController (JSBridge)

- (void)configJSBridgeActions:(WKWebViewJavascriptBridge *)bridge webView:(WKWebView *)webView {
  //开启调试信息
  [WKWebViewJavascriptBridge enableLogging];
  [bridge setWebViewDelegate:self];
 
}

@end
