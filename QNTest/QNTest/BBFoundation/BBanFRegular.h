//
//  BBanFRegular.h
//  BanBanLive
//
//  Created by 山神 on 2018/5/11.
//  Copyright © 2018年 伴伴网络. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 正则表达式工具
 */
@interface BBanFRegular : NSString

/**
 *  正则表达式判断手机号
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isMobileNumberJudgeObjc:(NSString *)objcName;
/**
 *  判断手机号是否有效
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isValidMobileNumberJudgeObjc:(NSString *)objcName;
/**
 *  判断邮箱
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isEmailAddressJudgeObjc:(NSString *)objcName;
/**
 *  判断身份证
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)simpleVerifyIdentityCardNumJudgeObjc:(NSString *)objcName;
/**
 *  判断车牌号
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */

+ (BOOL)isCarNumberJudgeObjc:(NSString *)objcName;
/**
 *  判断mac地址
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isMacAddressJudgeObjc:(NSString *)objcName;
/**
 *  判断URL
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isValidUrlJudgeObjc:(NSString *)objcName;

/**
 *  判断数字，字母，下划线，-，.，中文组成的一个字串
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isValidChineseJudgeObjc:(NSString *)objcName;
/**
 *  判断邮政编码
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isValidPostalcodeJudgeObjc:(NSString *)objcName;
/**
 *  判断TaxNo
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isValidTaxNoJudgeObjc:(NSString *)objcName;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/**
 匹配指定长度的字符
 
 @param minLenth 最小长
 @param maxLenth 最大长
 @param containChinese 是否包含中文
 @param firstCannotBeDigtal 首字母是否大写
 @param objcName 匹配的对象
 @return 1 匹配 0 不匹配
 */
+ (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                  jadgeObjc:(NSString *)objcName;

/**
 匹配指定字符
 
 @param minLenth 最小长度
 @param maxLenth 最大长度
 @param containChinese 是否包含中文
 @param containDigtal 是否包含数字
 @param containLetter 是否包含字母
 @param containOtherCharacter 其他特殊字符
 @param firstCannotBeDigtal 首字母是不是大写
 @param objcName 匹配的文字
 @return  1 匹配 0 不匹配
 */
+ (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal
                  jadgeObjc:(NSString *)objcName;
/**
 *  判断银行卡有效性
 *
 *  @param backNumber 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)bankCardluhmCheck:(NSString *)backNumber;
/**
 *  判断IP
 *
 *  @param IP 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isIPAddressWithIP:(NSString *)IP;
/**
 *  判断负浮点数
 *
 *  @param number 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isNegativeFloat:(id)number;
/**
 *  判断正浮点数
 *
 *  @param number 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isPositiveFloat:(id)number;
/**
 *  判断非正数
 *
 *  @param number 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isNoPositiveFloat:(id)number;
/**
 *  判断非负数
 *
 *  @param number 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isNoNegativeFloat:(id)number;

/**
 *  判断腾讯QQ
 *
 *  @param QQ 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isTencentQQ:(id)QQ;
/**
 *  判断空白行
 *
 *  @param objcName 用户输入的参数
 *
 *  @return 满足是1 不满足是0
 */
+ (BOOL)isBlankLine:(id)objcName;







@end
