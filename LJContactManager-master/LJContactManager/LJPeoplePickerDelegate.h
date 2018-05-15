//
//  LJPeoplePickerDelegate.h
//  LJContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

/**
 添加联系人的一些代理方法
 */
@interface LJPeoplePickerDelegate : NSObject <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, weak) UIViewController *controller;

@end
