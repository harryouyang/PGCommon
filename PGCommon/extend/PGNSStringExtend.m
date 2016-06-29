//
//  PGNSStringExtend.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGNSStringExtend.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "PGGTMBase64.h"
#import "PGBaseObj.h"

@implementation NSString (PGNSStringExtend)

- (NSInteger)cLength
{
    NSInteger result = 0;
    const char *tchar=[self UTF8String];
    if (NULL == tchar) {
        return result;
    }
    
    result = strlen(tchar);
    
    return result;
}

+ (NSString*)ReplaceString:(NSString*)str replacekv:(NSMutableDictionary*)kv
{
	NSMutableString* s=[[NSMutableString alloc]init];
	[s setString:str];
	NSArray* ar=[kv allKeys];
	for(NSString* k in ar)
	{
		[s replaceOccurrencesOfString:k withString:[kv objectForKey:k] options:NSCaseInsensitiveSearch range:NSMakeRange(0,s.length)];
	}
	return [s autorelease];
}

- (NSString*)TransformToLetter:(int)nCode
{
	if(nCode >= 1601 && nCode < 1637) return @"A";
	if(nCode >= 1637 && nCode < 1833) return @"B";
	if(nCode >= 1833 && nCode < 2078) return @"C";
	if(nCode >= 2078 && nCode < 2274) return @"D";
	if(nCode >= 2274 && nCode < 2302) return @"E";
	if(nCode >= 2302 && nCode < 2433) return @"F";
	if(nCode >= 2433 && nCode < 2594) return @"G";
	if(nCode >= 2594 && nCode < 2787) return @"H";
	if(nCode >= 2787 && nCode < 3106) return @"J";
	if(nCode >= 3106 && nCode < 3212) return @"K";
	if(nCode >= 3212 && nCode < 3472) return @"L";
	if(nCode >= 3472 && nCode < 3635) return @"M";
	if(nCode >= 3635 && nCode < 3722) return @"N";
	if(nCode >= 3722 && nCode < 3730) return @"O";
	if(nCode >= 3730 && nCode < 3858) return @"P";
	if(nCode >= 3858 && nCode < 4027) return @"Q";
	if(nCode >= 4027 && nCode < 4086) return @"R";
	if(nCode >= 4086 && nCode < 4390) return @"S";
	if(nCode >= 4390 && nCode < 4558) return @"T";
	if(nCode >= 4558 && nCode < 4684) return @"W";
	if(nCode >= 4684 && nCode < 4925) return @"X";
	if(nCode >= 4925 && nCode < 5249) return @"Y";
	if(nCode >= 5249 && nCode < 5590) return @"Z";
	return nil;
}

- (NSString*)TransformToFirstLetter:(NSString*)szStr
{
    NSString* szLetter=nil;
    
	UInt8 ucHigh=0, ucLow=0;
	int nCode=0;
    
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char* ascii=[szStr cStringUsingEncoding:enc];
    
    if((UInt8)ascii[0]<0x80 )
        goto FUNEXIT;
    
    ucHigh=(UInt8)ascii[0];
    ucLow=(UInt8)ascii[1];
    if(ucHigh<0xa1||ucLow<0xa1)
        goto FUNEXIT;
    else
        nCode=(ucHigh-0xa0)*100+ucLow-0xa0;
    szLetter=[self TransformToLetter:nCode];
FUNEXIT:
	return szLetter;
}

/*
+ (NSMutableDictionary*)SortByPinYin:(NSMutableArray*)arEntcontact Name:(NSString*(^)(id obj))obj PinYinName:(void(^)(int nIndex,NSMutableArray* arPinyinname))pinyinname ComparePinYinName:(NSMutableArray*(^)(id obj))compare
{
    NSMutableDictionary* sort=[[NSMutableDictionary alloc]init];
    
    for(int i=0;i<arEntcontact.count;i++)
    {
        NSString* szName=obj([arEntcontact objectAtIndex:i]);
        NSMutableArray* arPinyinname=nil;
        NSString* szFirstletter=nil;
        if(szName.length>0)
        {
            //获取名字的拼音数组
            arPinyinname=[szName getPinYinFromChiniseString:szName];
            
            if (arPinyinname.count>0 && ((NSString*)[arPinyinname objectAtIndex:0]).length>0 )
            {
                NSString *lastName=[arPinyinname objectAtIndex:0];
                szFirstletter=[NSString stringWithFormat:@"%c",[lastName characterAtIndex:0]];
            }
            else if(YES==[szName isEnglishString])
            {
                szFirstletter=[[NSString stringWithFormat:@"%c",[szName characterAtIndex:0]] uppercaseString];
                arPinyinname=[[NSMutableArray alloc] init];
                [arPinyinname addObject:szName];
            }
            else
            {
                szFirstletter=@"其他";
                arPinyinname=[[NSMutableArray alloc] init];
                [arPinyinname addObject:szName];
            }
        }
        else
        {
            szFirstletter=@"其他";
            arPinyinname=[[NSMutableArray alloc] init];
            if (szName!=nil) {
                [arPinyinname addObject:szName];
            }else{
                [arPinyinname addObject:@""];
            }
        }
        pinyinname(i,arPinyinname);
        NSMutableArray* ar=[sort objectForKey:szFirstletter];
        if(nil==ar)
        {
            ar=[[NSMutableArray alloc]init];
            [sort setObject:ar forKey:szFirstletter];
        }
        if (ar.count>0 )
        {
            //通过szName拼音比较（按升序排序），插入contact
            for (int j=0; j<ar.count; j++)
            {
                NSMutableArray* arCompare=compare([ar objectAtIndex:j]);
                int index=0;
                if (arPinyinname.count>arCompare.count)
                {
                    
                    for ( int k=0;k<arPinyinname.count; k++)
                    {
                        NSString *nameStr;
                        NSString *targetNameStr=[arPinyinname objectAtIndex:k];
                        if (arCompare.count>k)
                        {
                            nameStr=[arCompare objectAtIndex:k];
                            
                        }else
                        {
                            break;
                        }
                        NSComparisonResult result=[targetNameStr compare:nameStr];
                        if ( result==NSOrderedSame) {
                            continue;
                        }
                        if (result==NSOrderedDescending) {
                            break;
                        }
                        if (result==NSOrderedAscending) {
                            [ar insertObject:[arEntcontact objectAtIndex:i] atIndex:j];
                            index++;
                            break;
                        }
                    }
                }else
                {
                    for ( int k=0;k<arCompare.count ; k++)
                    {
                        NSString *targetNameStr;
                        NSString *nameStr=[arCompare objectAtIndex:k];
                        if (arPinyinname.count>k)
                        {
                            targetNameStr=[arPinyinname objectAtIndex:k];
                        }else
                        {
                            [ar insertObject:[arEntcontact objectAtIndex:i] atIndex:j];
                            index++;
                            break;
                        }
                        NSComparisonResult result=[targetNameStr compare:nameStr];
                        if ( result==NSOrderedSame) {
                            continue;
                        }
                        if (result==NSOrderedDescending) {
                            break;
                        }
                        if (result==NSOrderedAscending) {
                            [ar insertObject:[arEntcontact objectAtIndex:i] atIndex:j];
                            index++;
                            break;
                        }
                    }
                }
                if (index==0)
                {
                    if (ar.count-1==j)
                    {
                        [ar insertObject:[arEntcontact objectAtIndex:i] atIndex:ar.count];
                        break;
                    }else
                    {
                        continue;
                    }
                }else
                {
                    break;
                }
            }
            
        }else
        {
            [ar addObject:[arEntcontact objectAtIndex:i]];
        }
    }
    
    return sort;
}
 */

+ (BOOL)IsImageExtension:(NSString*)szFilename
{
    NSString* ext=[szFilename pathExtension];
    return [ext isEqualToString:@"png"]||[ext isEqualToString:@"jpg"];
}

+ (BOOL)IsNumberString:(NSString *)str
{
    if(str.length<=0)
        return NO;
    
	NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
											  initWithPattern:@"^[\\+-]?(?:|0|[0-9]\\d{0,})(?:\\.\\d*)?$"
											  options:NSRegularExpressionCaseInsensitive
											  error:nil];
	NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
																  options:NSMatchingReportProgress
																	range:NSMakeRange(0, str.length)];
    [regularexpression release];
	
	if(numberofMatch > 0)
		return YES;
	
	return NO;
}

- (BOOL)IsNumberString
{
    return [NSString IsNumberString:self];
}

+ (BOOL)isEmailString:(NSString*)str
{
    NSString* exp=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; //@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
    NSPredicate* Predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",exp];
    return [Predicate evaluateWithObject:str];
}

- (BOOL)isEmailString
{
    return [NSString isEmailString:self];
}

+ (BOOL)isEnglishString:(NSString*)str
{
    NSString* exp=@"^[A-Za-z]+$";
    NSPredicate* Predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",exp];
    return [Predicate evaluateWithObject:str];
}

- (BOOL)isEnglishString
{
    return [NSString isEnglishString:self];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：139,138,137,136,135,134[0-8],147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,155,156,185,186,145
     * 电信：133,1349,153,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|4[57])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|47)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,155,156,185,186,145
     17         */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|45)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isMobileNumber
{
    return [NSString isMobileNumber:self];
}

#pragma mark -
const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表

+ (BOOL)isIDCard:(NSString *)szIDCard
{
    BOOL result = NO;
    if(szIDCard==nil)
    {
        result = NO;
    }
    else if(szIDCard.length == 18)
    {
        char *ID = (char *)[szIDCard UTF8String];
        int IDNumber[19];
        for(int i = 0; i < 18; i ++)//相当于类型转换
            IDNumber[i] = ID[i] - 48;
        
        
        int checksum = 0;
        for (int i = 0; i < 17; i ++ )
            checksum += IDNumber[i] * factor[i];
        
        if (IDNumber[17] == checktable[checksum % 11] || (ID[17] == 'x' && checktable[checksum % 11] == 10))
            result = YES;
        else
            result = NO;
    }
    else if(szIDCard.length == 15)
    {
        if([szIDCard compare:@"111111111111111"] == NSOrderedSame)
            result = NO;
        else
        {
            NSString *strDate = [NSString stringWithFormat:@"19%@",[szIDCard substringWithRange:NSMakeRange(6, 6)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSDate *date=[dateFormatter dateFromString:strDate];
            if(date != nil)
                result = YES;
            else
                result = NO;
            [dateFormatter release];
        }
    }
    else
    {
        result = NO;
    }
    return result;
}

- (BOOL)isIDCard
{
    return [NSString isIDCard:self];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (substring.length > 1)
            {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    returnValue = YES;
                }
            }
        }
        else if(substring.length > 1)
        {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3)
            {
                returnValue = YES;
            }
        }
        else
        {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff)
            {
                returnValue = YES;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07)
            {
                returnValue = YES;
            }
            else if (0x2934 <= hs && hs <= 0x2935)
            {
                returnValue = YES;
            }
            else if (0x3297 <= hs && hs <= 0x3299)
            {
                returnValue = YES;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
            {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

+ (NSString *)flattenHTML:(NSString *)html
{
    NSString *text = nil;
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    while([theScanner isAtEnd] == NO)
    {
        [theScanner scanUpToString:@"<" intoString:NULL];
        [theScanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return html;
}

//这段代码一般用于网络编程。从服务器获得的数据一般是Unicode格式字符串，要正确显示需要转换成中文编码。
// NSString值为Unicode格式的字符串编码(如\u7E8C)转换成中文
//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
//    PGLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

#pragma mark encode
+ (NSString *)URLEncodedString:(NSString *)string
{
    NSString *newString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(                       kCFAllocatorDefault,(CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease]);
    if (newString) {
        return newString;
    }
    return @"";
    
    //    NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    //    return encodeString;
}

+ (NSString *)URLDecodedString:(NSString *)string
{
    NSString *resultString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8));
    return resultString;
}

+ (NSString *)MD5Encrypt:(NSString *)string
{
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X",result[i]];
    return [hash lowercaseString];
}

/// Returns:
// A new autoreleased NSString with Base64 encoded NSString
+ (NSString *)stringByBase64String:(NSString *)base64String
{
    NSString *sourceString = [[NSString alloc] initWithData:[PGGTMBase64 decodeData:[base64String dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]] encoding:NSUTF8StringEncoding];
    return [sourceString autorelease];
}

/// Returns:
// A new autoreleased Base64 encoded NSString with NSString
+ (NSString *)base64StringBystring:(NSString *)string
{
    NSString *base64String = [[NSString alloc] initWithData:[PGGTMBase64 encodeData:[string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]] encoding:NSUTF8StringEncoding];
    return [base64String autorelease];
}

+ (NSString *)MD5_Base64:(NSString *)string
{
    NSString *base64String = @"";
    if (string.length >0) {
        const char *original_str = [string UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(original_str, strlen(original_str), result);
        
        base64String = [[[NSString alloc] initWithData:[PGGTMBase64 encodeBytes:result length:CC_MD5_DIGEST_LENGTH] encoding:NSUTF8StringEncoding] autorelease];
    }
    return base64String;
}

#pragma mark json
+ (NSString *) jsonStringWithString:(NSString *)string
{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithPGObj:(PGBaseObj *)obj
{
    if(obj != nil && [obj respondsToSelector:@selector(objectToJsonString)])
    {
        return (NSString *)[obj objectToJsonString];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)jsonStringWithNumber:(NSNumber *)number
{
    return number.stringValue;
}

+ (NSString *) jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array)
    {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value)
        {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++)
    {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value)
        {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *) jsonStringWithObject:(id)object
{
    NSString *value = nil;
    if (!object)
    {
        return value;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]])
    {
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]])
    {
        value = [NSString jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSNumber class]])
    {
        value = [NSString jsonStringWithNumber:object];
    }else if([object isKindOfClass:[PGBaseObj class]])
    {
        value = [NSString jsonStringWithPGObj:object];
    }
    return value;
}

#pragma mark encrypt
+ (NSString *)encryptWithText:(NSString *)sText key:(NSString *)sKey
{
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:sKey];
}

+ (NSString *)decryptWithText:(NSString *)sText key:(NSString *)sKey
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:sKey];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [PGGTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] autorelease];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [PGGTMBase64 stringByEncodingData:data];
    }
    
    free(dataOut);
    return result;
}

+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCBlockSizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self stringWithHexBytes2:data];
    }
    else
    {
        NSLog(@"DES加密失败");
    }
    
    free(buffer);
    return ciphertext;
}

+ (NSString *)decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    NSData *textData = [self parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else
    {
        NSLog(@"DES解密失败");
    }
    
    free(buffer);
    return [cleartext autorelease];
}

//nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender
{
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i)
    {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}

/*
 将16进制数据转化成NSData 数组
 */
+ (NSData*)parseHexToByteArray:(NSString*)hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return [newData autorelease];
}

+ (NSString *)parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr autorelease];
}

+ (NSString *)parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[[NSMutableString alloc]init] autorelease];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}

@end
