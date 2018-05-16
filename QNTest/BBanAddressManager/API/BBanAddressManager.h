//
//  BBanAddressManager.h
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBanAddressPerson.h"

@class BBanSectionPerson;

/**
 系统通讯录管理类
 */
@interface BBanAddressManager : NSObject

+ (instancetype)sharedInstance;

/**
 通讯录变更回调
 */
@property(nonatomic,copy) void(^contactChangeHandler)(void);

/**
 请求授权
 
 @param completion 回调 authorization 只有1 才是已经授权
 */
- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion;

/**
 选择联系人, 如果设置 isPhoneShow = NO, 则此代理无效,使用("selectedContactAtController: complection:(void (^)(LJPerson *person))completcion")
 
 @param controller 控制器
 @param completcion 回调
 */
- (void)selectContactAtController:(UIViewController *)controller complection:(void (^)(NSString *name, NSString *phone))completcion;

/**
 获取联系人,详细的信息
 
 @param controller 当前的控制器
 @param completcion 回调的数据,用户详细的信息
 */
- (void)selectedContactAtController:(UIViewController *)controller complection:(void (^)(BBanAddressPerson *person))completcion;

/**
 创建新联系人
 
 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 添加到现有联系人
 
 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 获取联系人列表（未分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <BBanAddressPerson *> *contacts))completcion;

/**
 获取联系人列表（已分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <BBanSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;

@property(nonatomic,assign) BOOL isPhoneShow;  //只显示电话




@end
