//
//  YVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.

#import "YVWebViewController.h"
#import "UIViewController+DZErrorView.h"
#import <objc/runtime.h>    //notify
#import <CommonCrypto/CommonDigest.h> //nsdata
#import "YVWebViewController+JSBridge.h"
#import "AppDelegate.h"

@interface YVWebViewController ()<
UIWebViewDelegate
>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL hasAddIcon;
@property (nonatomic, strong) NSDictionary *nextLoanPro;
//3.1.0
@end


@implementation YVWebViewController
{
  NSInteger _userAgentLockToken;
  NSString* _userAgent;
  BOOL _isPresent;
  BOOL _shouldLoadRemoteJSAndCSS;
}

#pragma mark - Initialization

- (void)dealloc {
  [self.webView stopLoading];
  self.webView.delegate = nil;
  self.delegate = nil;
}

//- (instancetype)initWithAddress:(NSString *)urlString {
//    return [self initWithURL:[NSURL URLWithString:urlString]];
//}

- (instancetype)initWithURL:(NSURL*)pageURL{
  return [self initWithURLRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest*)request {
  self = [super init];
  if (self) {
    self.request = request;
  }
  return self;
}
- (instancetype)initWithRouterType:(RouterFromVCType)routerType withData:(id)routerData
{
  self = [super init];
  if (self){
    self.routerData = routerData;
    self.routerType = routerType;
    
    NSString *url = nil;
    switch (routerType) {
      case RouterFromVCTypeUrl:
      {
        url = (NSString *)routerData;
        self.webType = RouterWebTypeOther;
      }
        break;
      case RouterFromVCTypeHtml:
      {
        NSDictionary *data = (NSDictionary *)routerData;
        NSString *type = data[@"type"];
        url = data[@"url"];
        NSURL *baseUrl = data[@"baseUrl"];
        self.type = type;
        self.webType = RouterWebTypeOther;
        [self loadRequestHtml:url baseURL:baseUrl];
      }
        break;
      case RouterFromVCTypeLoan:
      {
        NSDictionary *data = (NSDictionary *)routerData;
        url = data[@"motionValue"];
        if (url == nil)
        {
          url = data[@"link"];
        }
        self.webType = RouterWebTypeLoan;
      }
        break;
      case RouterFromVCTypeAdvert:
      {
        NSDictionary *data = (NSDictionary *)routerData;
        url = data[@"adUrl"];
        self.webType = RouterWebTypeOther;
        NSString *webtypeStr = @"others";
        if ([url rangeOfString:@"@kongapibyloan"].location != NSNotFound){
          self.webType = RouterWebTypeLoan;
          webtypeStr = @"loan";
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibyloan" withString:@""];
        }else if ([url rangeOfString:@"@kongapibyservice"].location != NSNotFound){
          self.webType = RouterWebTypeService;
          webtypeStr = @"service";
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibyservice" withString:@""];
        }else if ([url rangeOfString:@"@kongapibyactivity"].location != NSNotFound){
          self.webType = RouterWebTypeActivity;
          webtypeStr = @"activity";
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibyactivity" withString:@""];
        }else if ([url rangeOfString:@"@kongapibybaojiedao"].location != NSNotFound){
          self.webType = RouterWebTypeQBD;
          webtypeStr = @"baojiedao";
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibybaojiedao" withString:@""];
        }else if ([url rangeOfString:@"@kongapibyothers"].location != NSNotFound){
          self.webType = RouterWebTypeOther;
          webtypeStr = @"others";
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibyothers" withString:@""];
        }else {
          self.webType = RouterWebTypeOther;
          url = [url stringByReplacingOccurrencesOfString:@"@kongapibyothers" withString:@""];
        }
      }
        break;
      case RouterFromVCTypeQBD:
      {
        self.webType = RouterWebTypeQBD;
      }
        break;
      default:
        break;
    }
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  }
  return self;
}

- (void)loadRequest:(NSURLRequest*)request {
  [self.webView loadRequest:request];
}

-(void)loadRequestHtml:(NSString *)htmlRequest baseURL:(NSURL *)baseUrl{
  [self.webView loadHTMLString:htmlRequest baseURL:baseUrl];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.fd_prefersNavigationBarHidden = YES;
  [self loadRequest:self.request];
  
  //加载bridge
  _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
  [self configJSBridgeActions:self.bridge webView:self.webView];
  
  [self.view addSubview:self.webView];
  [self updateToolbarItems];
  self.webView.backgroundColor = [UIColor whiteColor];
  
  XBSetUserDefaults([NSDate date],@"currentStayDate");
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  NSArray *arr = self.navigationController.childViewControllers;
  if([arr count] >1){
    _isPresent = NO;
  }else {
    _isPresent = YES;
  }
  [self showHeadScroll];
}

- (void)showHeadScroll
{
  //如果是贷款 加载小黄条View
  if (self.webType == RouterWebTypeLoan)
  {
    UIView *view = [[QLMediator sharedInstance] ad_showHeadScrollByLocate:AD_HEADTEXT inVC:self];
    if (view){
      [self.webView setFrame:CGRectMake(0, view.height, ScreenWidth, self.webView.height - view.height)];
    }
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.webView = nil;
  _backBarButtonItem = nil;
  _forwardBarButtonItem = nil;
  _refreshBarButtonItem = nil;
  _stopBarButtonItem = nil;
  _closeBarButtonItem = nil;
  self.type = @"web";
}

- (void)viewWillAppear:(BOOL)animated {
  NSAssert(self.navigationController, @"YVWebViewController needs to be contained in a UINavigationController. If you are presenting YVWebViewController modally, use SVModalWebViewController instead.");
  
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
  //（当我不处于贷款h5列表 或者处于列表不点击item时） 并且有小黄条
  NSDate *currentStayDate = XBGetUserDefaults(@"currentStayDate");
  NSDate *currentClickLoanDate = XBGetUserDefaults(@"currentClickLoanDate");
  if (currentStayDate && self.ishiddenBox == NO){
    //当有计时器A 无小黄条时 说明处于贷款列表页面 不加coin
  }else {
    if (self.hasAddIcon){return;}
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self addCoin:currentClickLoanDate];
    });
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    return YES;
  
  return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)addCoin:(NSDate *)oldDate
{
  double date1 = [oldDate timeIntervalSince1970];
  double date2 = [[NSDate date] timeIntervalSince1970];
  double date = date2 - date1;
  if (date>3)
  {
    [[QLMediator sharedInstance] integral_addCoin:@"product" block:^(NSDictionary *data) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCoinInUserCenter" object:nil];
    }];
  }
}

#pragma mark - Getters

- (UIWebView*)webView {
  if(!_webView) {
    CGFloat bottomheight = ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.navigationController.toolbar.frame.size.height-bottomheight)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
  }
  return _webView;
}

- (UIBarButtonItem *)backBarButtonItem {
  if (!_backBarButtonItem) {
    _backBarButtonItem = [self yv_createBarButtonItemWithIcon:[UIImage imageNamed:@"yv_web_back"] andTarget:self andSelector:@selector(goBackTapped:)];
  }
  return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
  if (!_forwardBarButtonItem) {
    _forwardBarButtonItem = [self yv_createBarButtonItemWithIcon:[UIImage imageNamed:@"yv_web_next"] andTarget:self andSelector:@selector(goForwardTapped:)];
  }
  return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
  if (!_refreshBarButtonItem) {
    _refreshBarButtonItem = [self yv_createBarButtonItemWithIcon:[UIImage imageNamed:@"yv_web_refresh"] andTarget:self andSelector:@selector(reloadTapped:)];
  }
  return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
  if (!_stopBarButtonItem) {
    _stopBarButtonItem = [self yv_createBarButtonItemWithIcon:[UIImage imageNamed:@"yv_web_close"] andTarget:self andSelector:@selector(stopTapped:)];
  }
  return _stopBarButtonItem;
}

- (UIBarButtonItem *)closeBarButtonItem {
  if (!_closeBarButtonItem) {
    _closeBarButtonItem = [self yv_createBarButtonItemWithIcon:[UIImage imageNamed:@"yv_web_close"] andTarget:self andSelector:@selector(closeWindow:)];
  }
  return _closeBarButtonItem;
}

- (UIBarButtonItem *)yv_createBarButtonItemWithIcon:(UIImage *)iconImage andTarget:(id)target andSelector:(SEL)selector
{
  UIImage *image=iconImage;
  UIImage *itemBgImage = nil;
  UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame=CGRectMake(0, 0, 24, 30);
  [btn setBackgroundImage:itemBgImage forState:UIControlStateNormal];
  [btn setImage:image forState:UIControlStateNormal];
  [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
  return backItem;
}
#pragma mark - Toolbar

- (void)updateToolbarItems {
  self.backBarButtonItem.enabled = YES;
  self.forwardBarButtonItem.enabled = YES;
  
  UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
  fixedSpace.width = 16;
  UIBarButtonItem *fixedSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  //    fixedSpace1.width = ScreenWidth - 160;
  NSArray *items = [NSArray arrayWithObjects:
                    fixedSpace,
                    self.closeBarButtonItem,
                    fixedSpace1,
                    self.backBarButtonItem,
                    fixedSpace,
                    self.forwardBarButtonItem,
                    fixedSpace,
                    self.refreshBarButtonItem,
                    fixedSpace,
                    nil];
  
  self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
  self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
  self.toolbarItems = items;
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
  if (![self.type isEqualToString:@"html"]) {
    [self showErrorViewWithState:ControllerStateLoading];
  }
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  [self updateToolbarItems];
  
  if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [self.delegate webViewDidStartLoad:webView];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (![self.type isEqualToString:@"html"]) {
    [self hideErrorView];
  }
  
  [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
   "script.type = 'text/javascript';"
   "script.src = \'http://static.sensorsdata.cn/sdk/test/test.js?2\';"
   "document.getElementsByTagName('head')[0].appendChild(script);"];
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  
  [self updateToolbarItems];
  
  //撞库api
  if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [self.delegate webViewDidFinishLoad:webView];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (![self.type isEqualToString:@"html"]) {
    [self showErrorViewWithState:ControllerStateNoNetWork];
  }
  
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [self updateToolbarItems];
  
  if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [self.delegate webView:webView didFailLoadWithError:error];
  }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"request.URL.absoluteString=== %@",request.URL.absoluteString);
  if (self.webType == RouterWebTypeLoan && self.routerType == RouterFromVCTypeLoan){
  }
  if (self.webType == RouterWebTypeLoan && self.routerType == RouterFromVCTypeAdvert){
  }
  if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
    return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  return YES;
}

- (NSString *)md5Hash:(NSData *)data
{
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5([data bytes], (CC_LONG)[data length], result);
  
  return [NSString stringWithFormat:
          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
          result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
          ];
}

#pragma mark - Target actions

- (void)goBackTapped:(UIBarButtonItem *)sender {
  NSDate *currentStayDate = XBGetUserDefaults(@"currentStayDate");
  if (!currentStayDate){
    self.hasAddIcon = YES;
    [self addCoin:XBGetUserDefaults(@"currentClickLoanDate")];
  }
  [self.webView goBack];
}

- (void)goForwardTapped:(UIBarButtonItem *)sender {
  [self.webView goForward];
}

- (void)reloadTapped:(UIBarButtonItem *)sender {
  [self.webView reload];
}

- (void)stopTapped:(UIBarButtonItem *)sender {
  [self.webView stopLoading];
  [self updateToolbarItems];
}

- (void)closeWindow:(UIBarButtonItem *)sender {
  if (![DZUtility dateIsToday:XBGetUserDefaults(NoWarnLoanCurrentDate)] &&
      self.webType == RouterWebTypeLoan){

      [self.navigationController popViewControllerAnimated:YES];
  }else {
    [self isBack];
  }
}

- (void)doneButtonTapped:(id)sùender {
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)isBack
{
  if (!self.isSplash){
    if(_isPresent){
      [self.navigationController dismissViewControllerAnimated:YES completion:^{
      }];
    }else {
      if (self.webType == RouterWebTypeOther){
        [self.navigationController popToRootViewControllerAnimated:YES];
      }else {
        [self.navigationController popViewControllerAnimated:YES];
      }
    }
  }
  else
  {
    //首页
    [[AppDelegate globalDelegate] switchToRootView];
  }
}

#pragma mark set/get

@end
