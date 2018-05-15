//
//  LJPickerDetailDelegate.h
//  Demo
//
//  Created by LeeJay on 2017/4/24.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
@class LJPerson;
/**
 选择通讯录对应的联系人时候调用
 */
@interface LJPickerDetailDelegate : NSObject <ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *name, NSString *phoneNum);
@property(nonatomic,copy) void (^handleBlock)(LJPerson *person);  // 用户的所有详细信息





@end
