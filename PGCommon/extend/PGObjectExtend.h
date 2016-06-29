//
//  PGObjectExtend.h
//  PGCommon
//
//  Created by ouyanghua on 16/5/30.
//  Copyright © 2016年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PGCode)

- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

@end