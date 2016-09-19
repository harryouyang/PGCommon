//
//  PGDictionaryExtent.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum dictionType
{
    EDictionTypeNSString = 0,
    EDictionTypeInt,
    EDictionTypeInteger,
    EDictionTypeLong,
    EDictionTypeLongLong,
    EDictionTypeFloat,
    EDictionTypeDouble,
    EDictionTypeBool,
    EDictionTypeDate,
}EDictionType;

@interface NSDictionary (PGDictionExtent)

- (id)objectForKey:(id)aKey type:(EDictionType)type;

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end

#pragma mark -
@interface NSDictionary (LogHelper)

#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale;
#endif

@end
