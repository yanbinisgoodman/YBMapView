//
//  CustomMAMultiPolyline.h
//  MAMapKit_3D_Demo
//
//  Created by zuola on 2019/5/7.
//  Copyright © 2019 Autonavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomMAMultiPolyline : MAMultiPolyline
    
@property(nonatomic , copy)NSArray *mutablePolylineColors;
@property(nonatomic , copy)NSArray *mutablePolylineTextures;
@property(nonatomic , copy)NSArray *mutablePolylineTexturesSelect;

@end

NS_ASSUME_NONNULL_END
