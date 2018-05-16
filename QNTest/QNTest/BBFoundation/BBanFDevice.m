//
//  BBanFDevice.m
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import "BBanFDevice.h"
//获得设备型号
#include <sys/types.h>
#include <sys/sysctl.h>
//获取手机的mac地址
//#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation BBanFDevice

/// 与当前版本号相比
+ (NSInteger)versionCompare:(NSString *)other
{
    UIDevice *device = [[UIDevice alloc] init];
    NSString *systemVersion = device.systemVersion; //获取当前系统的版本
    if ([other compare:systemVersion] == NSOrderedAscending)
    {
        return NSOrderedAscending;
    }
    if ([other compare:systemVersion] == NSOrderedSame)
    {
        return NSOrderedSame;
    }
    if ([other compare:systemVersion] == NSOrderedDescending)
    {
        return NSOrderedDescending;
    }
    return 0;
}




@end
