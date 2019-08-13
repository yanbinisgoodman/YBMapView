//
//  MapController.m
//  Emergency
//
//  Created by gzx on 2019/8/7.
//  Copyright © 2019 古智性. All rights reserved.
//
//
//
//
//
//
//
//
//
//
//
// 有问题联系qq:476018863

#import "MapController.h"
#import "MapTypeLocationView.h"
#import "POIAnnotation.h"

#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "ErrorInfoUtility.h"


static const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface MapController ()<AMapNaviDriveViewDelegate,MAMapViewDelegate,MapTypeLocationViewDelegate,AMapSearchDelegate,AMapNaviDriveManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MapTypeLocationView *aroundStoreView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) AMapSearchAPI *searchApi;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *selectedStr;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic,retain) NSArray *pathPolylines;
@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic) MANaviRoute * naviRoute; //路线  直接添加在mapview上的路线
@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;

@property (nonatomic, strong) AMapNaviDriveView * driveView; //导航的wview

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.navigationItem.title = @"救援鸡";
    
    _currentLocation = [[CLLocation alloc] init];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.zoomLevel = 18;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:self.mapView];

    [self.view addSubview:self.aroundStoreView];
    
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
   
}

//两个初始化 导航view 和 导航管理类
- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] init];
        self.driveView.frame = self.view.bounds;
        self.driveView.delegate = self;
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
}
- (void)initDriveManager
{
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"turn"];
        self.userLocationAnnotationView = annotationView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView selectAnnotation:annotation animated:NO];
        });
        return annotationView;
    }
    else if ([annotation isKindOfClass:[POIAnnotation class]]){
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        if ([self.selectedStr isEqualToString:@"修理厂"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-fix"];
        }
        else if ([self.selectedStr isEqualToString:@"加油站"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-refuel"];
        }
        else if ([self.selectedStr isEqualToString:@"充电桩"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-charging"];
        }
        else if ([self.selectedStr isEqualToString:@"厕所"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-wc"];
        }
        else if ([self.selectedStr isEqualToString:@"停车场"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-parking"];
        }
        else if ([self.selectedStr isEqualToString:@"酒店"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-hotel"];
        }
        else if ([self.selectedStr isEqualToString:@"医院"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-hospital"];
        }
        else if ([self.selectedStr isEqualToString:@"服务区"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"home-area"];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        // 点击大头针显示的右边视图
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        rightButton.backgroundColor = [UIColor blueColor];
        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
        poiAnnotationView.rightCalloutAccessoryView = rightButton;
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //点击导航的时候初始化
    [self initDriveView];
    [self initDriveManager];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //规划成功的回调 ,开始导航
    [self.view addSubview:self.driveView];
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

//关闭的时候移除销毁
-(void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    [driveView removeFromSuperview];
}

#pragma mark --选中某个大头针后回调的方法 选择的时候直接规划路径
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    NSLog(@"%lf------%lf",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);

    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude
                                           longitude:_currentLocation.coordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:view.annotation.coordinate.latitude
                                                longitude:view.annotation.coordinate.longitude];
    
    self.startAnnotation.coordinate = _currentLocation.coordinate;
    self.destinationAnnotation.coordinate = view.annotation.coordinate;
    [self.naviRoute removeFromMapView];
    [self.searchApi AMapDrivingRouteSearch:navi];
    
    //这个两个点的赋值 用来导航的
    self.startPoint = [AMapNaviPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    self.endPoint = [AMapNaviPoint locationWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeNormal];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview)
    {
        [self.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];
    }
}
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}


/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route != nil)
    {
        
        MANaviAnnotationType type = MANaviAnnotationTypeTruck;

        self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
        [self.naviRoute addToMapView:self.mapView];

        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude) animated:YES];
       
    }
    
}

//绘制遮盖时执行的代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = QL_UIColorFromHEX(0xFF6852);
        polygonView.fillColor = QL_UIColorFromHEX(0xFF6852);
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    
    return nil;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    _currentLocation = [userLocation.location copy];
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSLog(@"------%@",response);
    if (response.pois.count == 0)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    [self.mapView showAnnotations:poiAnnotations animated:YES];
}

#pragma mark - action
- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [UIView animateWithDuration:.5 animations:^{
            self.aroundStoreView.frame = CGRectMake(0, ScreenHeight - 150 - kAN_TopLaytout_Height, ScreenWidth, 150);
        }];
    }else{
        [UIView animateWithDuration:.5 animations:^{
            self.aroundStoreView.frame = CGRectMake(0, ScreenHeight - 300 - kAN_TopLaytout_Height, ScreenWidth, 300);
        }];
    }
}

- (void)aroundStoreBtnClick:(UIButton *)sender
{
    self.selectedStr = sender.titleLabel.text;
    
    //初始
    self.searchApi = [[AMapSearchAPI alloc] init];
    self.searchApi.delegate = self;
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = sender.titleLabel.text;
    request.location            = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.searchApi AMapPOIKeywordsSearch:request];
}

#pragma mark - setter & getter
- (MapTypeLocationView *)aroundStoreView
{
    if (!_aroundStoreView) {
        _aroundStoreView = [[MapTypeLocationView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 150 - kAN_TopLaytout_Height, ScreenWidth, 150)];
        _aroundStoreView.delegate = self;
    }
    
    return _aroundStoreView;
}

- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}


- (void)dealloc
{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
    
}
@end
