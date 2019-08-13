//
//  CommonUtility.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CommonUtility.h"
//#import "LineDashPolyline.h"

@implementation CommonUtility

+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString
{
    if (coordinateString.length == 0)
    {
        return nil;
    }
    
    NSUInteger count = 0;
    
    CLLocationCoordinate2D *coordinates = [self coordinatesForString:coordinateString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    
    free(coordinates), coordinates = NULL;
    
    return polyline;
}

+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine
{
    if (busLine == nil)
    {
        return nil;
    }
    
    return [self polylineForCoordinateString:busLine.polyline];
}

+ (MAMapRect)unionMapRect1:(MAMapRect)mapRect1 mapRect2:(MAMapRect)mapRect2
{
    CGRect rect1 = CGRectMake(mapRect1.origin.x, mapRect1.origin.y, mapRect1.size.width, mapRect1.size.height);
    CGRect rect2 = CGRectMake(mapRect2.origin.x, mapRect2.origin.y, mapRect2.size.width, mapRect2.size.height);
    
    CGRect unionRect = CGRectUnion(rect1, rect2);
    
    return MAMapRectMake(unionRect.origin.x, unionRect.origin.y, unionRect.size.width, unionRect.size.height);
}

+ (MAMapRect)mapRectUnion:(MAMapRect *)mapRects count:(NSUInteger)count
{
    if (mapRects == NULL || count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapRect unionMapRect = mapRects[0];
    
    for (int i = 1; i < count; i++)
    {
        unionMapRect = [self unionMapRect1:unionMapRect mapRect2:mapRects[i]];
    }
    
    return unionMapRect;
}

+ (MAMapRect)mapRectForOverlays:(NSArray *)overlays
{
    if (overlays.count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapRect mapRect;
    
    MAMapRect *buffer = (MAMapRect*)malloc(overlays.count * sizeof(MAMapRect));
    
    [overlays enumerateObjectsUsingBlock:^(id<MAOverlay> obj, NSUInteger idx, BOOL *stop) {
        buffer[idx] = [obj boundingMapRect];
    }];
    
    mapRect = [self mapRectUnion:buffer count:overlays.count];
    
    free(buffer), buffer = NULL;
    
    return mapRect;
}

+ (MAMapRect)minMapRectForMapPoints:(MAMapPoint *)mapPoints count:(NSUInteger)count
{
    if (mapPoints == NULL || count <= 1)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    CGFloat minX = mapPoints[0].x, minY = mapPoints[0].y;
    CGFloat maxX = minX, maxY = minY;
    
    /* Traverse and find the min, max. */
    for (int i = 1; i < count; i++)
    {
        MAMapPoint point = mapPoints[i];
        
        if (point.x < minX)
        {
            minX = point.x;
        }
        
        if (point.x > maxX)
        {
            maxX = point.x;
        }
        
        if (point.y < minY)
        {
            minY = point.y;
        }
        
        if (point.y > maxY)
        {
            maxY = point.y;
        }
    }
    
    /* Construct outside min rectangle. */
    return MAMapRectMake(minX, minY, fabs(maxX - minX), fabs(maxY - minY));
}

+ (MAMapRect)minMapRectForAnnotations:(NSArray *)annotations
{
    if (annotations.count <= 1)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapPoint *mapPoints = (MAMapPoint*)malloc(annotations.count * sizeof(MAMapPoint));
    
    [annotations enumerateObjectsUsingBlock:^(id<MAAnnotation> obj, NSUInteger idx, BOOL *stop) {
        mapPoints[idx] = MAMapPointForCoordinate([obj coordinate]);
    }];
    
    MAMapRect minMapRect = [self minMapRectForMapPoints:mapPoints count:annotations.count];
    
    free(mapPoints), mapPoints = NULL;
    
    return minMapRect;
}

+ (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

+ (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}

+ (double)distanceToPoint:(MAMapPoint)p fromLineSegmentBetween:(MAMapPoint)l1 and:(MAMapPoint)l2
{
    double A = p.x - l1.x;
    double B = p.y - l1.y;
    double C = l2.x - l1.x;
    double D = l2.y - l1.y;
    
    double dot = A * C + B * D;
    double len_sq = C * C + D * D;
    double param = dot / len_sq;
    
    double xx, yy;
    
    if (param < 0 || (l1.x == l2.x && l1.y == l2.y)) {
        xx = l1.x;
        yy = l1.y;
    }
    else if (param > 1) {
        xx = l2.x;
        yy = l2.y;
    }
    else {
        xx = l1.x + param * C;
        yy = l1.y + param * D;
    }
    
    return MAMetersBetweenMapPoints(p, MAMapPointMake(xx, yy));
}
    
+ (CLLocationCoordinate2D)fetchPointPolylinePoints:(NSArray<MAPolyline *> *)polys mapView:(MAMapView*)mapView index:(NSInteger)index selected:(NSInteger)slect
{
    MAPolyline *poly = [polys objectAtIndex:index];
    MAMapPoint *polylinePoints = poly.points;
    NSInteger currentcount = poly.pointCount;
    NSInteger kCount = 0;
    static NSInteger totalColt = 4;
    CLLocationCoordinate2D kcoord = kCLLocationCoordinate2DInvalid;
    for (NSInteger i = currentcount-1; i >= 0; i -=5) {
        MAMapPoint point = polylinePoints[i];
        CLLocationCoordinate2D coord = MACoordinateForMapPoint(point);
        BOOL isInside = YES;
        
        if (index == 0 ) {             //这个地方有个逻辑是，点选poly时，有重复路线的polyline时，优先数组中排第0位的poly响应，所以这些重复点是可以返给0位的poly
            MAPolyline *kpoly = [polys objectAtIndex:slect];
            MAMapPoint *kpolylinePts = kpoly.points;
            NSInteger kcount = kpoly.pointCount;
            isInside = [self polylineHitTestWithCoordinate:coord mapView:mapView polylinePoints:kpolylinePts pointCount:kcount lineWidth:60];
        }else{
            for (NSInteger j = 0; j < polys.count; j ++) {
                if (j != index) {
                    MAPolyline *kpoly = [polys objectAtIndex:j];
                    MAMapPoint *kpolylinePts = kpoly.points;
                    NSInteger kcount = kpoly.pointCount;
                    isInside = [self polylineHitTestWithCoordinate:coord mapView:mapView polylinePoints:kpolylinePts pointCount:kcount lineWidth:60];
                    if (isInside) {
                        break;
                    }
                }
            }
        }
        
        if (!isInside) {
            kcoord = coord;
            kCount ++;
            if (kCount >= totalColt) {
                break;
            }
        }
    }
    return kcoord;
}
    
//点击地图时，判断是否点击在polyline线上
+ (BOOL)polylineHitTestWithCoordinate:(CLLocationCoordinate2D)coordinate
                              mapView:(MAMapView*)mapView
                       polylinePoints:(MAMapPoint*)polylinePoints
                           pointCount:(NSInteger)pointCount
                            lineWidth:(CGFloat)lineWidth {
    if(pointCount <= 1 || polylinePoints == NULL || !mapView) {
        return NO;
    }
    
    CGPoint cgp1 = [mapView convertCoordinate:coordinate toPointToView:mapView];
    CGPoint cgp2 = CGPointMake(cgp1.x + lineWidth * 0.5, cgp1.y);
    MAMapPoint tappedMapPoint = MAMapPointForCoordinate(coordinate);
    MAMapPoint mapPoint2 = MAMapPointForCoordinate([mapView convertPoint:cgp2 toCoordinateFromView:mapView]);
    CGFloat lengthSq = (tappedMapPoint.x - mapPoint2.x)*(tappedMapPoint.x - mapPoint2.x) + (tappedMapPoint.y - mapPoint2.y)*(tappedMapPoint.y - mapPoint2.y);
    
    
    BOOL hit = NO;
    for(int i = 0; i < pointCount - 1; ++i) {
        MAMapPoint begin = polylinePoints[i];
        MAMapPoint end = polylinePoints[i+1];
        
        CGFloat length2BeginSq = (tappedMapPoint.x - begin.x)*(tappedMapPoint.x - begin.x) + (tappedMapPoint.y - begin.y)*(tappedMapPoint.y - begin.y);
        if(length2BeginSq < lengthSq) {
            hit = YES;
            break;
        }
        
        CGFloat length2EndSq = (tappedMapPoint.x - end.x)*(tappedMapPoint.x - end.x) + (tappedMapPoint.y - end.y)*(tappedMapPoint.y - end.y);
        if(length2EndSq < lengthSq) {
            hit = YES;
            break;
        }
        
        MAMapPoint mappedPoint = [self getVerticalMappedPointOfPoint:tappedMapPoint toLineWithBegin:begin andEnd:end];
        CGFloat length2MappedPointSq = (tappedMapPoint.x - mappedPoint.x)*(tappedMapPoint.x - mappedPoint.x) + (tappedMapPoint.y - mappedPoint.y)*(tappedMapPoint.y - mappedPoint.y);
        if(length2MappedPointSq < lengthSq &&
           mappedPoint.y <= fmax(begin.y, end.y) && mappedPoint.y >= fmin(begin.y, end.y) &&
           mappedPoint.x <= fmax(begin.x, end.x) && mappedPoint.x >= fmin(begin.x, end.x)) {
            hit = YES;
            break;
        }
    }
    
    return hit;
}
    
+ (MAMapPoint)getVerticalMappedPointOfPoint:(MAMapPoint)pt toLineWithBegin:(MAMapPoint)begin andEnd:(MAMapPoint)end {
    MAMapPoint retVal;
    
    double dx = begin.x - end.x;
    double dy = begin.y - end.y;
    if(fabs(dx) < 0.00000001 && fabs(dy) < 0.00000001 ) {
        retVal = begin;
        return retVal;
    }
    
    double u = (pt.x - begin.x)*(begin.x - end.x) +
    (pt.y - begin.y)*(begin.y - end.y);
    u = u/((dx*dx)+(dy*dy));
    
    retVal.x = begin.x + u*dx;
    retVal.y = begin.y + u*dy;
    
    return retVal;
}
    
+ (long )getNowTimeTimestamp{
    NSDate *datenow = [NSDate date];
    return [datenow timeIntervalSince1970];
}

+ (NSString *)getForeverTime:(long)timeInter{
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"hh:mm"];
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:timeInter];
    NSString* dateString = [_dateFormatter stringFromDate:stampDate];
    return dateString;
}
    
@end
