
//
//  BBanSelectedPersonHandle.m
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import "BBanSelectedPersonHandle.h"

#import "BBanAddressPerson.h"
#import "BBanAddressManager.h"

@implementation BBanSelectedPersonHandle

#pragma mark - ABPeoplePickerNavigationControllerDelegate
//  ios 8 --- 当用户选中某一个联系人时会执行该方法,选择详情,并且选中联系人后会直接退出控制器
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if ([BBanAddressManager sharedInstance].isPhoneShow)
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
    }
    
    if (self.handleBlock)
    {
        BBanAddressPerson *userInfo = [[BBanAddressPerson alloc]initWithRecord:person];
        self.handleBlock(userInfo);
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
// 不展开详情的时候调用
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
//{
//    if (self.handleBlock)
//    {
//        BBanAddressPerson *userInfo = [[BBanAddressPerson alloc]initWithRecord:person];
//        self.handleBlock(userInfo);
//    }
//     [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//}

/*
 以下的方法如果同时实现只会走不展开详情的方法, ios 8 同理
 */
#pragma mark - CNContactPickerDelegate
///  ios 9 --- 选择联系人的回调
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact = contactProperty.contact;
    if ([BBanAddressManager sharedInstance].isPhoneShow)
    {
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        CNPhoneNumber *phoneValue= contactProperty.value;
        NSString *phoneNumber = phoneValue.stringValue;
        
        if (self.handler)
        {
            self.handler(name, phoneNumber);
        }
    }
    if (self.handleBlock)
    {
        BBanAddressPerson *userInfo = [[BBanAddressPerson alloc]initWithCNContact:contact];
        self.handleBlock(userInfo);
    }
}
// ios 9 不展开详情的时候调用
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
//{
//    if (self.handleBlock)
//    {
//        BBanAddressPerson *userInfo = [[BBanAddressPerson alloc]initWithCNContact:contact];
//        self.handleBlock(userInfo);
//    }
//}




@end
