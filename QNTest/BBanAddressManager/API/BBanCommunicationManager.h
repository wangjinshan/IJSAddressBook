//
//  BBanCommunicationManager.h
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 通讯API管理类
 */
@interface BBanCommunicationManager : NSObject

/**
 打电话给某人,通过 openurl的方式

 @param phoneNumber 默认的电话
 */
+(void)callSomeBodyWithPhoneNumber:(NSString *)phoneNumber;

/**
 给某人打电话,通过UIWebView的方式

 @param phoneNumber 电话号码
 @param targetVc 当前的控制器
 */
+(void)callSomeBodyWithPhoneNumber:(NSString *)phoneNumber inViewController:(UIViewController *)targetVc;

/**
 发短信给某人,通过openurl的方式

 @param phoneNumber 发短信给某人
 */
+(void)sendMessageForSomeBodyWithPhoneNumber:(NSString *)phoneNumber;

/**
 给某人发短信附带短信的内容

 @param phoneNumbers 电话号码
 @param content 短信的内容
 @param delegateVc 当前的控制器
 @return 短信是否发送成功
 */

+ (BOOL)sendMessageForSomeBodyWithPhoneNumbers:(NSArray<NSString *> *)phoneNumbers content:(NSString *)content delegateVc:(UIViewController *)delegateVc;

/**
 给某人发邮件

 @param address 邮件地址
 */
+ (void)sendMailForSomeBodyWithAddress:(NSString *)address;

/**
 *  可以设置邮件的主题等具体内容（可以返回原应用）
 *  @param receivers      收件人列表
 *  @param copyers        抄送人列表
 *  @param secretors      密送人列表
 *  @param theme          主题
 *  @param content        邮件内容
 *  @param contentIsHTML  内容是否是HTML
 *  @param attachment     附件数据
 *  @param attachmentName 附件名称
 *  @param attachmentType 附件MIME类型（如：image/jpeg）
 *  @param delegateVc     要发送邮件的控制器
 *
 *  @return 是否发送成功
 */
+ (BOOL)sendMailToReceivers:(NSArray *)receivers copyers:(NSArray *)copyers secretors:(NSArray *)secretors theme:(NSString *)theme content:(NSString *)content contentIsHTML:(BOOL)contentIsHTML attachment:(NSData *)attachment attachmentName:(NSString *)attachmentName attachmentType:(NSString *)attachmentType showInViewController:(UIViewController *)delegateVc;


@end

#pragma mark - 为控制器增加打电话所需要的WebView

@interface UIViewController (BBanCommunicationCategory)

@property (nonatomic, strong) UIWebView* callIssueWebView;

@end
