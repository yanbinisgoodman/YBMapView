//
//  DZWebViewController+JSBridge.h
//  CreditCheck
//
//  Created by relax on 2018/5/18.
//  Copyright © 2018年 daze. All rights reserved.
//

#import "DZWebViewController.h"

@interface DZWebViewController (JSBridge)
- (void)configJSBridgeActions:(WKWebViewJavascriptBridge *)bridge webView:(WKWebView *)webView;
@end
