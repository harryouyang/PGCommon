//
//  PGBaseObj.h
//  PGCommon
//
//  Created by ouyanghua on 15/12/23.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGBaseObj : NSObject

- (id)initWithDictionary:(NSDictionary *)dic;

- (NSString *)objectToJsonString;

- (NSDictionary *)objectToDictionary;

@end
