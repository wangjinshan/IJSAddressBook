//
//  LJPickerDetailDelegate.m
//  Demo
//
//  Created by LeeJay on 2017/4/24.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "LJPickerDetailDelegate.h"
#import "LJPerson.h"

@implementation LJPickerDetailDelegate 
///  ios 8 ---
#pragma mark - ABPeoplePickerNavigationControllerDelegate
// 当用户选中某一个联系人时会执行该方法,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSString *name = CFBridgingRelease(ABRecordCopyCompositeName(person));
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phones, identifier);
    NSString *phone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
    CFRelease(phones);
    
    if (self.handler)
    {
        self.handler(name, phone);
    }
    if (self.handleBlock)
    {
        LJPerson *userInfo = [[LJPerson alloc]initWithRecord:person];
        self.handleBlock(userInfo);
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate
///  ios 9 ---
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact = contactProperty.contact;
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    CNPhoneNumber *phoneValue= contactProperty.value;
    NSString *phoneNumber = phoneValue.stringValue;
    
    if (self.handler)
    {
        self.handler(name, phoneNumber);
    }
    if (self.handleBlock)
    {
        LJPerson *userInfo = [[LJPerson alloc]initWithCNContact:contact];
        self.handleBlock(userInfo);
    }
}

@end
