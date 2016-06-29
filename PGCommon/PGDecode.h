//
//  PGDecode.h
//  PGCommon
//
//  Created by ouyanghua on 16/5/30.
//  Copyright © 2016年 PG. All rights reserved.
//

#ifndef PGDecode_h
#define PGDecode_h

#import "PGObjectExtend.h"

#define CodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder {\
if (self = [super init]) {\
[self decode:aDecoder];\
}\
return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder {\
[self encode:aCoder];\
}

#endif /* PGDecode_h */
