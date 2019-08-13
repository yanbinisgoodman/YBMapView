//
//  DZWebViewController.h
//  loan_ios
//
//  Created by srj on 16/10/19.
//  Copyright © 2016年 daze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
///有导航栏的
@interface DZWebViewController : UIViewController
- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithHTMLString:(NSString *)htmlString;

@property (nonatomic, weak) id<UIWebViewDelegate> delegate;
@property (nonatomic) BOOL isPresent; //是否模态 push/pop
@property (nonatomic) BOOL isParent;    //是否处于父级
@property WKWebViewJavascriptBridge *bridge;

@end
