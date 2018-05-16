//
//  BBanCommunicationManager.m
//  BBanAddressDemo
//
//  Created by 山神 on 2018/5/16.
//  Copyright © 2018年 LeeJay. All rights reserved.
//

#import "BBanCommunicationManager.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>
#import "BBanFoundation.h"

@interface BBanCommunicationManager()
@property(nonatomic,strong) UILabel *alertView;  // 弹框
@end

@implementation BBanCommunicationManager

#pragma mark -  打电话
// 打电话
+(void)callSomeBodyWithPhoneNumber:(NSString *)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}
/// 打电话
+(void)callSomeBodyWithPhoneNumber:(NSString *)phoneNumber inViewController:(UIViewController *)targetVc
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    targetVc.callIssueWebView = webView;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}
#pragma mark -  发短信
/// 发短信
+(void)sendMessageForSomeBodyWithPhoneNumber:(NSString *)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}
/// 发短信
+ (BOOL)sendMessageForSomeBodyWithPhoneNumbers:(NSArray<NSString *> *)phoneNumbers content:(NSString *)content delegateVc:(UIViewController *)delegateVc
{
    NSAssert(delegateVc, @"必须传入有效的调用该方法的控制器");
    // 1. 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText])
    {// 发送失败 用户设备无法发送短信
        return NO;
    }
    MFMessageComposeViewController *messageVc = [MFMessageComposeViewController new];     // 2. 实例化短信控制器
    // 3. 设置短信内容
    [messageVc setRecipients:phoneNumbers];  // 设置收件人
    [messageVc setBody:content];      // 设置短信内容
    messageVc.messageComposeDelegate = (UIViewController<MFMessageComposeViewControllerDelegate> *)delegateVc;     // 4. 设置代理
    // 5. 显示短信控制器
    [delegateVc presentViewController:messageVc animated:YES completion:^{
        
        // 设置delegateVc 中短信控制器关闭的代理方法回调
        // 代理控制器的回调方法
        Method delegateCallBackMethod = class_getInstanceMethod([delegateVc class], @selector(messageComposeViewController:didFinishWithResult:));
        // 工具类中回调方法实现, 获取这个类的实例方法
        Method implementationMethod = class_getInstanceMethod(self, @selector(messageComposeViewController:didFinishWithResult:));
        IMP implementation = method_getImplementation(implementationMethod); // 获取本类的方法指针
        // 设置控制器中的回调方法实现
        // 如果没有代理方法，那么就动态添加
        if (!delegateCallBackMethod)
        {  // 给外部的控制器添加下面的代理方法
            class_addMethod([delegateVc class], @selector(messageComposeViewController:didFinishWithResult:), implementation, "v@:@i");
        }
        else
        { // 如果有代理方法，则替换其实现, IMP 指针指向本类的实现
            method_setImplementation(delegateCallBackMethod, implementation);
        }
    }];
    return YES;
}
// 本类直接实现发送短信的回调方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    /**
     MessageComposeResultCancelled,     取消
     MessageComposeResultSent,          发送
     MessageComposeResultFailed         失败
     */
    NSString *resultAlert; // 操作结果提示
    switch (result)
    {
        case MessageComposeResultCancelled:
            // 取消
            resultAlert = @"取消发送";
            break;
        case MessageComposeResultSent:
            // 已经发送
            resultAlert = @"发送成功";
            break;
        case MessageComposeResultFailed:
            // 已经失败
            resultAlert = @"发送失败";
            break;
            
        default:
            break;
    }
    // 提示操作结果
     [BBanCommunicationManager showAlertViewWithTitle:resultAlert];
    [controller dismissViewControllerAnimated:YES completion:nil]; // 这种方法也是可以的，因为系统会将关闭消息发送回给self
}

#pragma mark -  发送邮件
+ (void)sendMailForSomeBodyWithAddress:(NSString *)address
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", address]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)sendMailToReceivers:(NSArray *)receivers copyers:(NSArray *)copyers secretors:(NSArray *)secretors theme:(NSString *)theme content:(NSString *)content contentIsHTML:(BOOL)contentIsHTML attachment:(NSData *)attachment attachmentName:(NSString *)attachmentName attachmentType:(NSString *)attachmentType showInViewController:(UIViewController *)delegateVc
{
    NSAssert(delegateVc, @"必须传入有效的调用该方法的控制器！");
    // 1. 判断是否能发邮件
    if (![MFMailComposeViewController canSendMail])
    {// 发送失败  提示用户检查邮箱设置
        return NO;
    }
    // 2. 实例化邮件控制器
    MFMailComposeViewController *mailVc = [MFMailComposeViewController new];
    // 3. 设置邮件内容
    [mailVc setToRecipients:receivers];      // 设置收件人列表
    [mailVc setCcRecipients:copyers];        // 设置抄送人列表
    [mailVc setBccRecipients:secretors];       // 设置密送人列表
    [mailVc setSubject:theme];                          // 设置邮件主题
    [mailVc setMessageBody:content isHTML:contentIsHTML];    // 设置邮件内容
    [mailVc addAttachmentData:attachment mimeType:attachmentType fileName:attachmentName];      // 设置邮件附件
    mailVc.mailComposeDelegate  = (UIViewController<MFMailComposeViewControllerDelegate> *)delegateVc;    // 4. 设置代理
    // 5. 显示邮件控制器
    [delegateVc presentViewController:mailVc animated:YES completion:^{
        // 设置delegateVc中邮件控制器关闭的代理方法回调
        // 代理控制器的回调方法
        Method delegateCallBackMethod = class_getInstanceMethod([delegateVc class], @selector(mailComposeController:didFinishWithResult:error:));
        // 工具类中的回调方法实现
        Method implementationMethod = class_getInstanceMethod(self, @selector(mailComposeController:didFinishWithResult:error:));
        IMP implementation = method_getImplementation(implementationMethod);
        // 设置代理控制器中回调方法的实现
        // 如果没有代理方法，那么就动态添加
        if (!delegateCallBackMethod)
        {
            class_addMethod([delegateVc class], @selector(mailComposeController:didFinishWithResult:error:), implementation, "v@:@i@");
        }
        else
        {
            // 如果有代理方法，则替换其实现
            method_setImplementation(delegateCallBackMethod, implementation);
        }
    }];
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    /**
     MFMailComposeResultCancelled,      取消
     MFMailComposeResultSaved,          保存邮件
     MFMailComposeResultSent,           已经发送
     MFMailComposeResultFailed          发送失败
     */
    NSString *resultAlert; // 操作结果提示
    switch (result) {
        case MFMailComposeResultCancelled:
            // 取消
            resultAlert = @"取消发送";
            break;
        case MFMailComposeResultSaved:
            // 保存邮件
            resultAlert = @"邮件已保存到草稿箱";
            break;
        case MFMailComposeResultSent:
            // 已经发送
            resultAlert = @"邮件已发送";
            break;
        case MFMailComposeResultFailed:
            // 发送失败
            resultAlert = @"邮件发送失败";
            break;
            
        default:
            break;
    }
    // 提示操作结果
      [BBanCommunicationManager showAlertViewWithTitle:resultAlert];
    [controller dismissViewControllerAnimated:YES completion:nil]; // 这种方法也是可以的，因为系统会将关闭消息发送回给self
}
/// 弹框
+(UILabel *)showAlertViewWithTitle:(NSString *)title
{
    UILabel *tell =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    tell.backgroundColor = [UIColor colorWithRed:208 / 255.0f green:208 / 255.0f blue:208 / 255.0f alpha:1];
    tell.layer.cornerRadius = 5;
    tell.layer.masksToBounds = YES;
    tell.textAlignment = NSTextAlignmentCenter;
    tell.center = [BBanFViewController currentViewController].view.center;
    tell.text = title;
    [[UIApplication sharedApplication].keyWindow addSubview:tell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tell removeFromSuperview];
    });
    return tell;
}

@end

#pragma mark - 为控制器增加打电话所需要的WebView
@implementation UIViewController (BBanCommunicationCategory)

- (UIWebView *)callIssueWebView
{
    return objc_getAssociatedObject(self, "callIssueWebView");
}

- (void)setCallIssueWebView:(UIWebView *)callIssueWebView
{
    objc_setAssociatedObject(self, "callIssueWebView", callIssueWebView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
