//
//  PGNSStringExtend.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PGNSStringExtend)

- (NSInteger)cLength;

+ (NSString*)ReplaceString:(NSString*)str replacekv:(NSMutableDictionary*)kv;

- (NSString*)TransformToFirstLetter:(NSString*)szStr;

+ (BOOL)IsImageExtension:(NSString*)szFilename;

//- (NSString *)findLetter:(int)nCode;

//- (NSMutableArray *) getPinYinFromChiniseString:(NSString *)string;

//+ (NSMutableDictionary*)SortByPinYin:(NSMutableArray*)arEntcontact Name:(NSString*(^)(id obj))obj PinYinName:(void(^)(int nIndex,NSMutableArray* arPinyinname))pinyinname ComparePinYinName:(NSMutableArray*(^)(id obj))compare;

+ (BOOL)IsNumberString:(NSString *)str;
- (BOOL)IsNumberString;

+ (BOOL)isEmailString:(NSString*)str;
- (BOOL)isEmailString;

+ (BOOL)isEnglishString:(NSString*)str;
- (BOOL)isEnglishString;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isMobileNumber;

+ (BOOL)isIDCard:(NSString *)szIDCard;
- (BOOL)isIDCard;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString *)disable_emoji:(NSString *)text;

+ (NSString *)flattenHTML:(NSString *)html;

//这段代码一般用于网络编程。从服务器获得的数据一般是Unicode格式字符串，要正确显示需要转换成中文编码。
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

#pragma mark encode
+ (NSString *)URLEncodedString:(NSString *)string;
+ (NSString *)URLDecodedString:(NSString *)string;

+ (NSString *)MD5Encrypt:(NSString *)string;
+ (NSString *)MD5_Base64:(NSString *)string;

+ (NSString *)stringByBase64String:(NSString *)base64String;
+ (NSString *)base64StringBystring:(NSString *)string;

#pragma mark json
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)jsonStringWithArray:(NSArray *)array;

+ (NSString *)jsonStringWithString:(NSString *)string;

+ (NSString *)jsonStringWithObject:(id)object;

#pragma mark encrypt
//使用Base64+DES
+ (NSString *)encryptWithText:(NSString *)sText key:(NSString *)sKey;
+ (NSString *)decryptWithText:(NSString *)sText key:(NSString *)sKey;

//纯DES
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;  
@end
