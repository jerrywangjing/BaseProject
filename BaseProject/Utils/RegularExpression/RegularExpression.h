//
//  RegularExpression.h
//  wpb
//
//  Created by Gao on 14-2-8.
//  Copyright (c) 2014年 fuiou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpression : NSObject

#pragma mark - 手机号 校验
+ (BOOL)isValidateTelPhone:(NSString *)telphoneString;
#pragma mark - 电话号码，传真
+(BOOL)isValidatePhoneAndFax:(NSString *)phoneNumber;
#pragma mark - email 校验
+ (BOOL)isValidateEmail:(NSString *)emailString;
#pragma mark - 密码大小写英文字母和数字
+ (BOOL)isValidatePassword:(NSString *)string;

#pragma mark - 输入金额，只能是数字和小数点
+ (BOOL)isValidateAmount:(NSString *)string;
#pragma mark - 输入金额，只能是数字和小数点 全是正数
+(BOOL)isValidateAmountPositiveNum:(NSString *)string;

//必须包含有数字和字母
+ (BOOL) isValidateWithStr: (NSString *)string;

//只包含数字或字母:可以全是数字，也可以全是字母，还可以混合搭配。
+ (BOOL)isValidateNumLetter: (NSString *)string;
//全是数字或全是字母
+ (BOOL)isOnlyNumOrLetter:(NSString *)string;

#pragma mark - 银行卡 校验 //2银行卡,  16、18、19 位数字
+ (BOOL)isValidateBankCard:(NSString *)string;
#pragma mark - 身份证识别码 百度百科
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;
#pragma mark - 身份证 校验
+ (BOOL) isValidateIdentityCard: (NSString *)identityCard;
#pragma mark - 军官证 校验
+ (BOOL)isValidateOfficer:(NSString *)emailString;
#pragma mark - 护照 校验
+ (BOOL)isValidatePassport:(NSString *)string;
#pragma mark - 小于19位的数字 虚拟卡卡号校验
+ (BOOL)isValidateVCCard:(NSString *)string;



#pragma mark - phone ,emial, check

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
/*车牌号验证 MODIFIED BY HELENSONG*/
+(BOOL) validateCarNo:(NSString* )carNo;
/*用户名正则*/
+ (BOOL)validateUserName:(NSString *)userName;
/*密码正则*/
+ (BOOL)validatePassword:(NSString *)password;
/*身份证正则*/
+ (BOOL)validateMemberCardNo:(NSString *)cardNo;

+ (BOOL)checkRealName:(NSString *)name;

//检测字符是否可显示
+(BOOL)checkTextFormat:(NSString *)text;
//格式化卡号，每四位空一格
+ (NSString *)formattedStringWithBankCard:(NSString *)_number;

/**必须包含字母,数字,特殊字符的其中两种*/
+ (BOOL)checkPasswordFormat:(NSString *)text;

@end
