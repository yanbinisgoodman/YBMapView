//
//  YVWebViewController+JSBridge.h
//  CreditCheck
//
//  Created by relax on 2018/5/18.
//  Copyright © 2018年 daze. All rights reserved.
//

#import "YVWebViewController.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@interface YVWebViewController (JSBridge)
- (void)configJSBridgeActions:(WebViewJavascriptBridge *)bridge webView:(UIWebView *)webView;
@end
