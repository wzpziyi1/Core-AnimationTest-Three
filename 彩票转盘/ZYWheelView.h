//
//  ZYWheelView.h
//  彩票转盘
//
//  Created by 王志盼 on 16/2/15.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYWheelView : UIView
+ (instancetype)wheelView;

- (void)startRotating;

- (void)stopRotating;

@end
