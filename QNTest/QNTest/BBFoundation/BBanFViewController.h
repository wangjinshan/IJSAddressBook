//
//  BBanFViewController.h
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 控制器类
 */
@interface BBanFViewController : NSObject

/**
 *  获取当前视图控制器
 *
 *  @return 视图控制器
 */
+ (UIViewController *)currentViewController;

/**
 *  获取当前视图控制器
 *
 *  @param window 窗口
 *
 *  @return 视图控制器
 */
+ (UIViewController *)currentViewControllerFromWindow:(UIWindow *)window;



@end
