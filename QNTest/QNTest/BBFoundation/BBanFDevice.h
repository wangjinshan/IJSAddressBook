//
//  BBanFDevice.h
//  QNTest
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 山神. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBanFDevice : NSObject
/**
 *  与当前系统版本比较
 *
 *  @param other 需要对比的版本
 *
 *  @return < 0 低于指定版本； = 0 跟指定版本相同；> 0 高于指定版本
 */
+ (NSInteger)versionCompare:(NSString *)other;



@end
