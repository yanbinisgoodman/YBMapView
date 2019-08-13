//
//  MABusStopAnnotation.h
//  MAMapKit_3D_Demo
//
//  Created by zuola on 2019/5/7.
//  Copyright © 2019 Autonavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MABusStopAnnotation : MAPointAnnotation
@property (nonatomic, copy) NSString *busName;
@property (nonatomic, copy) NSString *stopName;

@end

NS_ASSUME_NONNULL_END
