
//
//  BBanAddressManager.m
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import "BBanAddressManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


#import "BBanSelectedPersonHandle.h"
#import "BBanAddPersonHandle.h"


#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface BBanAddressManager()<ABNewPersonViewControllerDelegate, CNContactViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) void (^handler) (NSString *name, NSString *phone);
@property(nonatomic,copy) void (^handlerBlock)(BBanAddressPerson *people);  // 回调的block

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, strong) BBanAddPersonHandle *pickerDelegate;
@property (nonatomic, strong) BBanSelectedPersonHandle *pickerDetailDelegate;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, strong) CNContactStore *contactStore;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation BBanAddressManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("com.addressBook.queue", DISPATCH_QUEUE_SERIAL);
        
        if (IOS9_OR_LATER)
        {
            _contactStore = [CNContactStore new];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_contactStoreDidChange)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        }
        else
        {
            _addressBook = ABAddressBookCreate();  // ios8  创建通讯录对象
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        }
        self.isPhoneShow = YES;  // 只是显示手机号
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

#pragma mark - 公有方法
#pragma mark -  选择联系人
//  只获取手机号 和名字
- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *, NSString *))completcion
{
    self.isAdd = NO;
    [self _presentFromController:controller];
    
    self.handler = completcion;
}
// 获取联系人详细的信息
- (void)selectedContactAtController:(UIViewController *)controller complection:(void (^)(BBanAddressPerson *person))completcion;
{
    self.isAdd = NO;
    [self _presentFromController:controller];
    self.handlerBlock = completcion;
}

#pragma mark -  创建联系人
- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                     value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
        contact.phoneNumbers = @[labelValue];
        CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
        contactController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
        [controller presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        ABRecordRef newPerson = ABPersonCreate(); // 创建一个新的联系人
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        CFErrorRef error = NULL;
        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error); // 函数设置联系人的属性
        CFRelease(multiValue);
        picker.displayedPerson = newPerson;
        CFRelease(newPerson);
        picker.newPersonViewDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [controller presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    self.isAdd = YES;
    self.pickerDelegate.phoneNum = phoneNum;
    self.pickerDelegate.controller = controller;
    
    [self _presentFromController:controller];
}
#pragma mark -  获取未分组的联系人
- (void)accessContactsComplection:(void (^)(BOOL, NSArray<BBanAddressPerson *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil);
            }
        }
    }];
}
#pragma mark -  获取分组的联系人
- (void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<BBanSectionPerson *> *, NSArray<NSString *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil, nil);
            }
        }
    }];
}

#pragma mark - ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
{
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -  请求授权
- (void)requestAddressBookAuthorization:(void (^)(BOOL authorization))completion
{
    if (IOS9_OR_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, status == CNAuthorizationStatusAuthorized);
        }
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)  // 获取授权状态 -- 没有决定
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - 私有方法
// 获取权限
- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    if (IOS9_OR_LATER)
    {
        [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion)
            {
                completion(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) { // 请求访问通讯录
            if (completion)
            {
                completion(granted);
            }
        });
    }
}

void _blockExecute(void (^completion)(BOOL authorizationA), BOOL authorizationB)
{
    if (completion)
    {
        if ([NSThread isMainThread])
        {
            completion(authorizationB);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(authorizationB);
            });
        }
    }
}

- (void)_presentFromController:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNContactPickerViewController *pc = [[CNContactPickerViewController alloc] init]; // 1.创建选择联系人的控制器
        if (self.isAdd) //添加联系人
        {
            pc.delegate = self.pickerDelegate;
        }
        else
        {                // 选择联系人
            pc.delegate = self.pickerDetailDelegate;
        }
        if (self.isPhoneShow)
        {
            pc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];   //选择要显示的数据
        }
        
        [self requestAddressBookAuthorization:^(BOOL authorization) {
            if (authorization)
            {
                [controller presentViewController:pc animated:YES completion:nil];
            }
            else
            {
                [self _showAlert];
            }
        }];
    }
    else
    { // 创建联系人选择控制器
        ABPeoplePickerNavigationController *pvc = [[ABPeoplePickerNavigationController alloc] init];
        if (self.isPhoneShow)
        {
            pvc.displayedProperties = @[@(kABPersonPhoneProperty)]; //显示的联系人属性信息,默认显示所有信息
        }
        
        if (self.isAdd)
        {
            pvc.peoplePickerDelegate = self.pickerDelegate;  // 设置代理(用来接收用户选择的联系人信息)
        }
        else
        {
            pvc.peoplePickerDelegate = self.pickerDetailDelegate;
        }
        
        [self requestAddressBookAuthorization:^(BOOL authorization) {
            
            if (authorization)
            {
                [controller presentViewController:pvc animated:YES completion:nil];
            }
            else
            {
                [self _showAlert];
            }
            
        }];
    }
}

- (void)_showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有获取访问通讯录权限，请去设置->奇乐直播->通讯录 授权!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去打开", nil];
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
//  ios 8
- (void)_asynAccessAddressBookWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableArray *datas = [NSMutableArray array];
    
    dispatch_async(_queue, ^{
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        CFIndex count = CFArrayGetCount(allPeople);
        
        for (int i = 0; i < count; i++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
            BBanAddressPerson *personModel = [[BBanAddressPerson alloc] initWithRecord:record];
            [datas addObject:personModel];
        }
        
        CFRelease(allPeople);
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}
/// ios 9 获取所有的联系人
- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    dispatch_async(_queue, ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        [_contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            BBanAddressPerson *person = [[BBanAddressPerson alloc] initWithCNContact:contact];
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}
/// 对数据排序
- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (BBanAddressPerson *person in datas)  // 分组
    {
        NSString *firstLetter = [self _firstCharacterWithString:person.fullName];
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            [dict setValue:arr forKey:firstLetter];
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BBanSectionPerson *person = [BBanSectionPerson new];
        person.key = key;
        person.persons = dict[key];
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}
/// 获取首字母
- (NSString *)_firstCharacterWithString:(NSString *)string
{
    if (string.length == 0)
    {
        return @"#";
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str isEqualToString:@"长"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str isEqualToString:@"沈"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str isEqualToString:@"厦"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str isEqualToString:@"地"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([str isEqualToString:@"重"])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
    
    NSString *regex = @"^[A-Z]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *firstCharacter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
    
    return firstCharacter;
}

void _addressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    if ([BBanAddressManager sharedInstance].contactChangeHandler)
    {
        [BBanAddressManager sharedInstance].contactChangeHandler();
    }
}

- (void)_contactStoreDidChange
{
    if ([BBanAddressManager sharedInstance].contactChangeHandler)
    {
        [BBanAddressManager sharedInstance].contactChangeHandler();
    }
}
#pragma mark -  set
-(void)setIsPhoneShow:(BOOL)isPhoneShow
{
    _isPhoneShow = isPhoneShow;
}
#pragma mark -  懒加载以及数据初始化
- (NSArray *)keys
{
    if (!_keys)
    {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactNoteKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];
        
    }
    return _keys;
}

- (BBanAddPersonHandle *)pickerDelegate
{
    if (!_pickerDelegate)
    {
        _pickerDelegate = [BBanAddPersonHandle new];
    }
    return _pickerDelegate;
}
// 用户详细的信息
- (BBanSelectedPersonHandle *)pickerDetailDelegate
{
    if (!_pickerDetailDelegate)
    {
        _pickerDetailDelegate = [BBanSelectedPersonHandle new];
        __weak typeof(self) weakSelf = self;
        _pickerDetailDelegate.handler = ^(NSString *name, NSString *phoneNum) {
            if (weakSelf.handler)
            {
                weakSelf.handler(name, phoneNum);
            }
        };
        _pickerDetailDelegate.handleBlock = ^(BBanAddressPerson *person) {
            if (weakSelf.handlerBlock)
            {
                weakSelf.handlerBlock(person);
            }
        };
    }
    return _pickerDetailDelegate;
}

- (void)dealloc
{
    if (IOS9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    }
    else
    {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, _addressBookChange, nil);
        if (_addressBook)
        {
            CFRelease(_addressBook);
            _addressBook = NULL;
        }
    }
}


@end
