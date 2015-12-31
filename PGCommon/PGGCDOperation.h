//
//  PGGCDOperation.h
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^operation_block)(void);

@interface PGOperationQueue : NSObject

+ (void)initOperationQueue:(uint)maxCount;

+ (void)addOperation:(NSOperation *)operation;

+ (void)addBlockOperation:(operation_block)block;

+ (void)addOperation:(id)target sel:(SEL)sel param:(id)param;

@end


#pragma mark -
@interface PGGCDOperation : NSObject

+ (void)initGCDOperation;

+ (void)addOperationBlock:(operation_block)block;

+ (void)addOperationBlocks:(operation_block)block,...;

+ (void)addOperationBlocksCompleteBlock:(operation_block)complete blocks:(operation_block)block,...;

+ (void)addAsyncOperationBlockOnMain:(operation_block)block;

+ (void)afterOnMain:(int64_t)delayInSeconds block:(operation_block)block;


@end
