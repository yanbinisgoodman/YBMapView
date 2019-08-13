//
//  DZWebViewController.m
//  loan_ios
//
//  Created by srj on 16/10/19.
//  Copyright © 2016年 daze. All rights reserved.
//

#import "DZWebViewController.h"
#import "UIViewController+DZErrorView.h"
#import <WebKit/WebKit.h>
#import "DZWebViewController+JSBridge.h"
#import "YVWebViewController.h"

@interface DZWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *htmlString;
@end

@implementation DZWebViewController
{
  BOOL isLoadHtmlStirng;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self){
  }
  return self;
}
- (void)dealloc {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  @try {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"URL"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
  }
  @catch (NSException *exception) {
  }
  
  self.delegate = nil;
}
- (instancetype)initWithAddress:(NSString *)urlString {
  return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
  return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithHTMLString:(NSString *)htmlString {
  self = [super init];
  if (self) {
    isLoadHtmlStirng = YES;
    self.htmlString = htmlString;
  }
  return self;
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
  self = [super init];
  if (self) {
    self.request = request;
  }
  return self;
}

- (void)loadRequest:(NSURLRequest*)request {
  [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
  [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
  [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];

  self.webView.navigationDelegate = self;
  self.webView.scrollView.delegate = self;
  
  [self.webView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kTopHeight-kBottomHeight)];
  [self.webView loadRequest:request];
  
  [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self.webView addSubview:self.progressView];
  if (isLoadHtmlStirng){
    [self.webView loadHTMLString:self.htmlString baseURL:nil];
  }else {
    [self loadRequest:self.request];
  }
  
  self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
  [self configJSBridgeActions:self.bridge webView:self.webView];
  
  if (!self.isParent){
    [self.navigationItem setLeftBarButtonItem:[DZUtility createBarButtonItemWithIcon:[UIImage imageNamed:@"arrow_back_black"] highlightImage:[UIImage imageNamed:@"arrow_back_black"] andTarget:self andSelector:@selector(popself)]];
  }
}

- (void)popself {
  if (self.isPresent){
    [self dismissViewControllerAnimated:YES completion:nil];
  }else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleDefault;
}

#pragma mark - Getters
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
    CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
    if (newprogress == 1){
      self.progressView.hidden = YES;
      [self.progressView setProgress:1.0 animated:YES];
    }else{
      self.progressView.hidden = NO;
      [self.progressView setProgress:newprogress animated:YES];
    }
  }
  if (object == self.webView && [keyPath isEqualToString:@"canGoBack"]) {
    if (self.webView.canGoBack == YES) {
      self.navigationItem.leftBarButtonItem = [DZUtility createBarButtonItemWithIcon:[UIImage imageNamed:@"arrow_back_black"] highlightImage:[UIImage imageNamed:@"arrow_back_black"] andTarget:self andSelector:@selector(webViewGoBack)];
    }else {
      self.navigationItem.leftBarButtonItem = nil;
    }
  }
}

- (void)webViewGoBack {
  [self.webView goBack];
  if (self.webView.canGoBack == YES) {
    self.navigationItem.leftBarButtonItem = [DZUtility createBarButtonItemWithIcon:[UIImage imageNamed:@"arrow_back_black"] highlightImage:[UIImage imageNamed:@"arrow_back_black"] andTarget:self andSelector:@selector(webViewGoBack)];
  }else {
    self.navigationItem.leftBarButtonItem = nil;
  }
}

#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id str, NSError *err) {
    NSString *theTitle = (NSString *)str;
    if (theTitle.length > 12) {
      theTitle = [[theTitle substringToIndex:12] stringByAppendingString:@"…"];
    }
    if (self.title.length == 0){
      self.title = theTitle;
    }
  }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  NSString *href = navigationAction.request.URL.absoluteString;
  if ([href hasPrefix:@"anniuapp://"]) {
    NSString *url = [href substringWithRange:NSMakeRange(11, href.length - 11)];
    if([url rangeOfString:@"https//"].location != NSNotFound){
      url = [url stringByReplacingOccurrencesOfString:@"https//" withString:@"https://"];
    }
    if([url rangeOfString:@"http//"].location != NSNotFound){
      url = [url stringByReplacingOccurrencesOfString:@"http//" withString:@"http://"];
    }
    YVWebViewController *web = [[YVWebViewController alloc] initWithRouterType:RouterFromVCTypeUrl withData:url];
    [self.navigationController pushViewController:web animated:YES];
    
    decisionHandler(WKNavigationActionPolicyCancel);
    return;
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (WKWebView *)webView {
  if (!_webView){
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); ";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    [_webView sizeToFit];
  }
  return _webView;
}

- (UIProgressView *)progressView {
  if (!_progressView)
  {
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2)];
    _progressView.tintColor = [UIColor blueColor];
    _progressView.trackTintColor = [UIColor clearColor];
  }
  return _progressView;
}

@end
