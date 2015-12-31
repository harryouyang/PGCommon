//
//  PGFileManager.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGFileManager : NSObject

+ (NSString *)shareDocumentPath;

+ (NSString *)getTempPath;

+ (BOOL)createDirectory:(NSString *)szPath error:(NSError **)error;

+ (BOOL)createFileAtPath:(NSString *)szPath contents:(NSData *)data;

+ (BOOL)isFileDirectoryExist:(NSString *)szPath;

+ (BOOL)deleteFileDirectory:(NSString *)szPath error:(NSError **)error;

+ (BOOL)copyFile:(NSString *)szSrcPath toPath:(NSString *)szTargetPath error:(NSError **)error;

+ (BOOL)moveFile:(NSString *)szSrcPath toPath:(NSString *)szTargetPath error:(NSError **)error;

+ (unsigned long long)getFileSize:(NSString *)szPath;

+ (BOOL)isEmptyDirectory:(NSString *)szPath;

+ (NSArray *)getAllFileAtPath:(NSString *)szPath;

@end
