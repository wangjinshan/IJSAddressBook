//
//  BBanSelectedPersonHandle.h
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
@class BBanAddressPerson;

/**
 选择系统联系人时候代理的回调方法
 */
@interface BBanSelectedPersonHandle : NSObject<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *name, NSString *phoneNum);
@property(nonatomic,copy) void (^handleBlock)(BBanAddressPerson *person);  // 用户的所有详细信息






@end
