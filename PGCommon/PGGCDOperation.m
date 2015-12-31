//
//  PGGCDOperation.m
//  PanguCommonLib
//
//  Created by ouyanghua on 14-2-22.
//  Copyright (c) 2014年 pangu. All rights reserved.
//

#import "PGGCDOperation.h"

@implementation PGOperationQueue

static NSOperationQueue *s_operationQueue = nil;

+ (void)initOperationQueue:(uint)maxCount
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_operationQueue = [[NSOperationQueue alloc]init];
        s_operationQueue.maxConcurrentOperationCount = maxCount;
    });
}

+ (void)addOperation:(NSOperation *)operation
{
    [s_operationQueue addOperation:operation];
}

+ (void)addBlockOperation:(operation_block)block
{
    NSBlockOperation *blockoperation = [[NSBlockOperation alloc]init];
    [blockoperation addExecutionBlock:block];
    [s_operationQueue addOperation:blockoperation];
}

+ (void)addOperation:(id)target sel:(SEL)sel param:(id)param
{
    NSInvocationOperation* invocation=[[NSInvocationOperation alloc]initWithTarget:target selector:sel object:param];
    [s_operationQueue addOperation:invocation];
}

@end


#pragma mark -
@implementation PGGCDOperation

static dispatch_queue_t s_gcdQueue = nil;

+ (void)initGCDOperation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_gcdQueue = dispatch_queue_create("gcdQueue", nil);
    });
}

+ (void)addOperationBlock:(operation_block)block
{
    dispatch_async(s_gcdQueue, block);
}

+ (void)addOperationBlocks:(operation_block)block,...
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    operation_block eachblock;
    va_list argumentList;
    if(block)
    {
        dispatch_group_async(group, queue, block);
        
        va_start(argumentList, block);
        eachblock = va_arg(argumentList, operation_block);
        while(eachblock)
        {
            dispatch_group_async(group, queue, eachblock);
            eachblock = va_arg(argumentList, operation_block);
        }
        
        va_end(argumentList);
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
#if !OS_OBJECT_USE_OBJC   //这个宏是在sdk6.0之后才有的,如果是之前的,则OS_OBJECT_USE_OBJC为0
    dispatch_release(group);
#endif
    
}

+ (void)addOperationBlocksCompleteBlock:(operation_block)complete blocks:(operation_block)block,...
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    operation_block eachblock;
    va_list argumentList;
    if(block)
    {
        dispatch_group_async(group, queue, block);
        
        va_start(argumentList, block);
        eachblock = va_arg(argumentList, operation_block);
        while(eachblock)
        {
            dispatch_group_async(group, queue, eachblock);
            eachblock = va_arg(argumentList, operation_block);
        }
        
        va_end(argumentList);
    }
    
    dispatch_group_notify(group, queue, complete);
    
#if !OS_OBJECT_USE_OBJC   //这个宏是在sdk6.0之后才有的,如果是之前的,则OS_OBJECT_USE_OBJC为0
    dispatch_release(group);
#endif
}

+ (void)addAsyncOperationBlockOnMain:(operation_block)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (void)afterOnMain:(int64_t)delayInSeconds block:(operation_block)block
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),block);
}


@end
