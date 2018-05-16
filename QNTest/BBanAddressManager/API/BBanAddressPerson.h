//
//  BBanAddressPerson.h
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@class BBanPhone, BBanEmail, BBanAddress, BBanBirthday, BBanMessage, BBanSocialProfile, BBanContactRelation, BBanUrlAddress;

typedef NS_ENUM(NSUInteger, BBanContactType)
{
    BBanContactTypePerson = 0,
    BBanContactTypeOrigination,
};

/**
 通讯录对象类,封装了系统的通讯录的对象
 */
#pragma mark -  用户信息类
@interface BBanAddressPerson : NSObject

/**
 联系人类型
 */
@property (nonatomic) BBanContactType contactType;

/**
 姓名
 */
@property (nonatomic, copy) NSString *fullName;

/**
 姓
 */
@property (nonatomic, copy) NSString *familyName;

/**
 名
 */
@property (nonatomic, copy) NSString *givenName;

/**
 姓名前缀
 */
@property (nonatomic, copy) NSString *namePrefix;

/**
 姓名后缀
 */
@property (nonatomic, copy) NSString *nameSuffix;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 中间名
 */
@property (nonatomic, copy) NSString *middleName;

/**
 公司
 */
@property (nonatomic, copy) NSString *organizationName;

/**
 部门
 */
@property (nonatomic, copy) NSString *departmentName;

/**
 职位
 */
@property (nonatomic, copy) NSString *jobTitle;

/**
 备注
 */
@property (nonatomic, copy) NSString *note;

/**
 名的拼音或音标
 */
@property (nonatomic, copy) NSString *phoneticGivenName;

/**
 中间名的拼音或音标
 */
@property (nonatomic, copy) NSString *phoneticMiddleName;

/**
 姓的拼音或音标
 */
@property (nonatomic, copy) NSString *phoneticFamilyName;

/**
 头像 Data
 */
@property (nonatomic, copy) NSData *imageData;

/**
 头像图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 头像的缩略图 Data
 */
@property (nonatomic, copy) NSData *thumbnailImageData;

/**
 头像缩略图片
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/**
 获取创建当前联系人的时间
 */
@property (nonatomic, strong) NSDate *creationDate;

/**
 获取最近一次修改当前联系人的时间
 */
@property (nonatomic, strong) NSDate *modificationDate;

/**
 电话号码数组
 */
@property (nonatomic, copy) NSArray <BBanPhone *> *phones;

/**
 邮箱数组
 */
@property (nonatomic, copy) NSArray <BBanEmail *> *emails;

/**
 地址数组
 */
@property (nonatomic, copy) NSArray <BBanAddress *> *addresses;

/**
 生日对象
 */
@property (nonatomic, strong) BBanBirthday *birthday;

/**
 即时通讯数组
 */
@property (nonatomic, copy) NSArray <BBanMessage *> *messages;

/**
 社交数组
 */
@property (nonatomic, copy) NSArray <BBanSocialProfile *> *socials;

/**
 关联人数组
 */
@property (nonatomic, copy) NSArray <BBanContactRelation *> *relations;

/**
 url数组
 */
@property (nonatomic, copy) NSArray <BBanUrlAddress *> *urls;

/**
 便利构造 （Contacts）
 
 @param contact 通讯录
 @return 对象
 */
- (instancetype)initWithCNContact:(CNContact *)contact;

/**
 便利构造 （AddressBook）
 
 @param record 记录
 @return 对象
 */
- (instancetype)initWithRecord:(ABRecordRef)record;

@end
#pragma mark -  电话类
/// 电话
@interface BBanPhone : NSObject

/**
 电话
 */
@property (nonatomic, copy) NSString *phone;

/**
 标签
 */
@property (nonatomic, copy) NSString *label;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  电子邮件类
/// 电子邮件
@interface BBanEmail : NSObject

/**
 邮箱
 */
@property (nonatomic, copy) NSString *email;

/**
 标签
 */
@property (nonatomic, copy) NSString *label;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  地址
/// 地址
@interface BBanAddress : NSObject

/**
 标签
 */
@property (nonatomic, copy) NSString *label;

/**
 街道
 */
@property (nonatomic, copy) NSString *street;

/**
 城市
 */
@property (nonatomic, copy) NSString *city;

/**
 州
 */
@property (nonatomic, copy) NSString *state;

/**
 邮政编码
 */
@property (nonatomic, copy) NSString *postalCode;

/**
 城市
 */
@property (nonatomic, copy) NSString *country;

/**
 国家代码
 */
@property (nonatomic, copy) NSString *ISOCountryCode;

/**
 标准格式化地址
 */
@property (nonatomic, copy) NSString *formatterAddress NS_AVAILABLE_IOS(9_0);

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  生日
/// 生日
@interface BBanBirthday : NSObject

/**
 生日日期
 */
@property (nonatomic, strong) NSDate *brithdayDate;

/**
 农历标识符（chinese）
 */
@property (nonatomic, copy) NSString *calendarIdentifier;

/**
 纪元
 */
@property (nonatomic, assign) NSInteger era;

/**
 年
 */
@property (nonatomic, assign) NSInteger year;

/**
 月
 */
@property (nonatomic, assign) NSInteger month;

/**
 日
 */
@property (nonatomic, assign) NSInteger day;

/**
 便利构造 （Contacts）
 
 @param contact 通讯录
 @return 对象
 */
- (instancetype)initWithCNContact:(CNContact *)contact;

/**
 便利构造 （AddressBook）
 
 @param record 记录
 @return 对象
 */
- (instancetype)initWithRecord:(ABRecordRef)record;

@end
#pragma mark -  即时通讯
/// 即时通讯
@interface BBanMessage : NSObject

/**
 即时通讯名字（QQ）
 */
@property (nonatomic, copy) NSString *service;

/**
 账号
 */
@property (nonatomic, copy) NSString *userName;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  社交
/// 社交
@interface BBanSocialProfile : NSObject

/**
 社交名字（Facebook）
 */
@property (nonatomic, copy) NSString *service;

/**
 账号
 */
@property (nonatomic, copy) NSString *username;

/**
 url字符串
 */
@property (nonatomic, copy) NSString *urlString;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  URL
/// URL
@interface BBanUrlAddress : NSObject

/**
 标签
 */
@property (nonatomic, copy) NSString *label;

/**
 url字符串
 */
@property (nonatomic, copy) NSString *urlString;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  关联人
/// 关联人
@interface BBanContactRelation : NSObject

/**
 标签（父亲，朋友等）
 */
@property (nonatomic, copy) NSString *label;

/**
 名字
 */
@property (nonatomic, copy) NSString *name;

/**
 便利构造 （Contacts）
 
 @param labeledValue 标签和值
 @return 对象
 */
- (instancetype)initWithLabeledValue:(CNLabeledValue *)labeledValue;

/**
 便利构造 （AddressBook）
 
 @param multiValue 标签和值
 @param index 下标
 @return 对象
 */
- (instancetype)initWithMultiValue:(ABMultiValueRef)multiValue index:(CFIndex)index;

@end
#pragma mark -  排序分组模型
/// 排序分组模型
@interface BBanSectionPerson : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSArray <BBanAddressPerson *> *persons;


@end
