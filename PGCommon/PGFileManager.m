//
//  PGFileManager.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGFileManager.h"

@implementation PGFileManager

+ (NSString *)shareDocumentPath
{
    static NSString *s_szDocumentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_szDocumentPath = [[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    });
    return s_szDocumentPath;
}

+ (NSString *)getTempPath
{
    return NSTemporaryDirectory();
}

+ (BOOL)createDirectory:(NSString *)szPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:szPath withIntermediateDirectories:NO attributes:nil error:error];
}

+ (BOOL)createFileAtPath:(NSString *)szPath contents:(NSData *)data
{
    return [[NSFileManager defaultManager] createFileAtPath:szPath contents:data attributes:nil];
}

+ (BOOL)isFileDirectoryExist:(NSString *)szPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:szPath];
}

+ (BOOL)deleteFileDirectory:(NSString *)szPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:szPath error:error];
}

+ (BOOL)copyFile:(NSString *)szSrcPath toPath:(NSString *)szTargetPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] copyItemAtPath:szSrcPath toPath:szTargetPath error:error];
}

+ (BOOL)moveFile:(NSString *)szSrcPath toPath:(NSString *)szTargetPath error:(NSError **)error
{
    return [[NSFileManager defaultManager] moveItemAtPath:szSrcPath toPath:szTargetPath error:error];
}

+ (unsigned long long)getFileSize:(NSString *)szPath
{
    long long nFilesize=0;
	NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:szPath];
	nFilesize = [handle seekToEndOfFile];
	[handle closeFile];
	return nFilesize;
}

+ (BOOL)isEmptyDirectory:(NSString *)szPath
{
    NSArray *arResult = nil;
    NSArray* arList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:szPath error:nil];
    if(arList != nil)
    {
        NSMutableArray *arTemp = [[NSMutableArray alloc]init];
        for(NSString *strpath in arList)
        {
            if([strpath compare:@".DS_Store"]!=NSOrderedSame)
                [arTemp addObject:strpath];
        }
        
        if(arTemp.count > 0)
        {
            arResult = [NSArray arrayWithArray:arTemp];
        }
    }
    
    return (arResult == nil);
}

+ (NSArray *)getAllFileAtPath:(NSString *)szPath
{
    NSArray *arResult = nil;
    NSArray* arList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:szPath error:nil];
    if(arList != nil)
    {
        NSMutableArray *arTemp = [[NSMutableArray alloc]init];
        for(NSString *strpath in arList)
        {
            if([strpath compare:@".DS_Store"]!=NSOrderedSame)
                [arTemp addObject:strpath];
        }
        
        if(arTemp.count > 0)
        {
            arResult = [NSArray arrayWithArray:arTemp];
        }
    }
    
    return arResult;
}

@end
