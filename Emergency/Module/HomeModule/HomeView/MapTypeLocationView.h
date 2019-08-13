//
//  MapTypeLocationView.h
//  Emergency
//
//  Created by gzx on 2019/8/7.
//  Copyright © 2019 古智性. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MapTypeLocationViewDelegate <NSObject>
- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer;
- (void)aroundStoreBtnClick:(UIButton *)sender;
@end

@interface MapTypeLocationView : UIView

@property (nonatomic, weak) id<MapTypeLocationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
