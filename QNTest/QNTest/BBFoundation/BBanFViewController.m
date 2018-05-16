//
//  BBanFViewController.m
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import "BBanFViewController.h"
#import "BBanFDevice.h"

@implementation BBanFViewController

+ (UIViewController *)currentViewController
{
    return [self currentViewControllerWithViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)currentViewControllerFromWindow:(UIWindow *)window
{
    if (![window isKindOfClass:[UIWindow class]])
    {
        return nil;
    }
    return [self currentViewControllerWithViewController:window.rootViewController];
}

#pragma mark - Private


+ (UIViewController *)currentViewControllerWithViewController:(UIViewController *)controller
{
    //如果改ModalViewController不是PopoverController的内容视图则继续递归
    if (controller.presentedViewController)
    {
        if ([BBanFDevice versionCompare:@"8.0"] != NSOrderedAscending)
        {
            if ([controller.presentedViewController respondsToSelector:@selector(popoverPresentationController)] &&
                ![controller.presentedViewController performSelector:@selector(popoverPresentationController) withObject:nil])
            {
                return [self currentViewControllerWithViewController:controller.presentedViewController];
            }
            else if ([controller isKindOfClass:[UINavigationController class]])
            {
                return [self currentViewControllerWithViewController:[((UINavigationController *)controller).viewControllers lastObject]];
            }
            else if ([controller isKindOfClass:[UITabBarController class]]
                     && ((UITabBarController *)controller).selectedViewController)
            {
                return [self currentViewControllerWithViewController:((UITabBarController *)controller).selectedViewController];
            }
        }
        else
        {
            return [self currentViewControllerWithViewController:controller.presentedViewController];
        }
    }
    else if ([controller isKindOfClass:[UINavigationController class]])
    {
        return [self currentViewControllerWithViewController:[((UINavigationController *)controller).viewControllers lastObject]];
    }
    else if ([controller isKindOfClass:[UITabBarController class]]
             && ((UITabBarController *)controller).selectedViewController)
    {
        return [self currentViewControllerWithViewController:((UITabBarController *)controller).selectedViewController];
    }
    
    return controller;
}












@end
