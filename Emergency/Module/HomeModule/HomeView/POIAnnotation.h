//
//  POIAnnotation.h
//  Emergency
//
//  Created by gzx on 2019/8/12.
//  Copyright © 2019 古智性. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface POIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, readonly, strong) AMapPOI *poi;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;
@end

NS_ASSUME_NONNULL_END
