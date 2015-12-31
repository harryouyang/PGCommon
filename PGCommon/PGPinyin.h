//
//  PGPinyin.h
//  PGCommon
//
//  Created by ouyanghua on 15/10/15.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface PGPinyin : NSObject

+ (char)pinyinFirstLetter:(unsigned short)hanzi;

@end
