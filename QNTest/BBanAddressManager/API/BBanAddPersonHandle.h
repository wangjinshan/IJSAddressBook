//
//  BBanAddPersonHandle.h
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
/**
 创建联系人时候代理回调的处理类
 */
@interface BBanAddPersonHandle : NSObject <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, weak) UIViewController *controller;



@end
